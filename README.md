# NexusHub

NexusHub is a cross-platform mobile application and admin web portal for residential society management. This repository contains the source code for the Minimum Viable Product (MVP).

## Directory Structure

*   `nexushub_mobile/`: Flutter application for residents (iOS and Android).
*   `nexushub_admin/`: Next.js web application for society administration.
*   `backend/`: Backend microservices, including:
    *   `AuthService/`: Handles user authentication.
    *   `VisitorService/`: Manages visitor information.
    *   `CommunicationService/`: Facilitates communication between residents and administration.
    *   `ComplaintService/`: Manages resident complaints.
    *   `EmergencyService/`: Handles emergency alerts.
    *   `database/`: Contains the PostgreSQL database schema.
    *   `kubernetes/`: Holds Kubernetes deployment files for the microservices.

## Getting Started

### Prerequisites

*   Flutter SDK
*   Node.js and npm
*   Docker and Kubernetes (for backend deployment)

### Mobile App Setup

1.  Navigate to the `nexushub_mobile` directory.
2.  Run `flutter pub get` to install dependencies.
3.  Run `flutter run` to start the application.

### Admin Portal Setup

1.  Navigate to the `nexushub_admin` directory.
2.  Run `npm install` to install dependencies.
3.  Run `npm run dev` to start the development server.
