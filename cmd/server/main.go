package main

//   - [ ] Go HTTP server with /health endpoint

import (
	"encoding/json"
	"fmt"
	"net/http"
)

type healthResponse struct {
	Status string `json:"status"`
}

func healthCheckHandler(w http.ResponseWriter, r *http.Request) {
	response := healthResponse{Status: "OK"}
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(response)
	var err error
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	fmt.Println("Health check endpoint hit")
}

func main() {
	http.HandleFunc("/health", healthCheckHandler)
	http.ListenAndServe(":8080", nil)

	fmt.Println("Server is running on port 8080")
}
