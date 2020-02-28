//
//  ParkingLotViewController.swift
//  Vade
//
//  Created by Christian Burke on 1/31/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CRRefresh

class ParkingLotViewController: UIViewController {

    @IBOutlet var parkingTable: UITableView!
    var parkingLotData:[ParkingLot] = []
    var knownLots = ["College_Inn_Floor_2"]
    let rootRef = Database.database().reference()
    var time = ""
    @IBOutlet var updateLabel: UILabel!
    let vade = VadeAPI()
    let locator = BurkesLocator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parkingTable.cr.addHeadRefresh {
            self.loadParkingLots(count: 5) { (cities) in
                self.parkingLotData = cities[0].lots
                print(cities[0])
                self.reloadData()
                self.parkingTable.cr.endHeaderRefresh()
            }
        }
        parkingTable.delegate = self
        parkingTable.dataSource = self
    }

    
    
    func reloadData(){
        parkingTable.reloadData()
    }
}


