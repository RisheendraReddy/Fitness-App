//
//  AuthenticationView.swift
//  FitnessApp1
//
//  Created by Chris Pekin on 4/17/25.
//

import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseFirestore
import AppAuth
import FirebaseAuth

//page to help wiht logging in and authetications
class AuthenticationView: ObservableObject{
    @Published var successfulLogin = false
    
    @Published var errorMessage: String?
 //bring in the database
    private let db = Firestore.firestore()
    
    @Published var successMessage: String?
    //for users personal details-prompt new users and google sign ups
    @Published var personalDetailsNeeded = false
    //the rest are below
    @Published var displayName: String = "User"
    
    
    //@Published var profile: UserProfile?
    
   
    //saturday
    //see old versions for thursdays prior installation
    
    //new sign up fxn
    //use auth auth
    
    //some repeated logic between variables set true/false for listeners and the dispatchqueue but it was all working fluidly so did not want to sirsupt and remove then break something
    
    func signUp(email: String, password: String)
    {
        Auth.auth().createUser(withEmail: email, password: password) { res, error in
            DispatchQueue.main.async
            {
           //error case from auth
               
                if let error = error
                {
                    self.errorMessage = error.localizedDescription
                    self.successfulLogin = false
                }
                //if user credentials saved via auth then add as a persistent profile , and send to fill perosal detsails as new users
                //denote a success
                else {
                    self.persistUserProfile()
                    self.personalDetailsNeeded     = true
                    self.successfulLogin = true
                }
            }
        }
    }
   
    //siging in existing
    func signIn(email: String, password: String)
    {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                //error case from auth
             
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.successfulLogin = false
                }
                
                //if good sign in-set to true-listener will see and prompt forward in navigation to home
                else {
                    self.successfulLogin = true
                }
            }
        }
    }
    
        //thursday
    
        //deleted
    
    //saturday
    //other variable declarations for personal detail saving and pulling from profile and leaderboard
    
      @Published var height: Int       = 0
      @Published var weight: Int       = 0
      @Published var age: Int          = 0
      @Published var activityStyle: String = ""
    
    //Use your google accnt to sign in to the app
    //use google api
    //used internet and samples --google api documentation to assit on this section
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        //api sign in
        GIDSignIn.sharedInstance.signIn(withPresenting: applicationControl.rootViewController) { user, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard
                let user = user?.user,
                let idToken = user.idToken
            else { return }
            
            
            
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken.tokenString,
                accessToken: accessToken.tokenString
            )
            
            Auth.auth().signIn(with: credential) { res, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        self.successfulLogin = false
                    } else {
                        self.persistUserProfile()
                        self.successfulLogin = true
                    }
                }
            }
        }
    }
    
    //helper function for saving and retrieval
    //needed earlier can prob elimainte now
    private func persistUserProfile()
    {
        guard let user = Auth.auth().currentUser else { return }
        
        
         let queryDoc = db.collection("users").document(user.uid)
       
        queryDoc.setData([ "displayName":  user.displayName ?? "",
                        "email":        user.email       ?? ""
        ], merge: true) {  error in
             if let error = error {
                 print("Could not write user profile:", error)
            }
        }
    }
    
    //see if user needs to get sent to log their deails
    //for new users and sign ups--or those that havent logged yet
    private func checkIfNeedsDetails() {
        //id check
        guard let uid = Auth.auth().currentUser?.uid else { return }
        //make sure the current user is siged in and we are accesing only the details of that ID
        
        //query queryDoc in db
        //see if items r in firebase if not send to fil them and save them
        let queryDoc = db.collection("users").document(uid)
        queryDoc.getDocument { snap, _ in
            let data = snap?.data() ?? [:]
        
            // if any of these missing, send them to enter them in the details view
            //this is the check
            let hasAll = data["displayName"] != nil
            data["height"] != nil
            && data["weight"] != nil
            && data["age"]    != nil
            && data["activityStyle"] != nil
           
            DispatchQueue.main.async {
                self.personalDetailsNeeded = !hasAll
            }
        }
    }
    
    //save details user enters in DB linkd to UID
    //key inputs
    func savePersonalDetails( displayName: String, height: Int, weight: Int, age: Int, style: String, completion: @escaping(Bool)->Void)
    {
        //uid check
        //make sure the current user is siged in and we are accesing only the details of that ID
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(false); return
        }
        //query to write to db --write to uid
        db.collection("users").document(uid).setData([
                "displayName": displayName,
                
                "height":        height,
               
                "weight":        weight,
              
                "age":           age,
               
                "activityStyle": style
            ], merge: true) { error in
                DispatchQueue.main.async
                {
                    if error == nil {
                        self.personalDetailsNeeded = false   // note that sign up and detials is complete
                        completion(true)//set true
                    } else {
                        completion(false)
                    }
                }
            }
    }
   
    
    //fxn to go get details from Firestore, saved and entered by users
        func getPersonalDetails(completion: @escaping(Bool)->Void = { _ in })
        {
            //make sure the current user is siged in and we are accesing only the details of that ID
            guard let uid = Auth.auth().currentUser?.uid else {
                completion(false); return
            }
            //important query
            //helps app know how to search FB databse and what to look foe
            
            db.collection("users").document(uid)
              .getDocument { snapshot, error in
                DispatchQueue.main.async {
                 
                if let data = snapshot?.data(), error == nil
                {
                    //retrieval of these variables so that rest of app can access
                    //--namely issues w displayname
                    self.displayName   = data["displayName"]   as? String ?? ""
                    self.height        = data["height"]        as? Int    ?? 0
                    self.weight        = data["weight"]        as? Int    ?? 0
                    self.age           = data["age"]           as? Int    ?? 0
                    self.activityStyle = data["activityStyle"] as? String ?? ""
                    //set to false since we already have details --dont need once filled
                    self.personalDetailsNeeded  = false
                        completion(true)
                  }
                    else
                    {
                        completion(false)
                  }
                }
            }
        }
    
    
    //Logging out fxn
    func logout() async throws {
        
        
        //force a sign out of everything
        //if signed in via google
        //then sign out of Google
        GIDSignIn.sharedInstance.signOut()
        
        //also sign out of Firebase
        try Auth.auth().signOut()
        
        
        
        DispatchQueue.main.async {
        self.successfulLogin = false
        }
    }
}
  

