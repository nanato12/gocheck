package hello

import fmt "fmt"

func main() {
	fmt.Printf("Hello, world!\n")
	a := fmt.Sprintf("%s", 1)
	fmt.Errorf(a)
}
