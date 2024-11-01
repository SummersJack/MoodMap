import SwiftUI

struct AuthenticationView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @Binding var email: String
    @Binding var password: String
    
    @State private var isSignUp: Bool = true // Toggle between sign up and login

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

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

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
                    if isSignUp {
                        authViewModel.signUp(email: email, password: password)
                    } else {
                        authViewModel.logIn(email: email, password: password)
                    }
                }) {
                    Text(isSignUp ? "Sign Up" : "Log In")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()

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
}
