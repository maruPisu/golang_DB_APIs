package main

import (
	"database/sql"
	_ "github.com/go-sql-driver/mysql"
	"net/http"
	"log"
	"fmt"
)

func readLoginTable(w http.ResponseWriter, login *Login, database *sql.DB){
	query := "SELECT id, email, name, password, googleid FROM user WHERE email = '" +  login.Email + "'"

	rows, err := db.Query(query)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("400 - error with the query! " + err.Error()))
		return
	}
	
	fmt.Println("ok: ", query)

	defer rows.Close()
	for rows.Next() {
		fmt.Println("next")
		var nGoogleId sql.NullString
		err := rows.Scan(
			&login.Id, 
			&login.Email, 
			&login.Name, 
			&login.Password, 
			&nGoogleId)
		if err != nil {
			log.Fatal(err)
		}
		
		if nGoogleId.Valid {
		   login.GoogleId = nGoogleId.String
		}
	}
}

func checkPassword(oldPassword string, newPassword string) bool{
	return oldPassword == newPassword
}

func normalLogin(w http.ResponseWriter, login *Login, database *sql.DB) {
	password := login.Password
	readLoginTable(w, login, database)
	if(!checkPassword(password, login.Password)){
		login.Id = ""
	}
}

func normalSignin(w http.ResponseWriter, login *Login, database *sql.DB) {

	//query, _ := database.Prepare("INSERT INTO login_infos (email, name, password) VALUES ('?', '?', '?')")
	query := "INSERT INTO user (email, name, password) VALUES ('" + login.Email + "', '" + login.Name + "', '" + login.Password + "')"
	
	_, err := db.Query(query)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("400 - error with the query! " + err.Error()))
		return
	}

	
	readLoginTable(w, login, database)
}

func googleLogin(w http.ResponseWriter, login *Login, database *sql.DB) {
	
	tmpLogin := Login{}
	tmpLogin.Email = login.Email
	tmpLogin.Name = login.Name
	tmpLogin.GoogleId = login.GoogleId
	
	readLoginTable(w, login, database)
	
	if len(login.Id) == 0 {
		//create user with tmpLogin	infos
		query := "INSERT INTO user (email, name, googleid) VALUES ('" + login.Email + "', '" + login.Name + "', '" + login.GoogleId + "')"
		
		_, err := db.Query(query)
		if err != nil {
			w.WriteHeader(http.StatusBadRequest)
			w.Write([]byte("400 - error with the query! " + err.Error()))
			return
		}		
		
		readLoginTable(w, login, database)
	}
} 