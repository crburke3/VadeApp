//
//  TotalSpotViewer.swift
//  Vade
//
//  Created by Christian Burke on 5/14/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import UIKit
import MapKit

class TotalSpotViewer: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    
    let vade = VadeAPI()
    let locator = BurkesLocator()
    var pins:[MKPointAnnotation] = []
    var movedSpots:[ParkingSpot] = []


    override func viewDidLoad() {
        mapView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        vade.getParkingSpots(from_country: "usa") { (cameras) in
            for camera in cameras{
                for spot in camera.spots{
                    self.pins.append(spot.toPin())
                }
            }
            self.mapView.showAnnotations(self.pins, animated: true)
        }
        
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
        let currSpotName = view.annotation!.title!!
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
            movedSpots.append(ParkingSpot(_id: view.annotation!.subtitle!!, _occupied: occ, _lat: lat, _long: long))
        }
    }

    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        for spot in movedSpots{
            let spotLoc = CLLocationCoordinate2D(latitude: spot.lattitude, longitude: spot.longitude)
            vade.updateSpotGPS(_spotID: spot.id, _coordinate: spotLoc) { (succ, ret) in
                if !succ{
                    print("\(spot.id): FAILED: \(ret)")
                }else{
                    print("\(spot.id): good update")
                }
            }
        }
        movedSpots = []
    }
}
