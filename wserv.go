package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	_ "github.com/go-sql-driver/mysql"
	"github.com/gorilla/mux"
	"github.com/tkanos/gonfig"
	"io/ioutil"
	"log"
	"net/http"
	"time"
)

type Person struct {
	FirstName  string `json:"firstName"`
	SecondName string `json:"secondName"`
}

var db *sql.DB
var err error
var configuration Config

type Config struct {
	DB_USERNAME string
	DB_PASSWORD string
	DB_PORT     string
	DB_HOST     string
	DB_NAME     string
}

type RegisteredSymptom struct {
	User     string    `json:"user"`
	Symptom  string    `json:"symptom"`
	Datetime time.Time `json:"datetime"`
}

func GetConfiguration() Config {
	config := Config{}
	fileName := "./conf.json"
	gonfig.GetConf(fileName, &config)
	return config
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

func generateRegisteredSymptomQuery(w http.ResponseWriter, r *http.Request) {
	body, errRead := ioutil.ReadAll(r.Body)
	if errRead != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("400 - error with the json! " + err.Error()))
	}
	fmt.Println("body: " + string(body))
	registeredSymptom := RegisteredSymptom{}
	err := json.Unmarshal(body, &registeredSymptom)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("400 - error with the json! " + err.Error()))
	}
	query, _ := db.Prepare("INSERT INTO registered_symptom (user, symptom, datetime) VALUES (?, ?, ?)")

	query.Exec(registeredSymptom.User, registeredSymptom.Symptom, registeredSymptom.Datetime.UTC())
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
		generateRegisteredSymptomQuery(w, r)
	}
}

func read(w http.ResponseWriter, r *http.Request) {

	params := mux.Vars(r)
	table := params["table_name"]
	item_id := params["item_id"]
	fmt.Println("read table: ", table)
	extra := ""

	if item_id != "" {
		extra = " where id = " + item_id
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
	router.HandleFunc("/table/{table_name:[a-zA-Z0-9_]+}", create).Methods("POST")
	router.HandleFunc("/table/{table_name:[a-zA-Z0-9_]+}/{item_id:[0-9]+}", read)
	router.HandleFunc("/table/{table_name:[a-zA-Z0-9_]+}", read)
	log.Fatal(http.ListenAndServe(":10000", router))

}

func main() {
	configuration = GetConfiguration()
	connect()
	defer db.Close()
	handleRequests()
}
