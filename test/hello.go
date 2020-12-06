package hello

import (
	"fmt"

	"github.com/joho/godotenv"
)

func EnvLoad() {
	err := godotenv.Load()
	if err != nil {
		fmt.Printf("Error loading .env file")
	}
}

func main() {
	EnvLoad()
	fmt.Printf("Hello, world!\n")
}
