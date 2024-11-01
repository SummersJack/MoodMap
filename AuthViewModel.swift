import Firebase
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    init() {
        self.user = Auth.auth().currentUser
    }
    
    // Sign up a new user
    func signUp(email: String, password: String) {
        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            self.isLoading = false
            if let error = error {
                self.errorMessage = self.handleAuthError(error)
                print("Error signing up: \(self.errorMessage ?? "")")
                return
            }
            self.user = result?.user
            self.errorMessage = nil // Clear any previous errors
            self.saveUserProfile(email: email) // Save user profile info if needed
        }
    }
    
    // Log in an existing user
    func logIn(email: String, password: String) {
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            self.isLoading = false
            if let error = error {
                self.errorMessage = self.handleAuthError(error)
                print("Error logging in: \(self.errorMessage ?? "")")
                return
            }
            self.user = result?.user
            self.errorMessage = nil // Clear any previous errors
        }
    }
    
    // Log out the current user
    func logOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.errorMessage = nil // Clear any previous errors
        } catch let signOutError as NSError {
            self.errorMessage = "Error signing out: \(signOutError.localizedDescription)"
            print(self.errorMessage ?? "")
        }
    }
    
    // Reset password
    func resetPassword(email: String) {
        isLoading = true
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            self.isLoading = false
            if let error = error {
                self.errorMessage = "Error resetting password: \(error.localizedDescription)"
                print(self.errorMessage ?? "")
                return
            }
            self.errorMessage = "Password reset email sent. Please check your inbox."
        }
    }
    
    // Handle authentication errors
    private func handleAuthError(_ error: Error) -> String {
        let errorCode = (error as NSError).code
        switch errorCode {
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return "Email is already in use."
        case AuthErrorCode.invalidEmail.rawValue:
            return "Invalid email address."
        case AuthErrorCode.weakPassword.rawValue:
            return "Password is too weak. Please choose a stronger password."
        case AuthErrorCode.userNotFound.rawValue:
            return "No user found with this email."
        case AuthErrorCode.wrongPassword.rawValue:
            return "Incorrect password. Please try again."
        default:
            return "Authentication failed. Please try again."
        }
    }
    
    // Save user profile information
    private func saveUserProfile(email: String) {
        // Implement saving user profile info to Firestore or another database if needed
    }
}
