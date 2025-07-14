package main

import (
	"fmt"
	"go-auth-system/internal/db"
	"go-auth-system/internal/handlers"
	"net/http"
	"os"

	"github.com/joho/godotenv"
)

func main() {
	godotenv.Load()
	connStr := os.Getenv("DB_URL")
	if connStr == ""{
		fmt.Println("DB_URL environment variable is not set")
		return
	}
	err := db.InitDB(connStr)
	if err != nil {
		fmt.Println("Error initializing database:", err)
		return
	}
	http.HandleFunc("/",handlers.HomeHandler)
	http.HandleFunc("/register", handlers.HandleRegister)
	http.ListenAndServe(":8080", nil)
	fmt.Println("Server is starting on port 8080")
}