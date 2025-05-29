
//file for database setup
//firebase connection

import FirebaseFirestore
import SwiftUI
import FirebaseAuth


/*
class FirestoreService {
    private let db = Firestore.firestore()

    //How the workout is saved to Firestore
    //must have base collection already created to accept the data in the firebase
    func saveWorkout(workout: Workout, completion: @escaping (Bool) -> Void) {
        do {
            let _ = try db.collection("workouts").addDocument(from: workout)// add workour to db
            completion(true)
        } catch {
            print("Error saving workout: \(error.localizedDescription)")
            completion(false)
        }
    }

    //fxn to get the workouts existing in Firestore
    //how logged workputs are retrieved to be shown in the workout /activity log
    func getUsersWorkouts(completion: @escaping ([Workout]) -> Void)
    {
        //go to the collection workouts in db
        db.collection("workouts")
        //obtain via recency
            .order(by: "date", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching workouts: \(error.localizedDescription)")
                    completion([])
                } else {
                    let workouts = snapshot?.documents.compactMap { document -> Workout? in
                        try? document.data(as: Workout.self)
                    } ?? []
                    completion(workouts)
                }
            }
    }

}
*/
//new

class FirestoreService {
    //db connect
     private let db = Firestore.firestore()

    // Saves a Workout (which now includes userId)
//    func saveWorkout(_ workout: Workout, completion: @escaping(Bool)->Void) {
//        do {
//            _ = try db
//                .collection("workouts")
//                .addDocument(from: workout)
//            completion(true)
//        } catch {
//            print("Error saving workout:", error)
//            completion(false)
//        }
//    }
    
    
    //How the workout is saved to Firestore
    //must have base collection already created to accept the data in the firebase
    func saveWorkout(_ workout: Workout, completion: @escaping (Bool) -> Void)
    {
        //add a doc to db into our collection workouts
        do
        {
            _ = try db
                .collection("workouts")
                .addDocument(from: workout)
            completion(true)
        }
        catch
        {
            print("Error saving workout:", error)
            completion(false)
        }
    }
//old
    // Fetches only the logged‑in user’s workouts
//    func getUsersWorkouts(for userId: String, completion: @escaping([Workout])->Void) {
//        db.collection("workouts")
//          .whereField("userId", isEqualTo: userId)
//          .order(by: "date", descending: true)
//          .getDocuments { snap, error in
//            if let error = error {
//              print("Fetch error:", error)
//              completion([])
//            } else {
//              let wkts = snap?.documents.compactMap {
//                try? $0.data(as: Workout.self)
//              } ?? []
//              completion(wkts)
//            }
//        }
//    }
    // Fetches only the logged‑in user’s workouts
func getUsersWorkouts(for userId: String, completion: @escaping ([Workout]) -> Void) {
//        db.collection("workouts")
//          .whereField("userId", isEqualTo: userId)   //filter --make sure you add in the firebase condition as well in the actual db
//          .order(by: "date", descending: true)
        // NEW!!! only get the workouts where userId == current user’s UID
       //query for getting users workouts here sort by id then date to put on home view
        db.collection("workouts")
            //.whereField("userId", isEqualTo: Auth.auth().currentUser!.uid)
          .whereField("userId", isEqualTo: userId)
          .order(by: "date", descending: true)
        //update this as an index in fb db
          .getDocuments { snapshot, error in
             guard let docs = snapshot?.documents, error == nil
              else
              {
                print("Fetch error:", error ?? "Unknown")
                completion([])
                
                return
            }
            let workouts = docs.compactMap {
              try? $0.data(as: Workout.self)
            }
           
              
              print("Fetched \(workouts.count) workouts for \(userId)")
            completion(workouts)
          }
    }
   
     

    
    //for leaderboard fethcing
    //get every workout logged in the db
    
     func getAllLoggedWkts(completion: @escaping([Workout]) -> Void)
    {
        //get EVERY ekt by DATE
      db.collection("workouts")
        .order(by: "date", descending: true)
        .getDocuments { snap, error in
        
        guard let docs = snap?.documents, error == nil
        
            else
            {
            print("Leaderboard fetch error:", error ?? "unknown")
           
              completion([])
           
              return
          }
        ///make sure to get all
            
            let all = docs.compactMap { try? $0.data(as: Workout.self) }
          completion(all)
        }
    }

    //delete wkt fxn

func deleteWorkout(id: String, completion: @escaping(Bool)->Void)
    {
        //query to delet form db
        db.collection("workouts")
            .document(id)
            .delete { error in
                
                
                if let error = error {
                    print("Delete error:", error)
                    completion(false)
                } //e
               
                
                else
                {
                    completion(true)
                }
            }
    }
   
}

    
