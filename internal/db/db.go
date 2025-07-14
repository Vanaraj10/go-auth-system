package db

import (
	"database/sql"
	"fmt"
	_ "github.com/lib/pq" // PostgreSQL driver
)

var DB *sql.DB

func InitDB(connStr string) error {
	var err error
	DB, err = sql.Open("postgres", connStr)
	if err != nil {
		return err
	}
	err = DB.Ping()
	if err != nil {
		return err
	}
	fmt.Println("Database connection established")
	return nil
}