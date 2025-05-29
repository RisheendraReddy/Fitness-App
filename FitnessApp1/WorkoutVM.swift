//
//  WorkoutVM.swift
//  FitnessApp1
//
//  Created by Chris Pekin on 3/24/25.
//
import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseAuth
//
//class WorkoutViewModel: ObservableObject {
//    @Published var workouts: [Workout] = []
//    
//    func logWorkout(workout: Workout) {
//        workouts.append(workout)
//    }
//}

class WorkoutVM: ObservableObject {
  
    @Published var workouts: [Workout] = []
  
    //initialize the DB
    private let firestoreService = FirestoreService()
//old
//    init()
//    {
//        
//        //Bring forth and get exisiting saved workouts in the DB when the app loads up and VM is initialized
//        getUsersWorkouts()
//    }
  
    //thurdsday 2pm
//    init() {
//        // load on startup
//        loadMyWorkouts()
//        // reload whenever auth state changes
//        Auth.auth().addStateDidChangeListener { _, user in
//            if user != nil {
//                self.loadMyWorkouts()
//            } else {
//                self.workouts = []
//            }
//        }
//    }
    //thursday 4pm
    init() {
           // reload whenever auth state changes
           Auth.auth().addStateDidChangeListener { _, _ in
               self.loadMyWorkouts()
           }
       }

//old
//Need to differentiate workout saving from activity saving-one will be for you to save your lifts with sets and reps
   
//    func logWorkout(type: String, duration: Int, caloriesBurned: Int)
//    {
//        //create and save a new workout below
//        let newWorkout = Workout(type: type, duration: duration, caloriesBurned: caloriesBurned, date: Date())
//
//        //save
//        firestoreService.saveWorkout(workout: newWorkout)
//        {
//            
//            success in
//            if success {
//                //// Refresh the workout list after saving
//                self.getUsersWorkouts()
//            }
//        }
//    }
  
    
    
//NEWWWWW
    
    func logWorkout(type: String, duration: Int, caloriesBurned: Int)
    {
        //if user logged-->auth---.allow to log workouts under same UID
        guard let uid = Auth.auth().currentUser?.uid
        else { return }
       //info to log and save to db
        let w = Workout(
          userId:          uid,
          type:           type,
          duration:        duration,
          caloriesBurned:  caloriesBurned,
          date:            Date()//automatic --not user entered --should keep it like this?/add edit option!!?????
        )
       
        
         firestoreService.saveWorkout(w) {  success  in
             if success {  self.loadMyWorkouts() }
        }
    }
    
    //hardcoded temp test
   
//    func loadWorkoutsForTestUser() {
//        let testUID = "vjnKaFq1iBNAmcYmi3wV0HUoFi43"
//        print("Loading workouts for test user:", testUID)
//        firestoreService.getUsersWorkouts(for: testUID) { fetched in
//            DispatchQueue.main.async {
//                self.workouts = fetched
//            }
//        }
//    }
    
func deleteWorkout(_ workout: Workout)
{
             guard let docId = workout.id else {    return }
            firestoreService.deleteWorkout(id: docId) {  success in
                 if success {
                    //wrkt removal
                    DispatchQueue.main.async {
                        self.workouts.removeAll {  $0.id == docId }
                    }
                    // Or: self.loadMyWorkouts()
                }
            }
        }
    

//old commented version deleted here if need refernce go to older files
    //thursday 1pm
    
func loadMyWorkouts()
    {
   //use of gaurd to know whos wrkts to retrieve via connected ID
        
         guard  let  uid = Auth.auth().currentUser?.uid
        else {
         DispatchQueue.main.async {  self.workouts = [] }
          return
      }
        
          firestoreService.getUsersWorkouts(for: uid) {  fetched  in
           DispatchQueue.main.async {
              self.workouts = fetched
        }
      }
    }
}

//#Preview {
//    WorkoutVM()
//}


