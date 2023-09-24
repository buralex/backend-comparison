package models

import (
	"time"

	"github.com/google/uuid"
)

type User struct {
	ID        uuid.UUID `gorm:"type:uuid;default:uuid_generate_v4();primaryKey"`
	Email     string `gorm:"unique"`
	FullName  string
	CreatedAt time.Time
	UpdatedAt time.Time
	Posts     []Post `gorm:"foreignKey:UserID"`
}

type Post struct {
	ID        uuid.UUID `gorm:"type:uuid;default:uuid_generate_v4();primaryKey"`
	Title     string
	CreatedAt time.Time
	UpdatedAt time.Time
	UserID    uuid.UUID
}

