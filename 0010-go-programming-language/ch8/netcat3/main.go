package main

import (
	"fmt"
	"io"
	"log"
	"net"
	"os"
)

func main() {
	conn, err := net.Dial("tcp", "localhost:8000")
	if err != nil {
		log.Fatal(err)
	}
	done := make(chan struct{})

	// processes anything coming from the server as it arrives
	go func() {
		io.Copy(os.Stdout, conn) // NOTE: ignoring errors
		log.Println("done")
		done <- struct{}{} // signal the main goroutine
	}()

	// process anything entered locally and send it to the server
	if _, err := io.Copy(conn, os.Stdin); err != nil {
		log.Fatal(err)
	}

	conn.Close()
	<-done // wait for background goroutine to finish
}
