package main

import (
	"encoding/json"
	"fmt"
	"log"
	"math/rand"
	"net/http"
	"os"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/gorilla/mux"
	"github.com/joho/godotenv"
)

var otpStore = make(map[string]string)

type GenerateOTPRequest struct {
	EmailOrMobile string `json:"emailOrMobile"`
}

type VerifyOTPRequest struct {
	EmailOrMobile string `json:"emailOrMobile"`
	OTP           string `json:"otp"`
}

type GenerateOTPResponse struct {
	Message string `json:"message"`
}

type VerifyOTPResponse struct {
	Token string `json:"token"`
}

func generateOTPHandler(w http.ResponseWriter, r *http.Request) {
	var req GenerateOTPRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	if req.EmailOrMobile == "" {
		http.Error(w, "Email or mobile number is required", http.StatusBadRequest)
		return
	}

	otp := fmt.Sprintf("%06d", rand.Intn(1000000))
	otpStore[req.EmailOrMobile] = otp

	log.Printf("OTP for %s: %s", req.EmailOrMobile, otp)

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(GenerateOTPResponse{Message: "OTP generated and sent"})
}

func verifyOTPHandler(w http.ResponseWriter, r *http.Request) {
	var req VerifyOTPRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	if req.EmailOrMobile == "" || req.OTP == "" {
		http.Error(w, "Email/mobile and OTP are required", http.StatusBadRequest)
		return
	}

	if otp, ok := otpStore[req.EmailOrMobile]; ok && otp == req.OTP {
		delete(otpStore, req.EmailOrMobile) // OTPs should be single-use

		token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
			"emailOrMobile": req.EmailOrMobile,
			"exp":           time.Now().Add(time.Hour * 1).Unix(),
		})

		tokenString, err := token.SignedString([]byte(os.Getenv("JWT_SECRET")))
		if err != nil {
			http.Error(w, "Failed to generate token", http.StatusInternalServerError)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(VerifyOTPResponse{Token: tokenString})
	} else {
		http.Error(w, "Invalid OTP", http.StatusBadRequest)
	}
}

func main() {
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found")
	}

	r := mux.NewRouter()
	r.HandleFunc("/generate-otp", generateOTPHandler).Methods("POST")
	r.HandleFunc("/verify-otp", verifyOTPHandler).Methods("POST")

	log.Println("AuthService listening at http://localhost:3001")
	log.Fatal(http.ListenAndServe(":3001", r))
}
