package db

import (
	"database/sql"
	"go-auth-system/internal/models"
)

func CreateUser(user *models.User) error {
	query := `INSERT INTO users (email, password, is_active,verification_token) VALUES ($1, $2, $3, $4)`
	_, err := DB.Exec(query, user.Email, user.Password, user.IsActive,user.VerificationToken)
	return err
}

func ActivateUserByToken(token string) error {
	query := `UPDATE users SET is_active = true WHERE verification_token = $1`
	result, err := DB.Exec(query, token)
	if err != nil {
		return err
	}
	rows, err := result.RowsAffected()
	if err != nil {
		return err
	}
	if rows == 0 {
		return sql.ErrNoRows
	}
	return nil
}