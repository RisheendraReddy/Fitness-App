//
//  Application.swift
//  FitnessApp1
//
//  Created by Chris Pekin on 4/17/25.
import SwiftUI
import UIKit

//helps with sign in --snippet from google documentation


final class applicationControl
{
    static var rootViewController: UIViewController
    {
        
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene
        
        
        else
        {
            return .init()
            
        }
        
        guard let root = screen.windows.first?.rootViewController
        else
        {
            return .init()
        }
        
        return root
    }
    
    
}
