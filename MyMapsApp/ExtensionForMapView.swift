//
//  ExtensionForMapView.swift
//  MyMapsApp
//
//  Created by Дмитрий Рузайкин on 20.09.2021.
//

import Foundation
import MapKit
import CoreLocation

extension ViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .red
        return renderer
    }
}
