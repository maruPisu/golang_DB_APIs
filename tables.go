package main

import (
	"time"
)

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