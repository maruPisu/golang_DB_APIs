package main

import (
	"io/ioutil"
	"database/sql"
	"encoding/json"
	_ "github.com/go-sql-driver/mysql"
	"net/http"
	"fmt"
	"strconv"
)

func returnLastId(w http.ResponseWriter, r *http.Request, result sql.Result){	
    lastInsertId, err := result.LastInsertId()
    if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("400 - error with the query! " + err.Error()))
		return
    }	
	
	fmt.Fprintf(w, "{\"data\":{")
	fmt.Fprintf(w, "\"last_id\":\"" + strconv.FormatInt(lastInsertId, 10) + "\"")	
	fmt.Fprintf(w, "}}")
}	

func createRegisteredSymptom(w http.ResponseWriter, r *http.Request, database *sql.DB) {
	body, errRead := ioutil.ReadAll(r.Body)
	if errRead != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("400 - error with the body! " + err.Error()))
	}
	
	registeredSymptom := RegisteredSymptom{}
	err := json.Unmarshal(body, &registeredSymptom)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("400 - error with the json! " + err.Error()))
	}
	query, _ := database.Prepare("INSERT INTO registered_symptom (user, symptom, datetime) VALUES (?, ?, ?)")

	result, _ := query.Exec(registeredSymptom.User, registeredSymptom.Symptom, registeredSymptom.Datetime.UTC())
	
	returnLastId(w, r, result)
}

func createRegisteredFeces(w http.ResponseWriter, r *http.Request, database *sql.DB) {
	body, errRead := ioutil.ReadAll(r.Body)
	if errRead != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("400 - error with the body! " + err.Error()))
	}
	registeredFeces := RegisteredFeces{}
	err := json.Unmarshal(body, &registeredFeces)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("400 - error with the json! " + err.Error()))
	}
	query, _ := database.Prepare("INSERT INTO registered_feces (user, feces, datetime) VALUES (?, ?, ?)")

	result, _ := query.Exec(registeredFeces.User, registeredFeces.Feces, registeredFeces.Datetime.UTC())
	
	returnLastId(w, r, result)
}

func createRegisteredMeal(w http.ResponseWriter, r *http.Request, database *sql.DB) {
	body, errRead := ioutil.ReadAll(r.Body)
	if errRead != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("400 - error with the body! " + err.Error()))
	}
	registeredMeal := RegisteredMeal{}
	err := json.Unmarshal(body, &registeredMeal)	
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("400 - error with the json! " + err.Error()))
	}
	query, _ := database.Prepare("INSERT INTO registered_meal (user, datetime) VALUES (?, ?)")

	result, _ := query.Exec(registeredMeal.User, registeredMeal.Datetime.UTC())
	
	returnLastId(w, r, result)
}

func createRegisteredSupplement(w http.ResponseWriter, r *http.Request, database *sql.DB) {
	body, errRead := ioutil.ReadAll(r.Body)
	if errRead != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("400 - error with the body! " + err.Error()))
	}
	registeredSupplement := RegisteredSupplement{}
	err := json.Unmarshal(body, &registeredSupplement)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("400 - error with the json! " + err.Error()))
	}
	query, _ := database.Prepare("INSERT INTO registered_supplement (user, datetime) VALUES (?, ?)")

	result, _ := query.Exec(registeredSupplement.User, registeredSupplement.Datetime.UTC())
	
	returnLastId(w, r, result)
}

func createAllergenInMeal(w http.ResponseWriter, r *http.Request, database *sql.DB) {
	body, errRead := ioutil.ReadAll(r.Body)
	if errRead != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("400 - error with the body! " + err.Error()))
	}
	allergenInMeal := AllergenInMeal{}
	err := json.Unmarshal(body, &allergenInMeal)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("400 - error with the json! " + err.Error()))
	}
	query, _ := database.Prepare("INSERT INTO allergen_in_meal (meal, allergen) VALUES (?, ?)")

	result, _ := query.Exec(allergenInMeal.Meal, allergenInMeal.Allergen)
	
	returnLastId(w, r, result)
}

func createComponentInSupplement(w http.ResponseWriter, r *http.Request, database *sql.DB) {
	body, errRead := ioutil.ReadAll(r.Body)
	if errRead != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("400 - error with the body! " + err.Error()))
	}
	componentInSupplement := ComponentInSupplement{}
	err := json.Unmarshal(body, &componentInSupplement)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("400 - error with the json! " + err.Error()))
	}
	query, _ := database.Prepare("INSERT INTO component_in_supplement (supplement, component) VALUES (?, ?)")

	result, _ := query.Exec(componentInSupplement.Supplement, componentInSupplement.Component)
	
	returnLastId(w, r, result)
}