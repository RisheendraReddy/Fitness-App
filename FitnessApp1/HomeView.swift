//
//  HomeView.swift
//  FitnessApp1
//
//  Created by Chris Pekin on 3/24/25.
//
//home view show user the workout cards!!!
import SwiftUI
//change name to activity log since this is what it is --not a home view originally was
struct HomeView: View {
    
    //@ObservedObject var workoutVM = WorkoutVM()
    @ObservedObject var workoutVM: WorkoutVM
  //  private var calsBurnedToday: Int = 300 // harcode temporary
   //qucik fxn for daily tracking
    private var calsBurnedToday: Int
    {
        let calendar = Calendar.current
        //quick by day mapping implementation
        //isDateInToday
       
        return workoutVM.workouts
            .filter { calendar.isDateInToday($0.date) }
            .map(\.caloriesBurned)
             .reduce(0, +)
    }

    private let calendar = Calendar.current
    //standard date format helper
    private static let dayFormatter: DateFormatter =
    {
           let df = DateFormatter()
           df.dateStyle = .medium
           df.timeStyle = .none
           return df
       }()

       //group the workouts by startOfDay,
            //sort each day’s workouts desc
            // sort the days' tiem desc
private var workoutsByDay: [(day: Date, items: [Workout])]
{
        let grouped = Dictionary(grouping: workoutVM.workouts) {
               
               calendar.startOfDay(for: $0.date)
           }
          
    return grouped
               .map { (day: $0.key,
                       items: $0.value.sorted { $0.date > $1.date }) }
               .sorted { $0.day > $1.day }
       }
    
    //key for vm to work here
    //make sure to keep updates
    
    init(workoutVM: WorkoutVM = WorkoutVM()) {
            self.workoutVM = workoutVM
      }

    
    var body: some View {
        NavigationView {
            ZStack {
                //Main Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)//expand
                
               
                //Big card telling user their daily burn
                VStack(spacing: 1)
                {
                    Text("Your Activity")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Today's Activity")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        HStack {
                            Text("\(calsBurnedToday) cals")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.green)
                            Spacer()
                            
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.top)
                    
                //workout cards displayed here!
                    List
                    {
                        ForEach(workoutsByDay, id: \.day) { group in
                               
                             Section(
                                header:
                                
                                    //adding in a small date break line here inclding the date--sort by date function
                               
                                //
                                Text(Self.dayFormatter.string(from: group.day))
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                                    .padding(.vertical, 4)
                                    .listRowBackground(Color.clear)
                            ) {
                               
                                
                                ForEach(group.items) { workout in
                                  
                                    WorkoutCard(workout: workout)
                                        .listRowBackground(Color.clear)
                                    //delete button upon swipe right to keep thing clean
                                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                          
                                            Button(role: .destructive) {
                                                //delete the workout upon button clicking
                                                workoutVM.deleteWorkout(workout)
//                                        .swipections(edge: .trailing, allowsFullSwipe: true) {
//                                            Button(role: .destructive) {
//
                                
                                            } label: {
                                                //delete funcionality
                                                //button label
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.clear)
                }
                .navigationBarHidden(true)
                //playing around with visibility of nav bar
                //..fix still
            }.onAppear {
                workoutVM.loadMyWorkouts()               // reload on view appear
                //workoutVM.loadWorkoutsForTestUser()
            }
        }
    }
    
    //Logic for each activity card
    struct WorkoutCard: View {
        let workout: Workout
        
        var body: some View {
            HStack {
                
                
                //add date and time????? on the card
                //_______>>> seperating cards by date now
                VStack(alignment: .leading, spacing: 5) {
                    
                    
                    Text(workout.type)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    //stats of wrkt
                    
                     Text("Duration: \(workout.duration) mins")
                        .font(.body).foregroundColor(.white.opacity(0.8))
                    
                    
                    
                      Text("Calories: \(workout.caloriesBurned)")
                        .font(.body).foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                //icon logic on card
                // !!!!!!!//ADD MORE ICONS --only the walker rn!!!!!!!!!!!!
                //            Image(systemName: "figure.walk")
                //                .foregroundColor(.white)
                //                .font(.system(size: 30))
                //                .padding()
                
                //account for differnet activity types via differnt icons and key words
                
                //WORK ON TEXT COLOR DIFFERENTATION --cals--see figma
                if(workout.type.starts(with: "Lift") || workout.type.starts(with: "Weight"))
                {
                    Image(systemName: "dumbbell.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                        .padding()
                }
              
                if(workout.type.starts(with: "Run") || workout.type.starts(with: "Sprint") || workout.type.starts(with: "Jog") ||  workout.type.starts(with: "Walk") || workout.type.starts(with: "Running"))
                {
                    Image(systemName: "figure.walk")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                        .padding()
                }
            
                if(workout.type.starts(with: "Sleep"))
                {
                    Image(systemName: "bed.double.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                        .padding()
                }
                if(workout.type.starts(with: "Cycling") || workout.type.starts(with: "Biking") || workout.type.starts(with: "Bike")){
                    Image(systemName: "figure.outdoor.cycle")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                        .padding()
                }
                if(workout.type.starts(with: "Swim") ||  workout.type.starts(with: "Swimming"))
                {
                    Image(systemName: "figure.open.water.swim")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                        .padding()
                }
                
                //Image(systemName: "figure.jumprope")
                if(workout.type.starts(with: "Jump") ||  workout.type.starts(with: "Jumping"))
                {
                    Image(systemName: "figure.jumprope")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                        .padding()
                }
            }
            .padding()
            .background(Color.white.opacity(0.15))
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
            }
        }
    
}


//
//#Preview {
//    HomeView(WorkoutVM)
//}
