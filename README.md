Mini Social App:
                This is a minimal social media application built with Flutter and Firebase. I implement a Clean Architecture to keep the logic strictly from the UI.

How to get:
Clone the project:   " https://github.com/Younis7575/mini-socio.git"

Firebase Setup:
             Firebase Console.
             Enable Google Sign-In.
             Enable Firestore (used Firestore to store Files becaus Storage is paid)
             Drop your google-services.json into android/app/.

Install & Run:
             flutter clean
             flutter pub get
             flutter run

Architectural Decisions
             I used a Clean Architecture with Getx to meet the requirement.
             Presentation (GetX): controllers and bindings
             Domain: Entities and Repository interfaces.
             Data: Firebase Services.

Features implemented
             Google Sign-In.
             posts.
             like/unlike posts ,comments.
             profile screen (can update name)
 

Security (Firestore Rules)

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
     
    match /users/{userId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
     
    match /posts/{postId} {
      allow read: if true;
      
      allow create: if request.auth != null 
                    && request.resource.data.userId == request.auth.uid;

      allow update: if request.auth != null 
                    && (request.resource.data.diff(resource.data).affectedKeys().hasOnly(['likes', 'commentCount']));

      allow delete: if request.auth != null 
                    && resource.data.userId == request.auth.uid;

      // ADD THIS SECTION FOR COMMENTS
      match /comments/{commentId} {
        allow read: if true;
        // Allows any logged-in user to post a comment
        allow create: if request.auth != null 
                      && request.resource.data.userId == request.auth.uid;
      }
    }
  }
}