//
//  VadeFirebase.swift
//  Vade
//
//  Created by Christian Burke on 2/13/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import Firebase
import FirebaseFirestore
import MapKit

extension ParkingLotViewController{
    func loadParkingLots(count:Int, retCities: @escaping ([ParkingCity])->()){
        parkingLotData = []
        self.parkingTable.reloadData()
        let db = Firestore.firestore()
        let statesref = db.collection("United")
        var cities:[ParkingCity] = []
        statesref.getDocuments { (snapshot, err) in
            //print(err?.localizedDescription)
            for doc in snapshot!.documents{
                let lotData = doc.data()["lots"] as! [String]
                if let timestamp = doc.data()["timestamp"] as? String{
                    DispatchQueue.main.async {
                        self.updateLabel.text = "updated: " + timestamp
                    }
                }
                var retLots:[ParkingLot] = []
                for lotName in lotData{
                    retLots.append(ParkingLot(_city: doc.documentID, _name: lotName, _spots: []))
                }
                let city = ParkingCity(_name: doc.documentID, _lots: retLots)
                cities.append(city)
                print(city)
                for city in cities{
                    for lot in city.lots{
                        let lotRef = db.document("United/" + city.name + "/" + lot.name + "/Lot")
                        lotRef.getDocument(completion: { (snapshot, error) in
                            if let data = snapshot?.data(){
                                let spotNames = data["spots"] as! [String]
                                for spotName in spotNames{
                                    let spotRef = lotRef.collection(spotName).document("spot")
                                    spotRef.getDocument(completion: { (snapshot, error) in
                                        let data = snapshot!.data() as! [String:Any]
                                        var occStr = data["Occupied"] as! String
                                        let occ = occStr.toBool()!
                                        var lat = data["Latitude"] as? Double
                                        var long = data["Longitude"] as? Double
                                        if lat == nil{
                                            lat = 40.045019
                                        }
                                        if long == nil{
                                            long = -75.386443
                                        }
                                        let retSpot = ParkingSpot(_id: spotName, _occupied: occ, _lat: lat!, _long: long!)
                                        lot.spots.append(retSpot)
                                        if cities.count == 1 && cities.last!.lots.last!.spots.count == spotNames.count - 1{
                                            retCities(cities)
                                        }
                                    })
                                }
                            }
                        })
                    }
                }
            }
        }
    }
}

class Fire{
    let db = Firestore.firestore()
    
    func
        saveSpotLocation(_city:String, _lotID:String, _spotID:String, _location:CLLocationCoordinate2D){
        let refString = ("/United/" + _city + "/" + _lotID + "/Lot/" + _spotID + "/spot")
        let ref = db.document(refString)
        ref.getDocument { (snapshot, err) in
            if let error = err{
                print("Fucked up:" + error.localizedDescription)
            }else{
                var data = snapshot!.data()!
                    //if var spot = lot[_spotID] as? [String:Any?]{
                data["Latitude"] = _location.latitude
                data["Longitude"] = _location.longitude
                //ref.updateData([_lotID:lot])
                ref.setData(data, merge: true)
                //}
            }
        }
    }
}
