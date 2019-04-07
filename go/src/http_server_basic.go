// http://sourabhbajaj.com/mac-setup/Go/README.html
// https://github.com/gorilla/mux 

package main

import (
	"fmt"
    "net/http"
    "log"
	"github.com/gorilla/mux" // Imported Go Package
)

func YourHandler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("Gorilla!\n"))
	fmt.Printf("Hello\n")
}

func main() {
    r := mux.NewRouter()
    // Routes consist of a path and a handler function.
    r.HandleFunc("/", YourHandler)

    // Bind to a port and pass our router in
    log.Fatal(http.ListenAndServe(":8000", r))
}