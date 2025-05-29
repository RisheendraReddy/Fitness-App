import SwiftUI


//currntly the "workout' logger will be changed to activity logger and have a more specific workout logger with reps and sets for lifts


//4/20----can still do this aboive idea but decided against it was happy with curret app for time being
//!!!!!!!!!!!!!//incorporate buttons for data imports via API like Strava!!!!!!!!!!

struct WorkoutLoggingView: View {
    //from  model and Vm
    //old
   // @ObservedObject var workoutVM = WorkoutVM()
    //new
    @ObservedObject var workoutVM:WorkoutVM
    @State private var workoutType: String = ""
  
    @State private var duration: String = ""
   
    @State private var caloriesBurned: String = ""

    var body: some View {
        ZStack {
            // BG gradient
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.8)]),
                           startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
           
             VStack {
                Text("Log Workout")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                    //Prompt user to enter the type of Workout or Activity
                ActivityField(icon: "dumbbell.fill", placeholder: "Enter workout type", text: $workoutType)
                    .foregroundColor(.white)

               
                
    
                //Duration
                ActivityField(icon: "clock.fill", placeholder: "Enter duration in minutes", text: $duration, keyboardType: .numberPad)

               
                
                     //Enter Calories burned
                 ActivityField(icon: "flame.fill", placeholder: "Enter calories burned", text: $caloriesBurned, keyboardType: .numberPad)
                
                //Saving Button below
                //commit info to VM and firesore database !!!!
                Button(action: {
                    if let durationInt = Int(duration), let caloriesInt = Int(caloriesBurned) {
                        workoutVM.logWorkout(type: workoutType, duration: durationInt, caloriesBurned: caloriesInt)
                        workoutType = ""
                        duration = ""
                        caloriesBurned = ""
                    }
                }) {
                    //Change gradient?????????????????????????????????????????
                    Text("Save Workout")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                    
                    //Change gradient?????????????????????????????????????????
                       
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                                                   startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(12)
                        .shadow(color: Color.blue.opacity(0.6), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 40)
               
                .padding(.top, 10)

                Spacer()
            }
            .padding()
        }
    }
}


struct ActivityField: View {
    
    
    var icon: String
    var placeholder: String
   
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View
    {
        HStack {
           
            Image(systemName: icon)
                .foregroundColor(.white)
                    .padding(.leading, 10)
            
           
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                    .foregroundColor(.white) // user entered text is white
                .placeholder(when: text.isEmpty) {
                    Text(placeholder)
                            .foregroundColor(.white.opacity(0.6))
                }
                    .padding()
        }
        .frame(height: 50) //sizing
        .background(Color.white.opacity(0.2)) //Box bg and shaping
        .cornerRadius(12)
        .padding(.horizontal, 40)
    }
}

//Placeholder view modifier
//include snippet

extension View {
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        
        ZStack(alignment: alignment) {
            if shouldShow { placeholder() }
            self
        }
    }
}//---------->still need?????


//
//#Preview {
//    WorkoutLoggingView()
//}

//new prev/

//struct WorkoutLoggingView_Previews: PreviewProvider {
//  static var previews: some View {
//    WorkoutLoggingView(workoutVM: WorkoutVM())
//  }
//}
