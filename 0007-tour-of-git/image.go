package main

import (
	"image"
	"image/color"

	"code.google.com/p/go-tour/pic"
)

type Image struct {
	width, height int
}

func (self Image) ColorModel() color.Model {
	return color.RGBAModel
}

func (self Image) Bounds() image.Rectangle {
	return image.Rect(0, 0, self.width-1, self.height-1)
}

func (self Image) At(x, y int) color.Color {
	r := uint8(x ^ y)
	g := uint8((x + y) / 2)
	b := uint8(x * y)
	return color.RGBA{r, g, b, 255}
}

func main() {
	m := Image{256, 256}
	pic.ShowImage(m)
}
