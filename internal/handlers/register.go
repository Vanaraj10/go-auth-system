package handlers

import (
	"encoding/json"
	"fmt"
	"go-auth-system/internal/utils"
	"net/http"
)

func HandleRegister(w http.ResponseWriter, r *http.Request) {
	if r.Method == http.MethodPost {
		var req struct {
			Email    string `json:"email"`
			Password string `json:"password"`
		}
		err := json.NewDecoder(r.Body).Decode(&req)
		if err != nil {
			http.Error(w, "Invalid request body", http.StatusBadRequest)
			return
		}
		hashedPassword, err := utils.HashPassword(req.Password)
		if err != nil {
			http.Error(w, "Error hashing password", http.StatusInternalServerError)
			return
		}
		fmt.Printf("Registration attempt for: %s, Hashed Password: %s", req.Email, hashedPassword)
		fmt.Fprintln(w, "Registration successful (dummy response)")
	}else{
		fmt.Fprintln(w, "Please send a POST request to register.")
	}
}