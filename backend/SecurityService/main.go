package main

import (
	"encoding/json"
	"log"
	"net/http"
	"time"

	"github.com/gorilla/mux"
)

type LogVisitorRequest struct {
	VisitorName string `json:"visitorName"`
	FlatNumber  string `json:"flatNumber"`
	PhotoURL    string `json:"photoUrl"`
}

type LogVisitorResponse struct {
	Message string `json:"message"`
}

func logVisitorHandler(w http.ResponseWriter, r *http.Request) {
	var req LogVisitorRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	if req.VisitorName == "" || req.FlatNumber == "" {
		http.Error(w, "Visitor name and flat number are required", http.StatusBadRequest)
		return
	}

	log.Printf(`Visitor Logged:
    Name: %s
    Flat Number: %s
    Photo URL: %s
    Timestamp: %s
  `, req.VisitorName, req.FlatNumber, req.PhotoURL, time.Now().Format(time.RFC3339))

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(LogVisitorResponse{Message: "Visitor logged successfully"})
}

func main() {
	r := mux.NewRouter()
	r.HandleFunc("/log-visitor", logVisitorHandler).Methods("POST")

	log.Println("SecurityService listening at http://localhost:3002")
	log.Fatal(http.ListenAndServe(":3002", r))
}
