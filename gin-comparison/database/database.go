package database

import (
	"fmt"
	"log"
	"os"
	"time"

	"github.com/buralex/backend-comparison/go-comparison/models"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

type Dbinstance struct {
	Db *gorm.DB
}

var DB Dbinstance


func ConnectDb() {
	dbHost := os.Getenv("POSTGRES_HOST")
	dbPort := os.Getenv("POSTGRES_PORT")
	dbUser := os.Getenv("POSTGRES_USER")
	dbPassword := os.Getenv("POSTGRES_PASSWORD")
	dbName := os.Getenv("POSTGRES_DB")

	dsn := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=prefer",
	dbHost, dbPort, dbUser, dbPassword, dbName)

	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Silent),
	})
	sqlDB, err :=  db.DB()

	maxRetries := 5
	retryInterval := 2 * time.Second
	for retries := 0; retries < maxRetries; retries++ {
		err := sqlDB.Ping()
		if err == nil {
			break
		}
		fmt.Printf("Waiting for the database to be ready... (%d/%d)\n", retries+1, maxRetries)
		time.Sleep(retryInterval)
	}

	sqlDB.SetMaxOpenConns(10)

	if err != nil {
		log.Fatal("Failed to connect to database. \n", err)
	}

	result := db.Exec("CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";")
    if result.Error != nil {
        panic("Failed to enable extension: " + result.Error.Error())
    }

	log.Println("connected")
	db.Logger = logger.Default.LogMode(logger.Info)
	log.Println("running migrations")
	db.AutoMigrate(&models.User{})
	db.AutoMigrate(&models.Post{})

	DB = Dbinstance{
		Db: db,
	}
}
