package handlers

import (
	"encoding/json"
	"fmt"
	"go-auth-system/internal/db"
	"go-auth-system/internal/models"
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
		token, err := utils.GenerateToken(32)
		if err != nil {
			http.Error(w, "Error generating verification token", http.StatusInternalServerError)
			return
		}
		user := &models.User{
			Email: req.Email,
			Password: hashedPassword,
			IsActive: false,
			VerificationToken: token,
		}
		err = db.CreateUser(user)
		if err != nil {
			http.Error(w, "Error creating user", http.StatusInternalServerError)
			return
		}
		err = utils.SendVerificationEmail(req.Email, token)
		if err != nil {
			http.Error(w, "Error sending verification email", http.StatusInternalServerError)
			return
		}
		fmt.Fprintln(w, "Registration successful! Please check your email to verify your account.")
	}else{
		fmt.Fprintln(w, "Please send a POST request to register.")
	}
}