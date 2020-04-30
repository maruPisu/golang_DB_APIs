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
        //
        fmt.Fprintf(w, string(obj))
    }
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
