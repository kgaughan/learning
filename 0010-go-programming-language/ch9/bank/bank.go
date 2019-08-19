// Package bank provides a concurrency-safe bank with one account.
package bank

import "sync"

var (
	mu      sync.Mutex // guards balance
	balance int
)

func Deposit(amount int) {
	mu.Lock()
	defer mu.Unlock()

	balance += amount
}

func Withdraw(amount int) bool {
	mu.Lock()
	defer mu.Unlock()

	if balance >= amount {
		balance -= amount
		return true
	}
	return false
}

func Balance() int {
	mu.Lock()
	defer mu.Unlock()

	return balance
}
