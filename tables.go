package main

import (
	"time"
)

type Login struct {
	Id  		string    `json:"id"`
	Email  		string    `json:"email"`
	Password   	string    `json:"password"`
	Name   		string    `json:"name"`
	GoogleId	string    `json:"googleid"`
}

type RegisteredSymptom struct {
	User     string    `json:"user"`
	Symptom  string    `json:"symptom"`
	Datetime time.Time `json:"datetime"`
}

type RegisteredFeces struct {
	User     string    `json:"user"`
	Feces    string    `json:"feces"`
	Datetime time.Time `json:"datetime"`
}

type RegisteredMeal struct {
	User     string    `json:"user"`
	Datetime time.Time `json:"datetime"`
}

type RegisteredSupplement struct {
	User     string    `json:"user"`
	Datetime time.Time `json:"datetime"`
}

type AllergenInMeal struct {
	Meal     string    `json:"meal"`
	Allergen string    `json:"Allergen"`
}

type ComponentInSupplement struct {
	Supplement  string    `json:"supplement"`
	Component   string    `json:"component"`
}