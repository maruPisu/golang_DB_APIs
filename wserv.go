package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	_ "github.com/go-sql-driver/mysql"
	"github.com/gorilla/mux"
	"github.com/tkanos/gonfig"
	"log"
	"net/http"
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
	db, err := sql.Open("mysql", configuration.DB_USERNAME+":"+configuration.DB_PASSWORD+"@tcp(127.0.0.1:3306)/test")
	defer db.Close()
	if err != nil {
		panic("error connectiong to mysql " + err.Error()) // Just for example purpose. You should use proper error handling instead of panic
	}

	err = db.Ping()
	if err != nil {
		panic("error pinging server " + err.Error()) // Just for example purpose. You should use proper error handling instead of panic
	}
	fmt.Println("succesfully connected to mysql", err)
}

func generateAllergenQuery(r *http.Request) string {
	name := r.FormValue("name")
	description := r.FormValue("description")

	fmt.Println("Endpoint Hit: generate allergen " + name + ", " + description)

	return "generateAllergenQuery"
}

func create(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	table := params["table_name"]
	fmt.Println("table: %s", table)
	var query string
	if err := r.ParseForm(); err != nil {
		fmt.Fprintf(w, "ParseForm() err: %v", err)
		return
	}

	switch {
	case table == "allergen":
		query = generateAllergenQuery(r)
	}

	fmt.Println("query " + query)
}

func read(w http.ResponseWriter, r *http.Request) {

	params := mux.Vars(r)
	table := params["table_name"]
	fmt.Println("table: %s", table)

	rows, err := db.Query(`SELECT * FROM ` + table)

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
	router.HandleFunc("/table/{table_name:[a-z]+}", create).Methods("POST")
	router.HandleFunc("/table/{table_name:[a-z]+}", read)
	log.Fatal(http.ListenAndServe(":10000", router))

}

func main() {
	configuration = GetConfiguration()
	connect()
	handleRequests()
}
