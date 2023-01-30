package main

import (
	"io/ioutil"
	"database/sql"
	"encoding/json"
	"encoding/hex"
	"fmt"
	_ "github.com/go-sql-driver/mysql"
	"github.com/gorilla/mux"
	"github.com/tkanos/gonfig"
	"log"
	"net/http"
    "crypto/sha256"
    "strconv"
    "time"
)

var db *sql.DB
var err error
var configuration Config
var tablesWithUser = map[string]bool {
    "registered_feces": true,
    "registered_meal": true,
    "registered_supplement": true,
    "registered_symptom": true,
    "v_user_symptoms": true,
    "v_user_anything": true,
    "v_all_entries": true,
}

type Config struct {
	DB_USERNAME string
	DB_PASSWORD string
	DB_PORT     string
	DB_HOST     string
	DB_NAME     string
	HASH_NOISE  string
}

func GetConfiguration() Config {
	config := Config{}
	fileName := "./conf.json"
	gonfig.GetConf(fileName, &config) 
	return config
}

func checkUser(user_id int, sha string) bool {	
	loc, _ := time.LoadLocation("Europe/Madrid")
	now := time.Now().In(loc)
	sec := now.Unix() % 2147483648
	
	for i := 0; i < 5; i++ {
		plain := strconv.Itoa(user_id) + configuration.HASH_NOISE + strconv.Itoa(int(sec) - i)
		fmt.Println("plain ", plain)
		
		h := sha256.Sum256([]byte(plain))	
		hash_string := hex.EncodeToString(h[:])	
		fmt.Println("hash_string ", hash_string)
		if(hash_string == sha){
			return true
		}
	}
	fmt.Println("sha ", sha)
	return false
}

func homePage(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Welcome to the HomePage!")
	fmt.Println("Endpoint Hit: homePage")
}

func connect() {
	db, err = sql.Open("mysql", configuration.DB_USERNAME+":"+configuration.DB_PASSWORD+
		"@tcp(127.0.0.1:"+configuration.DB_PORT+")/"+configuration.DB_NAME)
	if err != nil {
		panic("error connectiong to mysql " + err.Error())
	}

	err = db.Ping()
	if err != nil {
		panic("error pinging server " + err.Error())
	}
	fmt.Println("succesfully connected to mysql")
}

func login(w http.ResponseWriter, r *http.Request) {
	
	if err := r.ParseForm(); err != nil {
		fmt.Fprintf(w, "ParseForm() err: %v", err)
		return
	}
	
	body, errRead := ioutil.ReadAll(r.Body)
	if errRead != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("400 - error with the body! " + err.Error()))
	}
	
	login := Login{}
	err := json.Unmarshal(body, &login)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("400 - error with the json! " + err.Error()))
	}
	
	// choose the right login option
	if len(login.GoogleId) == 0 { 
		// manual request 
		if len(login.Name) == 0 {
			// Log in
			normalLogin(w, &login, db)
		}else{
			// Sign in
			normalSignin(w, &login, db)
		}
	}else{
		// Google request
		googleLogin(w, &login, db)
	}
	if len(login.Id) == 0 {
		// user not found
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("400 - user not found! "))
		return
	}
	fmt.Fprintf(w, "{\"data\":{")
	fmt.Fprintf(w, "\"id\":\"" + login.Id + "\",")
	fmt.Fprintf(w, "\"email\":\"" + login.Email + "\",")
	fmt.Fprintf(w, "\"name\":\"" + login.Name + "\",")
	fmt.Fprintf(w, "\"googleid\":\"" + login.GoogleId + "\"")
	
	fmt.Fprintf(w, "}}")
}

func create(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	table := params["table_name"]
	fmt.Println("create table: ", table)
	if err := r.ParseForm(); err != nil {
		fmt.Fprintf(w, "ParseForm() err: %v", err)
		return
	}

	switch {
	case table == "registered_symptom":
		createRegisteredSymptom(w, r, db)	
	case table == "registered_feces":
		createRegisteredFeces(w, r, db)	
	case table == "registered_meal":
		createRegisteredMeal(w, r, db)	
	case table == "registered_supplement":
		createRegisteredSupplement(w, r, db)
	case table == "allergen_in_meal":
		createRegisteredSupplement(w, r, db)
	case table == "component_in_supplement":
		createComponentInSupplement(w, r, db)
	}
}

func read(w http.ResponseWriter, r *http.Request) {

	params := mux.Vars(r)
	table := params["table_name"]
	item_id := params["item_id"]
	user_id, _ := strconv.Atoi(params["user_id"])
	hash := params["hash"]
	
	if(!checkUser(user_id, hash)){
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("400 - wrong hash! "))
		return
	}
	
	fmt.Println("read table: ", table)
	extra := ""
	if tablesWithUser[table] {
		extra = " where user = " + params["user_id"]
	}

	if item_id != "" {
		if extra != "" {
			extra = " with "
		}else{
			extra = extra + " and "
		}
		extra = extra + "id = " + item_id
	}

	var query = `SELECT * FROM ` + table + extra
	fmt.Println("query: ", query)

	rows, err := db.Query(query)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("400 - error with the query! " + err.Error()))
		return
		//panic("error with the query '" + query + "': " + err.Error())
	}
	fmt.Println("ok: ", query)

	defer rows.Close()
	var rowBuf, _ = rows.Columns()
	var cols = make([]string, len(rowBuf))
	copy(cols, rowBuf)
	fmt.Println(rowBuf)
	var vals = make([]interface{}, len(rowBuf))
	for i, _ := range rowBuf {
		vals[i] = &rowBuf[i]
	}
	fmt.Fprintf(w, "{\"data\":[")
	var index = 0
	for rows.Next() {
		err := rows.Scan(vals...)
		if err != nil {
			log.Fatal(err)
		}
		var m = map[string]interface{}{}
		for i, col := range cols {
			m[col] = vals[i]
		}
		obj, _ := json.Marshal(m)
		if index != 0 {
			fmt.Fprintf(w, ",")
		}
		index = index + 1
		fmt.Fprintf(w, string(obj))
	}
	fmt.Fprintf(w, "]}")
	err = rows.Err()
	if err != nil {
		log.Fatal(err)
	}
}

func Middleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		token := r.Header.Get("X-Session-Token")

		if token == "abcd" {
			// We found the token in our map
			log.Printf("Authenticated token %s\n", token)
			next.ServeHTTP(w, r)
		} else {
			log.Printf("forbidden token %s\n", token)
			http.Error(w, "Forbidden", http.StatusForbidden)
		}
	})
}

func handleRequests() {
	router := mux.NewRouter().StrictSlash(true)
	router.Use(Middleware)
	router.HandleFunc("/", homePage)
	router.HandleFunc("/login", login).Methods("POST")
	router.HandleFunc("/user/{user_id:[0-9]+}/{hash:[a-zA-Z0-9_]+}/table/{table_name:[a-zA-Z0-9_]+}", create).Methods("POST")
	router.HandleFunc("/user/{user_id:[0-9]+}/{hash:[a-zA-Z0-9_]+}/table/{table_name:[a-zA-Z0-9_]+}/{item_id:[0-9]+}", read)
	router.HandleFunc("/user/{user_id:[0-9]+}/{hash:[a-zA-Z0-9_]+}/table/{table_name:[a-zA-Z0-9_]+}", read)
	log.Fatal(http.ListenAndServe(":10000", router))

}

func main() {
	configuration = GetConfiguration()
	connect()
	defer db.Close()
	handleRequests()
}
