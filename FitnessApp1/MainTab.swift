//
//  MainTab.swift
//  FitnessApp1
//
//  Created by Chris Pekin on 3/24/25.
//

//current main tab----will have to change eventually -----> good now
//tabs cycle through all other views---main functionality driver here

import SwiftUI

struct MainTabView: View {
    @StateObject var workoutVM = WorkoutVM()

    var body: some View {
       //BOTTOM TOOLBAR LOGIC
        TabView {
            //show the workouts and activity -- mainly a user will start/land here
             HomeView(workoutVM: workoutVM) //pass  the HomeView vm
                .tabItem {
                    Image(systemName: "house.fill")
                        .renderingMode(.template)
                    Text("Home")
                }
            WorkoutLoggingView(workoutVM: workoutVM)
            // Pass workoutVM here as well
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                        .renderingMode(.template)
                     Text("Log Workout")//-----> "Activity Log" (in future)--> good as of 4/20
                }
            //Evolve it to where its an activity log where they log their activity or more specific workout tracking via different buttons within the tab
          
            //allow users to learn about exercises
            ExerciseListView()
                   .tabItem {
                        Image(systemName: "list.bullet")
                           .renderingMode(.template)
                       Text("Exercises")
                   }
            //access leaderboard stats
            LeaderboardView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                        .renderingMode(.template)
                    Text("Leaderboard")
                }
            ProfileView(workoutVM: workoutVM)
                 .tabItem {
                    Image(systemName: "person.circle.fill")
                        .renderingMode(.template)
                     Text("Profile")
                }
//            ProfileView()
//                .tabItem {
//                    Image(systemName: "person.crop.circle")
//                       
//                   
//                       
//                    Text("Profile")
//                }
            
            //MAXED OUT at 5 tabs
            
            
            //1!!!!!!!!!!!!ADD A TAB FOR HOME AND MY PROFILE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        }
        .accentColor(.white) //change color of selected icon
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}


#Preview {
    MainTabView()
}
