import Foundation
import Combine
import Foundation

//api handler for excercises to be shown to user form exercisedb

class ExerciseAPI {
    static let shared = ExerciseAPI()
    //link to exerceise api to bring a list of exercises based on the target muscle
    private let baseURL = "https://exercisedb.p.rapidapi.com/exercises/target/"

    func getApiExercises(for target: String, completion: @escaping ([Exercise]?) -> Void) {
        let urlString = baseURL + target
       
        guard let url = URL(string: urlString)
        else
        {
       
            print("Invalid URL")
            completion(nil)
           
            return
        }
//info provided from details on the API documentation--a lot of this is provided
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("36c5418453msh763c1ea1e626dc4p1c2828jsn94973a2d20c2", forHTTPHeaderField: "x-rapidapi-key")//my api key
        request.setValue("exercisedb.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
//debugging and error handling below
       
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("API Request Error: \(error.localizedDescription)")
                completion(nil)
                
                return
            }
//error handling and debug
            //work through no data message--->finished
            
            guard let data = data
            else
            {
                print("No data coming in")
               
                completion(nil)
               
                
                return
            }

            do
             {
                let decodedExercises = try JSONDecoder().decode([Exercise].self, from: data)
               
                 DispatchQueue.main.async {
                    completion(decodedExercises)
                }
            }
            
            catch
            
            {
                print("Decoding Error: \(error)")
                completion(nil)
            }
        }.resume()
    }
}

//
//struct Exercise: Identifiable, Codable
//{
//        var id: String
//        var name: String
//        var type: String
//        var muscles: String
//        var equipment: String
//    }
//

//create a Codable struct similr to JSON exercise in class
//necessary variables listed in documentation
struct Exercise: Identifiable, Codable
{
    let id: String
    let name: String
    let bodyPart: String
    let equipment: String
    let gifUrl: String
    let target: String
    let secondaryMuscles: [String]
    let instructions: [String]
}
