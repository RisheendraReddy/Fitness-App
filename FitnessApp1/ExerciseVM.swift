//
//  ExerciseVM.swift
//  FitnessApp1
//
//  Created by Chris Pekin on 3/24/25.
//
import Foundation
//standard VM for exercise
class ExerciseVM: ObservableObject {
    @Published var exercises: [Exercise] = []
//VM gets the exercises from the API to display in the list 
    
 func loadExercises(for target: String)
    {
        
        //apu exercise getter vm for m 'exercise' goes into exercise list
         ExerciseAPI.shared.getApiExercises(for: target) { [weak self] exercises in
             if let exercises = exercises {
                 self?.exercises = exercises
                 
                 print("Fetched \(exercises.count) exercises.")
            }
        }
    }
}


