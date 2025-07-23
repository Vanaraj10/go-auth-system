package handlers

import (
	"database/sql"
	"encoding/json"
	"go-auth-system/internal/db"
	"go-auth-system/internal/utils"
	"net/http"
)

func LoginHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	var req struct {
		Email    string `json:"email"`
		Password string `json:"password"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}
	var id int
	var hashedPassword string
	var isActive bool
	err := db.DB.QueryRow("SELECT id, password, is_active FROM users WHERE email = $1", req.Email).Scan(&id, &hashedPassword, &isActive)
	if err == sql.ErrNoRows || !isActive {
		http.Error(w, "Invalid email or password", http.StatusUnauthorized)
		return
	}
	if !utils.CheckPasswordHash(req.Password, hashedPassword) {
		http.Error(w, "Invalid email or password", http.StatusUnauthorized)
		return
	}
	token, err := utils.GenerateJWT(req.Email, id)
	if err != nil {
		http.Error(w, "Error generating token", http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(map[string]string{
		"token":token,
	})
}