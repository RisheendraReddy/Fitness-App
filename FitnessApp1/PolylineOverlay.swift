//
//  PolylineOverlay.swift
//  FitnessApp1
//
//  Created by Chris Pekin on 4/19/25.
//


import SwiftUI
import MapKit

struct PolylineOverlay: UIViewRepresentable {
    let coordinates: [CLLocationCoordinate2D]

    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.delegate = context.coordinator
        return map
    }

    func updateUIView(_ map: MKMapView, context: Context) {
        map.removeOverlays(map.overlays)
        guard !coordinates.isEmpty else { return }
        let poly = MKPolyline(coordinates: coordinates, count: coordinates.count)
        map.addOverlay(poly)
        map.setVisibleMapRect(
            poly.boundingMapRect,
            edgePadding: UIEdgeInsets(top:50, left:50, bottom:50, right:50),
            animated: true
        )
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay)
          -> MKOverlayRenderer
        {
            guard let line = overlay as? MKPolyline else {
                return MKOverlayRenderer(overlay: overlay)
            }
            let r = MKPolylineRenderer(polyline: line)
            r.strokeColor = .systemBlue
            r.lineWidth = 4
            return r
        }
    }
}
