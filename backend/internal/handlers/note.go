package handlers

import (
	"encoding/json"
	"go-auth-system/internal/db"
	"go-auth-system/internal/models"
	"net/http"
	"strconv"
)

func CreateNoteHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	userID, ok := r.Context().Value("user_id").(int)
	if !ok || userID <= 0 {
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}
	var note models.Note
	if err := json.NewDecoder(r.Body).Decode(&note); err != nil {
		http.Error(w, "Invalid request body: "+err.Error(), http.StatusBadRequest)
		return
	}
	note.UserID = userID

	if err := db.CreateNote(&note); err != nil {
		http.Error(w, "Failed to create note: "+err.Error(), http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(map[string]string{
		"message": "Note created successfully",
	})
}

func GetNotesByUser(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	userID, ok := r.Context().Value("user_id").(int)
	if !ok || userID <= 0 {
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}
	notes, err := db.GetNotesByUser(userID)
	if err != nil {
		http.Error(w, "Failed to retrieve notes: "+err.Error(), http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(notes)
}

func GetNoteByIDHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	userID, ok := r.Context().Value("user_id").(int)
	if !ok || userID <= 0 {
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}
	noteIDStr := r.URL.Query().Get("id")
	noteID, err := strconv.Atoi(noteIDStr)
	if err != nil || noteID <= 0 {
		http.Error(w, "Invalid note id", http.StatusBadRequest)
		return
	}
	note, err := db.GetNoteByID(noteID, userID)
	if err != nil {
		http.Error(w, "Note not found", http.StatusNotFound)
		return
	}
	json.NewEncoder(w).Encode(note)
}

func UpdateNoteHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPut {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	userID, ok := r.Context().Value("user_id").(int)
	if !ok || userID <= 0 {
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}
	noteIDStr := r.URL.Query().Get("id")
	noteID, err := strconv.Atoi(noteIDStr)
	if err != nil || noteID <= 0 {
		http.Error(w, "Invalid note id", http.StatusBadRequest)
		return
	}
	var req struct {
		Title   string `json:"title"`
		Content string `json:"content"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}
	err = db.UpdateNote(noteID, userID, req.Title, req.Content)
	if err != nil {
		http.Error(w, "Failed to update note", http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(map[string]string{"message": "Note updated successfully"})
}

func DeleteNoteHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodDelete {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	userID, ok := r.Context().Value("user_id").(int)
	if !ok || userID <= 0 {
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}
	noteIDStr := r.URL.Query().Get("id")
	noteID, err := strconv.Atoi(noteIDStr)
	if err != nil || noteID <= 0 {
		http.Error(w, "Invalid note id", http.StatusBadRequest)
		return
	}
	err = db.DeleteNote(noteID, userID)
	if err != nil {
		http.Error(w, "Failed to delete note", http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(map[string]string{"message": "Note deleted successfully"})
}
