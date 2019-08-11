package main

import (
	"fmt"
	"html/template"
	"log"
	"net/http"
)

var listTemplate = template.Must(template.New("list").Parse(`<!DOCTYPE html>
<html>
	<head>
		<title>Price list</title>
	</head>
	<body>
		<table>
			<tr>
				<th>Item</th>
				<th>Price</th>
			</tr>
			{{- range $item, $price := . }}
			<tr>
				<td>{{ $item }}</td>
				<td>{{ $price }}</td>
			</tr>
			{{- end }}
		</table>
	</body>
</html>
`))

func main() {
	db := database{"shoes": 50, "socks": 5}
	mux := http.NewServeMux()
	mux.HandleFunc("/list", db.list)
	mux.HandleFunc("/price", db.price)
	log.Fatal(http.ListenAndServe("localhost:8000", mux))
}

type dollars float32

func (d dollars) String() string {
	return fmt.Sprintf("$%.2f", d)
}

type database map[string]dollars

func (db database) list(w http.ResponseWriter, req *http.Request) {
	if err := listTemplate.Execute(w, db); err != nil {
		log.Fatal(err)
	}
}

func (db database) price(w http.ResponseWriter, req *http.Request) {
	item := req.URL.Query().Get("item")
	price, ok := db[item]
	if !ok {
		w.WriteHeader(http.StatusNotFound) // 404
		fmt.Fprintf(w, "no such item: %q\n", item)
		return
	}
	fmt.Fprintf(w, "%s\n", price)
}
