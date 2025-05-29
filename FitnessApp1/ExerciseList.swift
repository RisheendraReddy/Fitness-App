import SwiftUI
//pulls from the api and tells app how to display the info
struct ExerciseListView: View {
  
    @StateObject var exerciseVM = ExerciseVM()
    //@State private var selectedTarget = "pectorals" //the app prior default selection
    @State private var selectedTarget =  "Select Target Muscle"//the new default selection

    
    //array here is our list of all target muslces with their proper api names for the dropdown
   //incldue new "selected target' to show first in dropdown
    
    let targetMuscles = [
        "Select Target Muscle","abductors", "abs", "adductors", "biceps", "calves", "cardiovascular system",
        "delts", "forearms", "glutes", "hamstrings", "lats", "levator scapulae",
        "pectorals", "quads", "serratus anterior", "spine", "traps", "triceps", "upper back"
    ]

    var body: some View {
        NavigationView {
           
            
            ZStack {
    
               //consistent ui gradient
                LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.8)]),
                               startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
               

                VStack {
                    
                    
                    //logic for dropdown
                    //use it to select target muscle
                    Menu {
                        //create a card for each muscle
                        //show that card's workouts
                        
                        ForEach(targetMuscles, id: \.self){ muscle in
                            
                            Button(action:{
                                selectedTarget = muscle
                                exerciseVM.loadExercises(for: muscle)
                            }) {
                                Text(muscle.capitalized)
                            }
                        }
                    } label: {
                        HStack {
                            
                            //update the selected muscle
                        Text("Target: \(selectedTarget.capitalized)")
                            .font(.headline)
                                .foregroundColor(.white)
                           
                            
                            
                            Spacer()
                          
                            
                            //arorow dropdown
                            Image(systemName: "chevron.down")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.7))
                        .cornerRadius(14)
                    }
                    .padding(.horizontal)

                  //once muscle is picked use the API to bring a list of exercises targeting it
                    //scrolling view of all cards of exercise
                    //card UI below
                    ScrollView {
                        VStack(spacing: 15) {
                            //How each exercise will be displayed as a card--similar to national parks using MVVM
                            ForEach(exerciseVM.exercises) { exercise in
                                ExerciseCard(exercise: exercise)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 10) //Fixes weird top spacing issue w gradient bg
            }
            //.navigationTitle("Exercises")
            .toolbar {
                
                //Page title
               
                ToolbarItem(placement: .principal) {
                    
                    Text("Exercises")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                }
            }

            .foregroundColor(.white)
        }
    }
}

//each indidual wrkt card UI
struct ExerciseCard: View {
   
    let exercise: Exercise

    var body: some View {
        
        HStack(spacing: 15) {
            //the images update daily via the API
            //left justified workout img on card
            AsyncImage(url: URL(string: exercise.gifUrl)) { image in
                image.resizable()
                     .scaledToFit()
                     .frame(width: 120, height: 120)//card shape
                     .cornerRadius(10)
            }
            placeholder: {
                ProgressView()
                    .frame(width: 120, height: 120)
            }

            VStack(alignment: .leading, spacing: 5) {
               
                Text(exercise.name.capitalized)
                    .font(.headline)
                    .foregroundColor(.white)
//
                
//            
//                Text("Target: \(exercise.target.capitalized)")
//                    .font(.subheadline)
//                    .foregroundColor(.black)

             
                Text("Equipment: \(exercise.equipment.capitalized)")
                    .font(.subheadline)
                    .foregroundColor(.black)
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity) //formatting-shaping
        .background(
           
            
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.9), Color.cyan.opacity(0.8)]),
                startPoint: .leading,
                endPoint: .trailing
            )//card gradient
        )
        .cornerRadius(15)//card shape
        .shadow(radius: 5)
    }
}
//preview
struct ExerciseListView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseListView()
    }
}

//OlD
//debugging
//works with static data
/*struct ExerciseListView: View {
 let sampleExercises = [
     Exercise(id: "1", name: "Push-up", type: "Strength", muscles: "Chest", equipment: "Bodyweight"),
     Exercise(id: "2", name: "Squat", type: "Strength", muscles: "Legs", equipment: "None")
 ]

 var body: some View {
     List(sampleExercises) { exercise in
         Text(exercise.name)
     }
 }
}*/
//
//struct ExerciseCard: View {
//    let exercise: Exercise
//
//    var body: some View {
//        VStack {
//            Text(exercise.name)
//                .font(.title2)
//                .foregroundColor(.white)
//                .bold()
//
//            Text("Type: \(exercise.type)")
//                .foregroundColor(.white)
//
//            Text("Muscles: \(exercise.muscles)")
//                .foregroundColor(.white)
//
//            Text("Equipment: \(exercise.equipment)")
//                .foregroundColor(.white)
//        }
//        .padding()
//        .background(Color.white.opacity(0.15))
//        .cornerRadius(10)
//        .shadow(radius: 5)
//    }
//}
//
//struct ExerciseListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExerciseListView()
//    }
//}
