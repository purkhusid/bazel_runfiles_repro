package main

import (
	"fmt"
	"os"
)

func main() {
	argv := os.Args[1:]

	fmt.Printf("Args: %s\n", argv)
}
