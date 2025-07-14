package models

type User struct {
	ID    int   `json:"id"`
	Email string `json:"email"`
	Password string `json:"password"`
	IsActive bool   `json:"is_active"`
	VerificationToken string `json:"verification_token"`
}