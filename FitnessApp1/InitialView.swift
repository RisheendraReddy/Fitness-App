//
//  InitialView.swift
//  FitnessApp1
//
//  Created by Chris Pekin on 4/17/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth


//thursday 5pm
//struct InitialView: View {
//    @EnvironmentObject var authVM: AuthenticationView
//    @State private var userLoggedIn = Auth.auth().currentUser != nil
//
//    var body: some View {
//        Group
//        {
//            if userLoggedIn || authVM.successfulLogin {
//                MainTabView()
//            } else {
//                LoginView()
//            }
//        }
//        Group {
//          if authVM.successfulLogin {
//            if authVM.personalDetailsNeeded {
//              OnboardingView()
//            } else {
//              MainTabView()
//            }
//          } else {
//            LoginView()
//          }
//        }
//        .environmentObject(authVM)
//        .onAppear {
//            // seed initial state
//            userLoggedIn = Auth.auth().currentUser != nil
//
//            // listen for any auth changes (email/password or Google)
//            Auth.auth().addStateDidChangeListener { _, user in
//                userLoggedIn = (user != nil)
//            }
//        }
//    }
//}


//staurday 2pm
//newest --old versions contain more commments and junk code
import SwiftUI
import FirebaseAuth

struct InitialView: View {
    @EnvironmentObject var authVM: AuthenticationView
//previous versions had listener for auth
    //work in if needed agiain--work w/o currently
    var body: some View {
        Group {
            if authVM.successfulLogin {
                // If user still need to do their details
                if authVM.personalDetailsNeeded {
                    OnboardingView()
                } else {
                   //go to main tab view --app functionality here HERE
                    MainTabView()
                }
            } else {
                // Not signed in yet: stay on or prompt to the login/signup screen
                LoginView()
            }
        }
        
        //page switch animaiton---upon login //
        .animation(.easeInOut, value: authVM.successfulLogin)
        .animation(.easeInOut, value: authVM.personalDetailsNeeded)
    }
}

//prev

struct InitialView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView()
        //inject
          .environmentObject(AuthenticationView())
    }
}


#Preview {
    LoginView()
      .environmentObject(AuthenticationView())
}


