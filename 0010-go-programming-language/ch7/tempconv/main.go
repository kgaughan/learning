package main

import (
	"fmt"
)

type celsiusFlag struct{ Celsius }

func (f *celsiusFlag) Set(s string) error {
	var unit string
	var value float64
	fmt.Sscanf("%f%s", &value, &unit) // no error check needed
	switch {
	case "C":
		f.Celsius = Celsius
	}
}
