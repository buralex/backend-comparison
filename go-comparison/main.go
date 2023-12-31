package main

import (
	"fmt"
	"net/http"
	"os"
	"strconv"
	"time"

	"github.com/buralex/backend-comparison/go-comparison/database"
	"github.com/buralex/backend-comparison/go-comparison/models"
	"github.com/gin-gonic/gin"
)

func fibonacci(n int) int {
    if n <= 0 {
        return 0
    } else if n == 1 {
        return 1
    }
    return fibonacci(n-1) + fibonacci(n-2)
}

func calculateFibonacci(ctx *gin.Context) {
	n, err := strconv.Atoi(ctx.Param("n"))
	if err != nil || n < 0 {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	result := fibonacci(n)
	ctx.String(200, "Fibonacci(%d) = %d", n, result)
}

func main() {
    database.ConnectDb()
    router := gin.Default()

    router.GET("/ping", func(ctx *gin.Context) {
        ctx.String(200, "pong")
    })

	router.GET("/fib/:n", calculateFibonacci)

    router.GET("/users", func(ctx *gin.Context) {
		var users []models.User

		// Preload posts to include them in the query result
		result := database.DB.Db.Preload("Posts").Find(&users)

		if result.Error != nil {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch users"})
			return
		}

		ctx.JSON(http.StatusOK, users)
	})

    router.GET("/helpers/seed", func(ctx *gin.Context) {
		seedData()

		ctx.JSON(http.StatusOK, gin.H{"message": "Database seeded successfully"})
	})

    router.Run(":" + os.Getenv("MAIN_API_SERVICE_PORT"))
}

func seedData() {

	// Seed users and posts
	for i := 1; i <= 5; i++ {
		user := models.User{
			Email:     fmt.Sprintf("user%d@example.com", i),
			FullName:  fmt.Sprintf("User %d", i),
			CreatedAt: time.Now(),
			UpdatedAt: time.Now(),
		}

		database.DB.Db.Create(&user)

		for j := 1; j <= 2; j++ {
			post := models.Post{
				Title:     fmt.Sprintf("Post %d%d", i, j),
				CreatedAt: time.Now(),
				UpdatedAt: time.Now(),
				UserID:    user.ID,
			}

			database.DB.Db.Create(&post)
		}
	}
}