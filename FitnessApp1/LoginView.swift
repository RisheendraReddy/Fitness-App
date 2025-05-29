//
//  LoginView.swift
//  FitnessApp1
//
//  Created by Chris Pekin on 4/17/25.
// Risheendra Reddy Boddu on 4/17/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import GoogleSignInSwift

struct LoginView: View {
    @EnvironmentObject var authVM: AuthenticationView
    
    @State private var email = ""
    @State private var password = ""
    @State private var showError = ""
   
    
    //this var will help signal to alternating text at top based on status of is it a signup or not
    @State private var isSignup = false
  
    @State private var vm = AuthenticationView()
    
    
    @State private var isLoggedIn: Bool = false
    
    @State private var loginError = ""
    
    
    @State private var showingSuccessAlert = false
    
var body: some View
    {
        
        ZStack
        {
            //
            LinearGradient(
                           gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.8)]),
                           startPoint: .top, endPoint: .bottom
                       ).edgesIgnoringSafeArea(.all)
           
            
            VStack(spacing: 18)
            {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)//set frame needed
                
                //alternating text at top based on status of is it a signup or not
                Text(isSignup ? "Sign Up" : "Log in")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .bold()
               
                //            Button (action: {})
                //            {
                //                Text("Sign in with Google")
                //
                //                    .background(alignment: .leading) {
                //                        Image ("Google")
                //                            .frame(width:30, alignment: .center)
                //                    }
                //            }
                         .buttonStyle(.bordered)
//                TextField("Email", text: $email)
//                    .autocapitalization(.none)
//                    .padding()
//                    .background(Color.white.opacity(0.1))
//                    .cornerRadius(10)
//                    .foregroundColor(.white)
                TextField("", text : $email)
                   .placeholder(when: email.isEmpty) {
                     Text("Email")
                      .foregroundColor(Color.white.opacity(0.4)) // ghost text
                  }
                      .foregroundColor(.white)
                      .padding()
                      .background(Color.white.opacity(0.1))
                      .cornerRadius(12)
//                SecureField("Password", text: $password)
//                    .padding()
//                    .background(Color.white.opacity(0.1))
//                    .cornerRadius(10)
                SecureField("", text : $password)
                  .placeholder(when: password.isEmpty) {
                      Text("Password")
                      .foregroundColor(Color.white.opacity(0.4)) // ghost text
                  }
                      .foregroundColor(.white)
                      .padding()
                      .background(Color.white.opacity(0.1))
                      .cornerRadius(12)
                       
                Button(action: {
                    if isSignup {
                        authVM.signUp(email: email, password: password)
                    } else {
                        authVM.signIn(email: email, password: password)
                    }
                }) {
                    Text(isSignup ? "Sign Up" : "Log In")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding().background(Color.blue).cornerRadius(12)
                }
                .disabled(email.isEmpty || password.isEmpty)
                
                //from package documentation
                //            GoogleSignInButton {
                //              GIDSignIn.sharedInstance.signIn(withPresenting: yourViewController) { signInResult, error in
                //                  // check `error`; do something with `signInResult`
                //              }
                //            }
             
                //SIGN IN WITH GOOGLE
                //NATIVE BUTTON
                
        GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .light)){
                    
            
                   // vm.signInWithGoogle()
                    authVM.signInWithGoogle()
                }
                if !loginError.isEmpty{
                    Text(loginError)
                        .foregroundColor(.red)
                        .padding()
                }
                NavigationLink(value: isLoggedIn){
                    EmptyView()
                }
                .navigationDestination(isPresented: $isLoggedIn){
                    MainTabView()
                        .navigationBarBackButtonHidden(true)
                }
                
        //alternating button based on is sign up bool
                
    Button(action: { isSignup.toggle() }) {
                   
         Text(isSignup ? "Have an account? Log in" : "Don't have an account? Sign up")
                         .font(.footnote)
                        .foregroundColor(.white)
                }
                
                if !showError.isEmpty {
                    Text(showError)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
                //                if let error = authVM.errorMessage {
                //                    Text(error)
                //                      .foregroundColor(.red)
                //                      .padding(.top, 8)
                //                }
                
                //                if let success = authVM.successMessage {
                //                    Text(success)
                //                      .foregroundColor(.green)
                //                      .padding(.top, 8)
                //                }
                
            }.alert(isPresented: $showingSuccessAlert) {
                Alert(
                    title: Text("Success"),
                    message: Text(authVM.successMessage ?? ""),
                    dismissButton: .default(Text("OK")) {
                        // maybe manually trigger navigation here instead of auto‐link
                    }
                )
            }
            .padding()
            
            
    //        .background(
    //            LinearGradient(
    //                gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.8)]),
    //                startPoint: .top, endPoint: .bottom
    //            ).edgesIgnoringSafeArea(.all)
    //        )
        }
        }
}

//#Preview {
//    LoginView()
//        .environmentObject(AuthViewModel()) //
//}



//new prev --user
//#Preview {
//    LoginView()
//}
