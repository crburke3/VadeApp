//
//  DetailMapControl.swift
//  Vade
//
//  Created by Christian Burke on 3/3/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension DetailViewController: MKMapViewDelegate{
    
    func centerMapOnLocation(location: CLLocation, _radius: CLLocationDistance = 500) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: _radius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "myAnnotation") as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myAnnotation")
        } else {
            annotationView?.annotation = annotation
        }
        
        if let annotation = annotation as? MyPointAnnotation {
            annotationView?.pinTintColor = annotation.pinTintColor
            annotationView?.isDraggable = true
            annotationView?.canShowCallout = true
            annotationView?.animatesDrop = true
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let lat = view.annotation!.coordinate.latitude
        let long = view.annotation!.coordinate.longitude
        var occ = false
        let currLotName = lot.name
        let currSpotName = view.annotation!.subtitle!!
        let this = view.tintColor
        if view.tintColor == UIColor.red{
            occ = true
        }
        
        var spotIndex:Int? = nil
        var spotIterator = 0
        for spot in movedSpots{
            if spot.id == currSpotName{
                spotIndex = spotIterator
            }
            spotIterator += 1
        }
        
        if spotIndex != nil{
            movedSpots[spotIndex!].lattitude = lat
            movedSpots[spotIndex!].longitude = long
        }else{
            movedSpots.append(ParkingSpot(_id: currSpotName, _occupied: occ, _lat: lat, _long: long))
        }
    }

    
}
