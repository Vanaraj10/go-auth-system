package main

import (
	"fmt"
	"go-auth-system/internal/db"
	"go-auth-system/internal/handlers"
	"go-auth-system/internal/middleware"
	"net/http"
	"os"

	"github.com/joho/godotenv"
)

func main() {
	godotenv.Load()
	connStr := os.Getenv("DB_URL")
	if connStr == "" {
		fmt.Println("DB_URL environment variable is not set")
		return
	}
	err := db.InitDB(connStr)
	if err != nil {
		fmt.Println("Error initializing database:", err)
		return
	}
	http.HandleFunc("/", handlers.HomeHandler)
	http.HandleFunc("/register", handlers.HandleRegister)
	http.HandleFunc("/verify", handlers.VerifyEmailHandler)
	http.HandleFunc("/login", handlers.LoginHandler)

	http.HandleFunc("/protected", middleware.JWTAuth(handlers.ProtectedHandler))

	http.HandleFunc("/notes", middleware.JWTAuth(handlers.CreateNoteHandler))       // POST
	http.HandleFunc("/get-notes", middleware.JWTAuth(handlers.GetNotesByUser))     // GET
	http.HandleFunc("/note", middleware.JWTAuth(handlers.GetNoteByIDHandler))       // GET (by id)
	http.HandleFunc("/note/update", middleware.JWTAuth(handlers.UpdateNoteHandler)) // PUT
	http.HandleFunc("/note/delete", middleware.JWTAuth(handlers.DeleteNoteHandler)) // DELETE

	http.ListenAndServe(":8080", nil)
	fmt.Println("Server is starting on port 8080")
}
