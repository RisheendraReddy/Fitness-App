//yes
//
//import SwiftUI
//import MapKit
//import CoreLocation
//
//struct SimpleRunMapView: View {
//  @StateObject private var tracker = StartStopRouteTracker()
//  @State private var region = MKCoordinateRegion(
//    center: .init(latitude: 37.3349, longitude: -122.00902),
//    span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
//  )
//    
//
//      init(tracker: StartStopRouteTracker = StartStopRouteTracker()) {
//        _tracker = StateObject(wrappedValue: tracker)
//      }
//
//
//  var body: some View {
//      NavigationStack{
//    ZStack {
//        
//        LinearGradient(
//                       gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.8)]),
//                       startPoint: .top, endPoint: .bottom
//                   ).edgesIgnoringSafeArea(.all)
//        
//        Map(coordinateRegion: $region, showsUserLocation: true)
//       .overlay(Polyline(cd: tracker.cd))
//       .frame(maxWidth: 500, maxHeight: 500)
//       .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
//       .padding()
//       .shadow(radius: 5)
//       
//        
//      VStack {
//        Spacer()
//        HStack {
//          Button("Start") { tracker.startRun() }
//          Spacer()
//          Button("Stop")  { tracker.stopRun() }
//        }
//        .padding()
//        .background(Color.black.opacity(0.5))
//        .foregroundColor(.white)
//        .cornerRadius(8)
//        .padding()
//          
//         
//              NavigationLink {
//                RouteEditorView()
//              } label: {
//                Text("Add New Route")
//                  .bold()
//                  .foregroundColor(.white)
//                  .padding(.horizontal, 20)
//                  .padding(.vertical, 8)
//                  .background(Color.blue)
//                  .cornerRadius(8)
//              }
//          }
//          
//
//         
//      }
//        
//    }
//   
//  }
//}
//
//// Simple polyline overlay
//struct Polyline: UIViewRepresentable {
//    let cd: [CLLocationCoordinate2D]
//    
//    func makeUIView(context: Context) -> MKMapView {
//        let map = MKMapView()
//        map.delegate = context.coordinator
//        return map
//    }
//    
//    func updateUIView(_ map: MKMapView, context: Context) {
//        map.removeOverlays(map.overlays)
//        guard cd.count > 1 else { return }
//        
//        let line = MKPolyline(coordinates: cd, count: cd.count)
//        map.addOverlay(line)
//        map.setVisibleMapRect(
//            line.boundingMapRect,
//            edgePadding: UIEdgeInsets(top:50, left:50, bottom:50, right:50),
//            animated: true
//        )
//    }
//    
//    func makeCoordinator() -> Coordinator { Coordinator() }
//    
//    class Coordinator: NSObject, MKMapViewDelegate {
//        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay)
//        -> MKOverlayRenderer
//        {
//            guard let poly = overlay as? MKPolyline else {
//                return MKOverlayRenderer(overlay: overlay)
//            }
//            let r = MKPolylineRenderer(polyline: poly)
//            r.strokeColor = .systemBlue
//            r.lineWidth = 4
//            return r
//        }
//    }
//}
//
//struct SimpleRunMapView_Previews: PreviewProvider {
//  static var previews: some View {
//    // 1) Create & seed a fake tracker
//    let fakeTracker = StartStopRouteTracker()
//    fakeTracker.cd = [
//        // Old Main
//                    CLLocationCoordinate2D(latitude: 33.4238, longitude: -111.9372),
//                    // Along Rio Salado path
//                    CLLocationCoordinate2D(latitude: 33.4250, longitude: -111.9330),
//                    // North side of campus
//                    CLLocationCoordinate2D(latitude: 33.4270, longitude: -111.9290),
//                    // West return leg
//                    CLLocationCoordinate2D(latitude: 33.4290, longitude: -111.9310),
//                    // Back near Old Main
//                    CLLocationCoordinate2D(latitude: 33.4310, longitude: -111.9340)
//    ]
//
//    // 2) Return the view that uses it
//    return SimpleRunMapView(tracker: fakeTracker)
//      .previewInterfaceOrientation(.portrait)
//  }
//}
//
//  MapViewSelfRunTracking.swift
//  FitnessApp1
//
//  Created by Chris Pekin on 4/19/25.
//
import SwiftUI
import MapKit
import CoreLocation

//made better from one in file:RunStartStopVM

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate
{
    @Published var lastLocation: CLLocation?
    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        // keep only the most recent
        lastLocation = locations.last
    }
}

struct SimpleRunMapView: View {
 
    @StateObject private var tracker = StartStopRouteTracker()
    @StateObject private var locManager = LocationManager()
   
    
    //start points here
    @State private var region = MKCoordinateRegion(
        center: .init(latitude: 37.3349, longitude: -122.00902),
        span: .init(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )

    init(tracker: StartStopRouteTracker = StartStopRouteTracker()) {
        _tracker = StateObject(wrappedValue: tracker)
    }

    var body: some View
    {
        NavigationStack
        {
          
            
            ZStack
            {
                LinearGradient(
                    gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.8)]),
                    startPoint: .top, endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
//ADD IN SOME ZOOM CONTORLS
            VStack(spacing: 16)
                {
                   //
                   Text("Run Tracker")
                        .bold().font(.headline)
                        .foregroundColor(.white)
                    
//                    Text("Hit Start to being tracking")
//                       // .bold()
//                        .font(.subheadline)
//                         .foregroundColor(.white)
//                    
//                        Text("Hit Stop to complete a run")
//                            //bold()
//                            .font(.subheadline)
//                             .foregroundColor(.white)
                    
                    Map(
                        coordinateRegion: $region,
                        showsUserLocation: true
                    )
                    .overlay(
                        PolylineOverlay(coordinates: tracker.cd)//User entered line track --polylne-NEEDS SOME WORK STILL
                    )
                  //  .overlay(zoomControls, alignment: .topTrailing)
                            .frame(height: 350)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.horizontal)
                            .shadow(radius: 5)
                            .onReceive(locManager.$lastLocation) { loc in
                                guard let loc = loc else { return }
                                // center once on first fix
                                region.center = loc.coordinate
                    }

                   //THESE BUTTONS HELP A USER LOG THEIR RUN/ROUTES ---connect to the tracking vm
                    HStack
                    {
                        Button("Start")  {
                            tracker.startRun()
                        }
                       
                        Spacer()
                        
                        
                        Button("Stop")   {
                            tracker.stopRun()
                        }
                    }
                        .padding()
                         .background(Color.black.opacity(0.5))
                         .foregroundColor(.white)
                          .cornerRadius(8)
                          .padding(.horizontal)
                    Text("Hit Start to begin tracking a run.")
                       // .bold()
                        .font(.subheadline)
                         .foregroundColor(.white)
                    
                        Text("Hit Stop to complete a run.")
                            //bold()
                            .font(.subheadline)
                             .foregroundColor(.white)
                    Spacer()
                }
            }

            .navigationBarTitleDisplayMode(.inline)
        }
    }


}

struct SimpleRunMapView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleRunMapView()
            .previewInterfaceOrientation(.portrait)
    }
}
