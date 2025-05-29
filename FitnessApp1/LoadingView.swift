//
//  LoadingView.swift
//  FitnessApp1
//

//Created by Chris Pekin on 4/17/25.
// Risheendra Reddy Boddu on 4/17/25.
//APP ICON LOAD VIEW__buffer type screen
import SwiftUI

//GOAL: show user app icon while waiting--personal branding and identity

struct LoadingView<Content: View>: View
{
    @State private var isActive = false
    
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content)
    {
    
        
        self.content = content
    }

    var body: some View
    {
        Group
        {
        if isActive
            {
              
                content()
            }
            else
        {
                //logo loading page ui
                ZStack
                {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.8)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .edgesIgnoringSafeArea(.all)
//app logo
                    //scale to fit
                    
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .shadow(radius: 10)// some seperation
                }
            }
        }//prompt for when to appear--also see initial view logic
        .onAppear {
            //duration logic
           
            DispatchQueue.main.asyncAfter(deadline: .now() + 2)
            {
                withAnimation {
                   
                    isActive = true
                }
            }
        }
    }
}

//struct Loadiew_Previews: PreviewProvider {
//    static var previews: some View {
//        // Preview showing the splash for immediate state
//        LoadingView {
//            Text("Main Content")
//                .font(.largeTitle)
//                .foregroundColor(.white)
//                .background(Color.black)
//        }
//        .previewDisplayName("Load View Preview")
//    }
//}
