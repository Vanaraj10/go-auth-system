package main

import (
	"fmt"
	"go-auth-system/internal/handlers"
	"net/http"
)

func main() {
	http.HandleFunc("/",handlers.HomeHandler)
	http.HandleFunc("/register", handlers.HandleRegister)
	http.ListenAndServe(":8080", nil)
	fmt.Println("Server is starting on port 8080")
}