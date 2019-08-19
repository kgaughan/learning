// Package bank provides a concurrency-safe bank with one account.
package bank

var (
	sema    = make(chan struct{}, 1) // a binary semaphore guarding balance
	balance int
)

func Deposit(amount int) {
	sema <- struct{}{} // acquire token
	balance += amount
	<-sema // release token
}

func Withdraw(amount int) bool {
	sema <- struct{}{} // acquire token
	defer func() {
		<-sema // release token
	}()

	if balance >= amount {
		balance -= amount
		return true
	}
	return false
}

func Balance() int {
	sema <- struct{}{} // acquire token
	b := balance
	<-sema // release token
	return b
}
