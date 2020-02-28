//
//  DetailViewController.swift
//  Vade
//
//  Created by Christian Burke on 2/12/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class DetailViewController: UIViewController {
    
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var mapView: MKMapView!
    
    var lot = ParkingLot()
    var spots:[ParkingSpot] = []
    var pins:[MKPointAnnotation] = []
    let regionRadius: CLLocationDistance = 50
    var initialLocation = CLLocation(latitude: Double(35.779827), longitude: Double(-78.644196))
    var movedSpots:[ParkingSpot] = []
    let api = VadeAPI()
    //let blackListCameras = ["parksight-7", "parksight-19", "parksi]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api.getParkingSpots(from_country: "usa") { (cameras) in
            for camera in cameras{
//                if camera.name == "parksight-7"{
//                    continue
//                }
                for cameraSpot in camera.spots{
                    self.spots.append(cameraSpot)
                }
            }
            DispatchQueue.main.async {
                //let initialLocation = CLLocation(latitude: 40.045126, longitude: -75.386602)
                self.centerMapOnLocation(location: self.initialLocation, _radius: 300)
                self.setDelegates()
                self.showPins()
            }
        }
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        let fire = Fire()
        for spot in movedSpots{
            //fire.saveSpotLocation(_city: lot.city, _lotID: lot.name, _spotID:spot.id , _location: CLLocationCoordinate2D(latitude: spot.lattitude, longitude: spot.longitude))
            let coord = CLLocationCoordinate2D(latitude: spot.lattitude, longitude: spot.longitude)
            api.updateSpotGPS(_spotID: spot.id, _coordinate: coord) { (succ, err) in
                if err != nil{
                    print(err)
                }
            }
        }
    }
    
    func showPins(){
        mapView.showAnnotations(pins, animated: true)
    }
    
    func setDelegates(){
        mapView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        for spot in spots{
            pins.append(spot.toPin())
        }
        tableView.reloadData()

    }
}

