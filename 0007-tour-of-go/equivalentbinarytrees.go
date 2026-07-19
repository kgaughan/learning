package main

import (
	"fmt"

	"code.google.com/p/go-tour/tree"
)

func walkRecurse(t *tree.Tree, ch chan int) {
	if t.Left != nil {
		walkRecurse(t.Left, ch)
	}
	ch <- t.Value
	if t.Right != nil {
		walkRecurse(t.Right, ch)
	}
}

func Walk(t *tree.Tree, ch chan int) {
	walkRecurse(t, ch)
	close(ch)
}

func Same(t1, t2 *tree.Tree) bool {
	ch1 := make(chan int)
	ch2 := make(chan int)
	go Walk(t1, ch1)
	go Walk(t2, ch2)
	for {
		v1, ok1 := <-ch1
		v2, ok2 := <-ch2
		if !ok1 && !ok2 {
			return true
		}
		if v1 != v2 || ok1 != ok2 {
			return false
		}
	}
}

func main() {
	if Same(tree.New(1), tree.New(2)) {
		fmt.Println("Yay!")
	} else {
		fmt.Println("Nay!")
	}
}
