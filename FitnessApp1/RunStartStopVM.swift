////  Created by Chris Pekin on 4/10/25.
import Foundation
import CoreLocation
import SwiftUI


//class assist users in start and stop run tracking functionality
//basic run tracker to satisfy map requirements
final class StartStopRouteTracker: NSObject, ObservableObject, CLLocationManagerDelegate
{
    //ccoordinates var --corelocation
  @Published var cd: [CLLocationCoordinate2D] = []
 
    private let locMgr = CLLocationManager()

    
  override init()
{
    
      super.init()
    
    locMgr.delegate = self
    locMgr.activityType = .fitness
    locMgr.desiredAccuracy = kCLLocationAccuracyBest
    locMgr.requestWhenInUseAuthorization()
    
    
  }
//user will hit start button to initiate tracking here --and updating their route
  func startRun()
    {
     cd.removeAll()
    locMgr.startUpdatingLocation()
  }
//end route track
func stopRun()
{
    locMgr.stopUpdatingLocation()
  }
//this fxn needs work to make sure loc propely updates and then saves, knows when to overwrite
    //FIX !!!!!!!
    
func locationManager(_ mgr: CLLocationManager, didUpdateLocations locs: [CLLocation]) {
      
     //  guard let l = locs.last
       //refine what is being returned
       //fine for now
       //FIXXXXX!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
       guard let last = locs.last else { return }
    DispatchQueue.main.async {
       self.cd.append(last.coordinate)
    }
  }
}
