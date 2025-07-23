package db

import (
	"database/sql"
	"go-auth-system/internal/models"
)

func CreateNote(note *models.Note) error {
	query := `INSERT INTO notes (user_id, title, content) VALUES ($1, $2, $3)`
	_, err := DB.Exec(query, note.UserID, note.Title, note.Content)
	return err
}

func GetNotesByUser(userID int) ([]models.Note, error) {
	query := `SELECT id, user_id, title, content, created_at, updated_at FROM notes WHERE user_id = $1`
	rows, err := DB.Query(query, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var notes []models.Note
	for rows.Next() {
		var note models.Note
		if err := rows.Scan(&note.ID, &note.UserID, &note.Title, &note.Content, &note.CreatedAt, &note.UpdatedAt); err != nil {
			return nil, err
		}
		notes = append(notes, note)
	}
	return notes, nil
}

func GetNoteByID(noteID int, userID int) (*models.Note, error) {
	query := `SELECT id, user_id, title, content, created_at, updated_at FROM notes WHERE id = $1 AND user_id = $2`
	row := DB.QueryRow(query, noteID, userID)
	var note models.Note
	err := row.Scan(&note.ID, &note.UserID, &note.Title, &note.Content, &note.CreatedAt, &note.UpdatedAt)
	if err != nil {
		return nil, err
	}
	return &note, nil
}

func UpdateNote(noteID int, userID int, title, content string) error {
	query := `UPDATE notes SET title = $1, content = $2, updated_at = NOW() WHERE id = $3 AND user_id = $4`
	result, err := DB.Exec(query, title, content, noteID, userID)
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

func DeleteNote(noteID int, userID int) error {
	query := `DELETE FROM notes WHERE id = $1 AND user_id = $2`
	result, err := DB.Exec(query, noteID, userID)
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
