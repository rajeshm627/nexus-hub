package main

import (
	"encoding/json"
	"log"
	"net/http"
	"time"

	"github.com/gorilla/mux"
)

type Announcement struct {
	Title       string    `json:"title"`
	Description string    `json:"description"`
	Timestamp   time.Time `json:"timestamp"`
}

var announcements = []Announcement{
	{
		Title:       "Water Supply Disruption",
		Description: "The water supply will be disrupted on Friday from 10 AM to 1 PM for maintenance work.",
		Timestamp:   time.Now(),
	},
	{
		Title:       "Monthly Maintenance Meeting",
		Description: "The monthly maintenance meeting will be held on Saturday at 11 AM in the clubhouse.",
		Timestamp:   time.Now().Add(-24 * time.Hour),
	},
}

func createAnnouncementHandler(w http.ResponseWriter, r *http.Request) {
	var announcement Announcement
	if err := json.NewDecoder(r.Body).Decode(&announcement); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	announcement.Timestamp = time.Now()
	announcements = append(announcements, announcement)

	log.Printf("New Announcement Created: %s", announcement.Title)

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(announcement)
}

func getAnnouncementsHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(announcements)
}

func main() {
	r := mux.NewRouter()
	r.HandleFunc("/create-announcement", createAnnouncementHandler).Methods("POST")
	r.HandleFunc("/get-announcements", getAnnouncementsHandler).Methods("GET")

	log.Println("AnnouncementService listening at http://localhost:3003")
	log.Fatal(http.ListenAndServe(":3003", r))
}
