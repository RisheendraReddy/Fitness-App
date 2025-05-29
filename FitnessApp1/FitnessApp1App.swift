//
//  FitnessApp1App.swift
//  FitnessApp1
//
//  Created by Chris Pekin on 3/20/25.
//


//
//@main
//struct WorkoutApp: App {
//    init() {
//        FirebaseApp.configure()
//    }
//
//    var body: some Scene {
//        WindowGroup {
//            MainTabView()
//        }
//    }
//}
import SwiftUI
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import Firebase
import GoogleSignIn
//provided in documentation for firebase
//link for database
//set starting point
//original app delegate


//OLD
//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
//      let db = Firestore.firestore()
//
//    return true
//  }
//}

//MAIN
//starting point
@main
struct WorkoutApp: App {
    
    //delegate necssary for db
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

        @StateObject var authVM = AuthenticationView()
    @State private var showSplash = true
  //app startup nav heirarchy
    var body: some Scene {
        WindowGroup {
            //laoding icon view upon opening forced
            LoadingView{
                InitialView()
                //inject the vm here AUTHVM to access all info with it acrosss entire app
                    .environmentObject(authVM)
                //MainTabView()//app start point
              
            }
            
            // ContentView()
            // ActivityRingView()
        }
    }
}

//new app delegate--connected to firebase
class AppDelegate: NSObject, UIApplicationDelegate
{
    //using our application file
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool{
        FirebaseApp.configure()
        return true
    }
    
    @available(iOS 9.0, *)
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
