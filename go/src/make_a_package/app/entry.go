package main

import (
	"fmt"
	"make_a_package/greet"
)

/*
This is wild. Package-scoped variables are declared over repeated
initialization cycles. So, I can declare `a` which is dependent on
`b` first, which is dependent on a function call, which itself is
dependent on a variable `c` that is only declared on a later line.
*/

var (
	a int = b
	b int = f()
	c int = 1
)

func main() {
	fmt.Println(a, b, c)

	fmt.Println("version is " + version)
	fmt.Println(greet.Morning)
}