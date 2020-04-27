package main

import (
 	"os"
	"fmt"
	"log"
	"net/http"
	"encoding/json"
	"github.com/gorilla/mux"
	"database/sql"
	_ "github.com/go-sql-driver/mysql"
)

type Person struct{
	FirstName string `json:"firstName"`
	SecondName string `json:"secondName"`
}

var db *sql.DB
var err error
var username string
var password string

func homePage(w http.ResponseWriter, r *http.Request){
	fmt.Fprintf(w, "Welcome to the HomePage!")
	fmt.Println("Endpoint Hit: homePage")
}

func returnAllArticles(w http.ResponseWriter, r *http.Request){
	fmt.Println("Endpoint Hit: returnAllArticles")
  	params := mux.Vars(r)
    	table := params["table"]
	fmt.Println("table: %s",table)
	        db, err := sql.Open("mysql", username + ":" + password + "@tcp(127.0.0.1:3306)/test")
        defer db.Close()
        if err != nil {
                panic(err.Error()) // Just for example purpose. You should use proper error handling instead of panic
        }

        err = db.Ping()
        if err != nil {
                panic(err.Error()) // Just for example purpose. You should use proper error handling instead of panic
        }

        fmt.Println("succesfully connected to mysql", err)


	rows, err := db.Query(`SELECT firstName, secondName FROM person`)
        if err != nil {
                panic(err)
        }
        defer rows.Close()
	persons := []Person{}
	for rows.Next() {
                person := Person{}
                err = rows.Scan(&person.FirstName, &person.SecondName)
                if err != nil {
                        panic(err)
                }
                fmt.Println(person)
		persons = append(persons, person)
        }
        err = rows.Err()
        if err != nil {
                panic(err)
        }

	json.NewEncoder(w).Encode(persons)
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
	router.Use(Middleware);
	router.HandleFunc("/", homePage)
	router.HandleFunc("/table/{table:[a-z]+}", returnAllArticles)
	log.Fatal(http.ListenAndServe(":10000", router))

}

func main() {

	username = os.Args[1]
	password = os.Args[1]

	handleRequests()
}
