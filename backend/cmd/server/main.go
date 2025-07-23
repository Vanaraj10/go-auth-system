package main

import (
	"fmt"
	"go-auth-system/internal/db"
	"go-auth-system/internal/handlers"
	"go-auth-system/internal/middleware"
	"net/http"
	"os"

	"github.com/joho/godotenv"
	"github.com/rs/cors"
)

func main() {
	godotenv.Load()

	// Set up HTTP handlers
	mux := http.NewServeMux()
	mux.HandleFunc("/", handlers.HomeHandler)
	mux.HandleFunc("/register", handlers.HandleRegister)
	mux.HandleFunc("/verify", handlers.VerifyEmailHandler)
	mux.HandleFunc("/login", handlers.LoginHandler)
	mux.HandleFunc("/protected", middleware.JWTAuth(handlers.ProtectedHandler))
	mux.HandleFunc("/notes", middleware.JWTAuth(handlers.CreateNoteHandler))       // POST
	mux.HandleFunc("/get-notes", middleware.JWTAuth(handlers.GetNotesByUser))      // GET
	mux.HandleFunc("/note", middleware.JWTAuth(handlers.GetNoteByIDHandler))       // GET (by id)
	mux.HandleFunc("/note/update", middleware.JWTAuth(handlers.UpdateNoteHandler)) // PUT
	mux.HandleFunc("/note/delete", middleware.JWTAuth(handlers.DeleteNoteHandler)) // DELETE

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
	
	c := cors.New(cors.Options{
		AllowedOrigins:   []string{"*"},
		AllowedMethods:   []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"Content-Type", "Authorization"},
		AllowCredentials: true,
	})

	port := os.Getenv("SERVER_PORT")
	if port == "" {
		port = "8080"
	}
	fmt.Println("Server is starting on port", port)
	http.ListenAndServe(":"+port, c.Handler(mux))
}
