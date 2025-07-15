package handlers

import (
	"fmt"
	"go-auth-system/internal/db"
	"net/http"
)

func VerifyEmailHandler(w http.ResponseWriter, r *http.Request) {
	token := r.URL.Query().Get("token")
	if token == "" {
		http.Error(w, "Verification token is required", http.StatusBadRequest)
		return
	}
	err := db.ActivateUserByToken(token)
	if err != nil {
		http.Error(w, "Invalid or expired token", http.StatusBadRequest)
		return
	}
	fmt.Fprintf(w, "Email verified successfully! You can now log in.")
}