import Foundation
import SwiftUI

//base workkout file -model
//struct Workout: Identifiable, Codable {
//    let id: UUID = UUID()
//    let type: String
//    let duration: Int // in minutes
//    let caloriesBurned: Int
//    let date: Date
//}

import FirebaseFirestore
//new workout model to be saved and linked by user ID in FB so later when we want to only get that users data we can retrieve it easily w new model

//have to update quereis and firebase structure to match

struct Workout: Identifiable, Codable {
    @DocumentID var id: String?
    let userId: String
    let type: String
    let duration: Int
    let caloriesBurned: Int
    let date: Date
}
