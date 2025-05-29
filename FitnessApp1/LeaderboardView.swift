//
//  LeaderboardView.swift
//  FitnessApp1


//  Created by Chris Pekin on 4/17/25.
// Risheendra Reddy Boddu on 4/17/25.
//old submission
//scroll down




//import SwiftUI
//
//struct LeaderboardEntry: Identifiable {
//    let id = UUID()
//    let username: String
//    let totalCaloriesBurned: Int
//    let profileImage: String
//}
//
//struct LeaderboardView: View {
//
//    //mock leaerboard data--expand functionality
//    let leaderboardData = [
//        LeaderboardEntry(username: "Chris", totalCaloriesBurned: 3000, profileImage: "profile1"),
//        LeaderboardEntry(username: "Rishi", totalCaloriesBurned: 2500, profileImage: "profile2"),
//        LeaderboardEntry(username: "Alex", totalCaloriesBurned: 2200, profileImage: "profile3"),
//        LeaderboardEntry(username: "Jamie", totalCaloriesBurned: 1900, profileImage: "profile4"),
//        LeaderboardEntry(username: "Sam", totalCaloriesBurned: 1800, profileImage: "profile5")
//    ]
//
//    var body: some View {
//        ZStack {
//
//            LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.8)]),
//                           startPoint: .top, endPoint: .bottom)
//                .edgesIgnoringSafeArea(.all)
//
//            VStack {
//
//                Text("Leaderboard")
//                    .font(.largeTitle)
//                    .bold()
//                    .foregroundColor(.white)
//                    .padding(.top, 40)
//                //modify to show at idfferent heights
//                HStack {
//                    ForEach(leaderboardData.prefix(3).indices, id: \.self)
//                    {
//                        index in TopThreeView(entry: leaderboardData[index], rank: index + 1)
//                    }
//                }
//                .padding(.vertical)
//
//                ScrollView {
//                    VStack(spacing: 15) {
//                        ForEach(leaderboardData.dropFirst(0))
//                        {
//                            entry in LeaderboardRow(entry: entry)
//                        }
//                    }
//                    .padding()
//                }
//            }
//        }
//    }
//}
//
//struct TopThreeView: View {
//
//
//    let entry: LeaderboardEntry
//    let rank: Int
//
//    var body: some View {
//        VStack {
//            Image(entry.profileImage)
//                .resizable()
//                .scaledToFill()
//                .frame(width: 80, height: 80)
//                .clipShape(Circle())
//                .overlay(Circle().stroke(Color.white, lineWidth: 3))
//                .shadow(radius: 5)
//
//            Text(entry.username)
//                .font(.headline)
//                .foregroundColor(.white)
//            //adjust colors
//            //green?
//
//            Text("\(entry.totalCaloriesBurned) Cal")
//                .font(.title3)
//                .bold()
//                .foregroundColor(rank == 1 ? .yellow : .white)
//        }
//        .padding()
//    }
//}
//
////each user row on the leaderboard
//struct LeaderboardRow: View {
//    let entry: LeaderboardEntry
//
//    var body: some View {
//        HStack {
//            //load avatars images etc...
//            Image(entry.profileImage)
//                .resizable()
//                .scaledToFill()
//                .frame(width: 50, height: 50)
//                .clipShape(Circle())
//
//            VStack(alignment: .leading) {
//
//                Text(entry.username)
//                    .font(.headline)
//                    .foregroundColor(.white)
//
//                Text("\(entry.totalCaloriesBurned) Calories Burned")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
//
//            Spacer()
//
//            Text("\(entry.totalCaloriesBurned)")
//                .font(.headline)
//                .bold()
//                .foregroundColor(.green)
//        }
//        .padding()
//        .background(Color.blue.opacity(0.3))
//        .clipShape(RoundedRectangle(cornerRadius: 10))
//        .shadow(radius: 3)
//    }
//}
//
//#Preview {
//    LeaderboardView()
//}

//live updating leaderboard
//gamification here
//  Created by Chris Pekin on 4/17/25.
// Risheendra Reddy Boddu on 4/17/25.

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LeaderboardView: View {
    @StateObject private var vm = LeaderboardVM()

    var body: some View {
        ZStack {
            // background gradient
            LinearGradient(
              gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.8)]),
              startPoint: .top, endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Leaderboard")
                  .font(.largeTitle).bold().foregroundColor(.white)
                  .padding(.top, 40)

                // Top 3 view here
                HStack(spacing: 16) {
                    ForEach(Array(vm.entries.prefix(3).enumerated()),
                            id: \.element.id) { idx, entry in
                        TopThreeView(entry: entry, rank: idx+1)
                    }
                }
                .padding(.vertical)

               //show the rest as cards in a scrolling view
                ScrollView
                {
                  VStack(spacing: 12)
                    {
                        //incorporated a drop function as to not show the top ranking individuals below as well
                    ForEach(vm.entries.dropFirst(3), id: \.id) { entry in
                        
                        LeaderboardRow(entry: entry)
                    }
                  }
                  .padding(.horizontal)
                }
            }
            .onAppear { vm.loadLeaderboard() }
        }
    }
}
//keep together for now see if we can seperate it later


//TOP THREE VIEW FOR LEADERBOARD
//showcases the highest 3 burning users
//3 boxes not cards
struct TopThreeView: View
{
 
    let entry: LeaderboardEntry
    let rank: Int

    var body: some View
    {
        VStack
        {
            //procedural avatar image --roatates randomly
            Image(entry.avatarName)
              .resizable().scaledToFill()
              .frame(width: 80, height: 80)
              .clipShape(Circle())
              .overlay(Circle().stroke(Color.white, lineWidth: 3))
              .shadow(radius: 5)
//finally can implement dipslay name --see changes in authview and firebase services
           
             Text(entry.displayName)
              .font(.headline).foregroundColor(.white)

             Text("\(entry.totalCalories) Cal")
              .font(.title3).bold()
              .foregroundColor(rank == 1 ? .green : .white)//leader gets some green text while others get white
        }
         .padding()
          .background(Color.white.opacity(0.1))
           .cornerRadius(12)
    }
}


//if not in top 3
//show as a leaderboard row below top 3
//similar to the wrkt logging cards
struct LeaderboardRow: View
{
     let entry: LeaderboardEntry

    var body: some View
    {
         HStack(spacing:8)
        {
            
            Image(entry.avatarName)
              .resizable().scaledToFill()
              .frame(width: 50, height: 50)//set size --not max width or infin
              .clipShape(Circle())
      
            Spacer()
          
            
            //fix alignment here NEEDS WORK
           // ??FIX!!!!!!
         
            VStack(alignment: .leading , spacing: 4) {
                Text(entry.displayName)
                   .font(.headline)
                  .foregroundColor(.white)
                //HStack{
                   //  Spacer()
                    Text("\(entry.totalCalories) Calories")
                      .font(.subheadline)
                      .foregroundColor(.white)
             //   }
            }

            
        }
        .padding()
         .background(Color.blue.opacity(0.3))
         .cornerRadius(10)
        .shadow(radius: 2)
        //add in consistent ui with rouding and shadows^ ---good now
    }
}



//
//
//struct LeaderboardView_Previews: PreviewProvider {
//  static var previews: some View {
//    LeaderboardView()
//  }
//}

