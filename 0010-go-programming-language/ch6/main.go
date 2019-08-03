package main

import "fmt"
import "image/color"

import "gopl.io/ch6/geometry"
import "gopl.io/ch6/ints"

func main() {
	p := geometry.Point{1, 2}
	q := geometry.Point{4, 6}
	fmt.Println(geometry.Distance(p, q))
	fmt.Println(p.Distance(q))

	perimeter := geometry.Path{
		{1, 1},
		{5, 1},
		{5, 4},
		{1, 1},
	}
	fmt.Println(perimeter.Distance())

	r := &geometry.Point{1, 2}
	r.ScaleBy(2)
	fmt.Println(*r)

	p1 := geometry.Point{1, 2}
	p1.ScaleBy(2)
	fmt.Println(p1)

	var cp geometry.ColoredPoint
	cp.X = 1
	fmt.Println(cp.Point.X)
	cp.Point.Y = 2
	fmt.Println(cp.Y)

	red := color.RGBA{255, 0, 0, 255}
	blue := color.RGBA{0, 0, 255, 255}
	var p2 = geometry.ColoredPoint{geometry.Point{1, 1}, red}
	var q2 = geometry.ColoredPoint{geometry.Point{5, 4}, blue}
	fmt.Println(p2.Distance(q2.Point))
	p2.ScaleBy(2)
	q2.ScaleBy(2)
	fmt.Println(p2.Distance(q2.Point))

	var x, y ints.IntSet

	x.AddAll(1, 144, 9)
	fmt.Println(x.String())

	y.AddAll(9, 42)
	fmt.Println(y.String())

	x.UnionWith(&y)
	fmt.Println(x.String())

	fmt.Println(x.Has(9), x.Has(123))

	z := x.Copy()
	x.Remove(42)
	fmt.Println(x.String())
	fmt.Println(z.String())

	fmt.Println(x.Len())
	fmt.Println(x.Elems())
}
