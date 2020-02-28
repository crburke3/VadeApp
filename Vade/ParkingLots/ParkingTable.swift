//
//  ParkingTable.swift
//  Vade
//
//  Created by Christian Burke on 1/31/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import UIKit

extension ParkingLotViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parkingLotData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = parkingTable.dequeueReusableCell(withIdentifier: "parkingCell") as! LotTableViewCell
        cell.parkingLot = parkingLotData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 93
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "spot") as? DetailViewController {
            viewController.lot = parkingLotData[indexPath.row]
            self.navigationController!.pushViewController(viewController, animated: false)
        }
    }
}
