//
//  Header.swift
//  Vade
//
//  Created by Christian Burke on 1/31/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import UIKit
import MapKit

class ParkingCity{
    var name:String
    var lots:[ParkingLot]
    init(_name:String, _lots:[ParkingLot] = []) {
        self.name = _name
        self.lots = _lots
    }
}

class ParkingLot{
    var city:String
    var name:String
    var spots:[ParkingSpot]
    init(_city:String = "Empty", _name:String = "Empty", _spots:[ParkingSpot] = []) {
        self.name = _name
        self.spots = _spots
        self.city = _city
    }
}

class ParkingSpot{
    var parentCamera:String?
    var arrayIndex:Int?
    var id:String
    var lattitude:Double
    var longitude:Double
    var occupied:Bool
    init(_id:String = "000000", _occupied:Bool = false, _lat:Double = 40.044972, _long:Double = -75.386683) {
        self.id = _id
        self.occupied = _occupied
        self.lattitude = _lat
        self.longitude = _long
    }
    
    init(data:[String: Any], _parentCamera:String?){
        self.arrayIndex = data["name"] as? Int
        self.id = data["id"] as! String
        self.occupied = data["occupied"] as! Bool
        self.lattitude = data["latitude"] as? Double ?? 35.779827
        self.longitude = data["longitude"] as? Double ?? -78.644196
        self.parentCamera = _parentCamera
        
    }
    
    func toPin()->MyPointAnnotation{
        let pin = MyPointAnnotation()
        pin.coordinate = CLLocationCoordinate2DMake(self.lattitude, self.longitude)
        pin.title = self.id
        pin.subtitle = self.id
        if (self.parentCamera != nil) && (self.arrayIndex != nil){
            pin.title = "\(self.parentCamera!): \(self.arrayIndex!)"
        }
        if(self.occupied){
            pin.pinTintColor = UIColor.red
        }else{
            pin.pinTintColor = UIColor.green
        }
        return pin
    }
}

class MyPointAnnotation : MKPointAnnotation {
    var pinTintColor: UIColor?
    var parkingSpot: ParkingSpot?
}

class ParkingCamera{
    var name:String
    var spots:[ParkingSpot]
    var coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.04506, longitude: -75.3865)
    
    init(_name:String, _spots:[ParkingSpot]){
        self.name = _name
        self.spots = _spots
    }
    
    init(_data:[String:Any]){
        self.name = _data["parent_camera"] as! String
        self.spots = []
        let loadedLat = _data["latitude"] as? Double ?? 40.04506
        let loadedLong = _data["longitude"] as? Double ?? -75.3865
        self.coordinate = CLLocationCoordinate2D(latitude: loadedLat, longitude: loadedLong)
    }
}

