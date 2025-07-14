package db

import "go-auth-system/internal/models"

func CreateUser(user *models.User) error {
	query := `INSERT INTO users (email, password, is_active,verification_token) VALUES ($1, $2, $3, $4)`
	_, err := DB.Exec(query, user.Email, user.Password, user.IsActive,user.VerificationToken)
	return err
}