import SwiftUI

struct AuthenticationView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @Binding var email: String
    @Binding var password: String
    
    @State private var isSignUp: Bool = true // Toggle between sign up and login
    @State private var emailError: String?
    @State private var passwordError: String?

    var body: some View {
        VStack {
            Text(isSignUp ? "Create Account" : "Log In")
                .font(.largeTitle)
                .padding()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .onChange(of: email) { newValue in
                    emailError = newValue.isEmpty ? "Email cannot be empty" : nil
                }
                .overlay(
                    emailError.map { error in
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.top, 5)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                )

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: password) { newValue in
                    passwordError = newValue.count < 6 ? "Password must be at least 6 characters" : nil
                }
                .overlay(
                    passwordError.map { error in
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.top, 5)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                )

            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            if authViewModel.isLoading {
                ProgressView("Loading...")
                    .padding()
            } else {
                Button(action: {
                    validateAndPerformAction()
                }) {
                    Text(isSignUp ? "Sign Up" : "Log In")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                .disabled(emailError != nil || passwordError != nil)

                Button(action: {
                    isSignUp.toggle() // Toggle between sign up and login
                }) {
                    Text(isSignUp ? "Already have an account? Log In" : "Don't have an account? Sign Up")
                        .foregroundColor(.blue)
                        .padding()
                }

                Button("Forgot Password?") {
                    authViewModel.resetPassword(email: email)
                }
                .foregroundColor(.blue)
                .padding()
            }
        }
        .padding()
        .onAppear {
            // Clear error message when the view appears
            authViewModel.errorMessage = nil
        }
    }
    
    private func validateAndPerformAction() {
        // Reset error messages before validation
        emailError = nil
        passwordError = nil

        // Simple validation
        if email.isEmpty {
            emailError = "Email cannot be empty"
        }
        if password.count < 6 {
            passwordError = "Password must be at least 6 characters"
        }
        
        if emailError == nil && passwordError == nil {
            if isSignUp {
                authViewModel.signUp(email: email, password: password)
            } else {
                authViewModel.logIn(email: email, password: password)
            }
        }
    }
}
