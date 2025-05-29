import Foundation
import SwiftUI


//user struct file--will build on in coming weeks
//incorporate passwords and login functionality so workouts and calories are user specific

//for saving users to DB
struct User
{
    let id: String
    let name: String
    let email: String
    var workouts: [Workout]
}
