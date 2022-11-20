package main

import (
	"io/ioutil"
	"database/sql"
	"encoding/json"
	_ "github.com/go-sql-driver/mysql"
	"net/http"
)

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

	query.Exec(registeredSymptom.User, registeredSymptom.Symptom, registeredSymptom.Datetime.UTC())
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

	query.Exec(registeredFeces.User, registeredFeces.Feces, registeredFeces.Datetime.UTC())
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

	query.Exec(registeredMeal.User, registeredMeal.Datetime.UTC())
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

	query.Exec(registeredSupplement.User, registeredSupplement.Datetime.UTC())
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

	query.Exec(allergenInMeal.Meal, allergenInMeal.Allergen)
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

	query.Exec(componentInSupplement.Supplement, componentInSupplement.Component)
}