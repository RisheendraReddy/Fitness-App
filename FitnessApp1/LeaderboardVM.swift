//
//  LeaderboardVM.swift
//  FitnessApp1
//

// Risheendra Reddy Boddu on 4/17/25.

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

//
//struct LeaderboardVM: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//#Preview {
//    LeaderboardVM()
//}

//this is the info going into each leaderboard card/entry
struct LeaderboardEntry: Identifiable
{
    let id: String
    let displayName: String
    let totalCalories: Int
    let avatarName: String     //stored in preview content for prof pic
}

//leadrboard view model
class LeaderboardVM: ObservableObject
{
    //store all leader ranks in this dictionary
    @Published var entries: [LeaderboardEntry] = []
    private let db = Firestore.firestore()

    func loadLeaderboard() {
      //query all workouts form functioin to get all of them not id related
        db.collection("workouts")
          .getDocuments { snap, error in
            //get all guard
                    guard let docs = snap?.documents, error == nil else {
                print("Workout fetch error:", error ?? "")
                 return
            }
              let workouts = docs.compactMap { try? $0.data(as: Workout.self) }

//calc cals form competition rank
           
              let totals = Dictionary(
                grouping: workouts,
                by: { $0.userId }
            ).mapValues { ws in ws.reduce(0) { $0 + $1.caloriesBurned } }

          
            let uids = Array(totals.keys)
           
              
              guard !uids.isEmpty else {
                DispatchQueue.main.async { self.entries = [] }
                return
            }

              self.db.collection("users")
              .whereField(FieldPath.documentID(), in: uids)
              .getDocuments { userSnap, _ in
                let users = userSnap?.documents.reduce(into: [String: [String:Any]]()) {
                  dict, queryDoc in dict[queryDoc.documentID] = queryDoc.data()
                } ?? [:]

                //enrry cards for LB
                let list = totals.map { uid, total -> LeaderboardEntry in
                  let data = users[uid] ?? [:]

                  
                  let name: String = {
                    if let dn = data["displayName"] as? String, !dn.isEmpty {
                      return dn
                    }
                    if let email = data["email"] as? String,
                       let prefix = email.split(separator: "@").first {
                      return String(prefix)
                    }
                    return "User"
                  }()
//place to pull prof pictures from --randomized
                    let avatarPool = ["avatar1","avatar2","avatar3","avatar4","avatar5","avatar6"]
                    let avatarForThisUID = avatarPool.randomElement()!
//send the pic to the entry--show
                    return LeaderboardEntry(
                      id: uid,
                      displayName: name,
                      totalCalories: total,
                      avatarName: avatarForThisUID
                    )
                }

                DispatchQueue.main.async {
                  self.entries = list
                    .sorted { $0.totalCalories > $1.totalCalories }
                }
              }
        }
    }
}
