//
// DetailsView.swift
//  FitnessApp1
//
//  Created by Chris Pekin on 4/19/25.
//
import SwiftUI
import Firebase
import Foundation
import FirebaseAuth


struct OnboardingView: View {
    //link to aythenticator
    @EnvironmentObject var authVM: AuthenticationView
  //details users will be prompted to enter
    //will be sent to vm and then stored in the firebase database
    
    @State private var displayName = ""
    @State private var height = ""
  @State private var weight = ""
  @State private var age    = ""
  @State private var style  = ""
  @State private var error  = ""

  var body: some View
     {
    VStack(spacing: 24)
    {
        
      Text("Personal Details")
        .font(.largeTitle).bold().foregroundColor(.white)
//      Group {
//        TextField("Display Name)",        text: $displayName).keyboardType(.numberPad)
//        TextField("Height (cm)",        text: $height).keyboardType(.numberPad)
//        TextField("Weight (kg)",        text: $weight).keyboardType(.numberPad)
//        TextField("Age",                text: $age   ).keyboardType(.numberPad)
//        TextField("Activity Style",     text: $style )
//      }
        //modified grouping of details input fields
        Group{
            
            TextField("", text: $displayName)
              .placeholder(when: displayName.isEmpty) {
                Text("Display Name")
                  .foregroundColor(Color.white.opacity(0.4)) // ghost text
              }
              .foregroundColor(.white)
              .padding()
              .background(Color.white.opacity(0.1))
              .cornerRadius(12)
            
            TextField("", text: $height)
              .placeholder(when: height.isEmpty) {
                Text("Height")
                  .foregroundColor(Color.white.opacity(0.4)) // ghost text
              }
              .foregroundColor(.white)
              .padding()
              .background(Color.white.opacity(0.1))
              .cornerRadius(12)
            
            TextField("", text: $weight)
              .placeholder(when: weight.isEmpty) {
                Text("Weight")
                  .foregroundColor(Color.white.opacity(0.4)) // ghost text
              }
              .foregroundColor(.white)
              .padding()
              .background(Color.white.opacity(0.1))
              .cornerRadius(12)
            
            TextField("", text: $age)
              .placeholder(when: age.isEmpty) {
                Text("Age")
                  .foregroundColor(Color.white.opacity(0.4)) // ghost text
              }
              .foregroundColor(.white)
              .padding()
              .background(Color.white.opacity(0.1))
              .cornerRadius(12)
            
            TextField("", text: $style)
              .placeholder(when: style.isEmpty) {
                Text("Your Activity Style")
                  .foregroundColor(Color.white.opacity(0.4)) // ghost text
              }
              .foregroundColor(.white)
              .padding()
              .background(Color.white.opacity(0.1))
              .cornerRadius(12)
            //each one follows same style--which is also consistent across apps ui
        }
     
      .padding(.horizontal)

      if !error.isEmpty
        {
        Text(error).foregroundColor(.red)
      }

    
        Button("Continue")
        {
          let d = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        // validate & convert
          guard let h = Int(height),
              let w = Int(weight),
               let a = Int(age),
              !style.isEmpty else {
          error = "Please fill in all fields correctly"
          return
        }
        authVM.savePersonalDetails(
             displayName: d, height: h, weight: w, age: a, style: style
        ) {  success in
           if !success {
            error = "Save failed—try again"
          }
        }
      }
      .buttonStyle(.borderedProminent)
       .cornerRadius(12)
         .disabled(displayName.isEmpty || height.isEmpty || weight.isEmpty || age.isEmpty || style.isEmpty)//dont allow the users to continue IF ANY field are EMPTY --safegaurd

      Spacer()
    }
         //styling--//spacing issues--mess w padding
    .padding(.top, 60)
    .background(
      LinearGradient(
         gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.8)]),
        startPoint: .top, endPoint: .bottom
      ).edgesIgnoringSafeArea(.all)
    )
  }
}


//
//#Preview {
//    OnboardingView(authVM: AuthenticationView, displayName: "Joe", height: 200, weight: 200, age: 23, style: "active", error: "none")
//}


//new


//struct OnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingView()
//            .environmentObject(AuthenticationView())
//            
//    }
//}
