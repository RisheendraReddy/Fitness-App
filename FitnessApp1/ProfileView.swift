import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import CoreLocation
import MapKit


//USER PRIOFILE--ACCOUNT VIEW

struct ProfileView: View {
    
    @ObservedObject var workoutVM: WorkoutVM      // inject shared VM
    @State private var error: String = ""
    @State private var userName: String = "" // manual name entry fallback
    @EnvironmentObject var authVM: AuthenticationView
    @State private var displayName = "User"
     
    private let db = Firestore.firestore()
    
    //calculate and sum all users calories burned today
private var calsBurnedToday: Int
{
        let calendar = Calendar.current
     
        return workoutVM.workouts
            .filter { calendar.isDateInToday($0.date) }
            .map(\.caloriesBurned)
            .reduce(0, +)
    }
    
    var body: some View {
        NavigationView {
            ZStack
            {
                LinearGradient(
                    gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 16) {
                    // Top Bar
                    HStack {
                        //                        Button(action: { /* go back */ }) {
                        //                            Image(systemName: "chevron.left")
                        //                                .font(.title2)
                        //                                .foregroundColor(.white)
                        //                        }
                        Spacer()
                        
                        Spacer()
                        //                        Button(action: { /* open menu */ }) {
                        //                            Image(systemName: "line.horizontal.3")
                        //                                .font(.title2)
                        //                                .foregroundColor(.white)
                        //                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    // Header
                    HStack(alignment: .center, spacing: 12)
                    {
                        //user icon and name
                        Image("BuffIcon1")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            //get the name from vm that is extracted or entered by the user now
                            
                            //                            Text(authVM.displayName)
                            //                                .font(.title)
                            //                                .bold()
                            //                                .foregroundColor(.white)
                            //
                            Text(authVM.displayName.isEmpty
                                 ? "User"
                                 : authVM.displayName)
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                            
                        }
                        Spacer()
                    }
                    .padding(.horizontal,30)
                    ScrollView(showsIndicators: false)
                    {
                        //User's "Burned Today" section
                        HStack
                        {
                            VStack(alignment: .leading, spacing: 6)  {
                                Text("Burned Today")
                                
                                    .font(.headline)
                                     .foregroundColor(.white)
                                    
                                    Text("\(calsBurnedToday)")
                                 
                                     .font(.system(size: 60, weight: .bold))
                                    .foregroundColor(.white)
                                
                            }
                        Spacer()
                            
                            
                        }.padding(.horizontal,30)
                        
                        // User Stats, pulled from personalDetails
                        
                        VStack(alignment: .leading, spacing: 24)
                        {
                        
                            VStack(alignment: .leading, spacing: 12)
                            {
                                Text("Your Stats")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                HStack(spacing: 12)
                                {
//                                    StatCard(title: "Workouts", value: "\(workoutVM.workouts.count)")
//
//                                      .background(Color.white.opacity(0.1))
//                                      .cornerRadius(16)
////
//                                    StatCard(title: "Workouts", value: "\(workoutVM.workouts.count)")
//
//                                      .background(Color.white.opacity(0.1))
//                                      .cornerRadius(16)
                                    StatCard(title: "Weight", value: "\(authVM.weight)")
                                    
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(16)
                                    //
                                    StatCard(title: "Height", value: "\(authVM.height)")
                                    
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(16)
                                }
                                
                                
                            }.padding(.horizontal,10)
                            
                            
                            
                            // VStack{
                            HStack{
                                // HStack(spacing: 4){
                                VStack(alignment: .leading, spacing: 6){
                                    Text("Your Activity")
                                        .bold()
                                        .foregroundColor(.white)
                                    Spacer()
                                    NavigationLink {
                                        HomeView()
                                            .navigationBarTitle("Activity", displayMode: .inline)
                                    } label: {
                                        Image("rings")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 180, height: 180)
                                            .cornerRadius(20)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .frame(maxWidth: .infinity)
                                
                                
                                VStack(alignment: .leading, spacing: 6){
                                    Text("Your Routes")
                                        .bold()
                                        .foregroundColor(.white)
                                    Spacer()
                                    NavigationLink {
                                       SimpleRunMapView()
                                      
                                            .navigationBarTitle("Run Tracker", displayMode: .inline)
                                    } label: {
                                        Image("MapIcon")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 180, height: 180)
                                            .cornerRadius(20)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .frame(maxWidth: .infinity)
                                
                            }.padding()
                            
                            
                            
                            
            //LOGOUT BUTTON at bottom
                             VStack(spacing: 1) {
                                
                                 Button(action: {
                                    Task {
                                         do
                                        {
                                            // try await AuthenticationView().logout()
                                            try await authVM.logout()
                                         }
                                        catch (let e){
                                            
                                            //error = error.localizedDescription
                                            self.error = e.localizedDescription
                                         }
                                    }
                                }) {
                                     Text("Log Out")
                                        .bold()
                                        .foregroundColor(.blue)
                                         .padding(8)
                                    
                                        .frame(maxWidth: .infinity)//stretch
                                    
                                        .cornerRadius(8)
                                }
                                
                                if !error.isEmpty {
                                    Text(error)
                                        .foregroundColor(.red)
                                        .font(.caption)
                                }
                            }
                            .background(Color.white.opacity(0.5))
                             .cornerRadius(20)
                            .padding(.horizontal)
                            
                        }
                        .padding(.horizontal)
                          .padding(.bottom, 16)
                    }
                }
            }
            //make sure to load firebase data with calls form on appear--helps insure link
            .navigationBarHidden(true)
            .onAppear {
                workoutVM.loadMyWorkouts()
                // loadDisplayNameFromFirestore()
                authVM.getPersonalDetails()
            }
        }
    }
    
}
    
   //some issues with showing stats---->resolved

//KEEP?????????????
struct StatCard: View
{
     
    
    let title: String
        let value: String
        
    var body: some View
    {
           
            
            VStack
            {
                Text(title)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                
                
                Text(value)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            .frame(maxWidth: .infinity)
            .padding()
            
            .background(Color.white.opacity(0.1))
            
            .cornerRadius(12)
        }
    }
    
//
struct ProfileRow: View
{
        let icon: String
      
    let title: String
        
        var body: some View {
           
            
            HStack
            {
                 Image(systemName: icon)
                     .frame(width: 24)
                    .foregroundColor(.white)
               
                      Text(title)
                      .foregroundColor(.white)
                
                
                    Spacer()
              
                 Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.7))
            }
             .padding()
              .background(Color(.systemBackground))
        }
    }


//inject
//#Preview {
//    ProfileView(workoutVM: WorkoutVM())
//      .previewInterfaceOrientation(.portrait)
//}
