//
//  LotTableViewCell.swift
//  Vade
//
//  Created by Christian Burke on 1/31/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import UIKit

class LotTableViewCell: UITableViewCell {

    @IBOutlet var LotLabel: UILabel!
    @IBOutlet var OpenSpacesLabel: UILabel!
    @IBOutlet var imageViewer: UIImageView!
    
    
    var parkingLot = ParkingLot()
    override func layoutSubviews() {
        LotLabel.text = parkingLot.name
        var openCount = 0
        for spot in parkingLot.spots{
            if !spot.occupied{
                openCount += 1
            }
        }
        OpenSpacesLabel.text = String(openCount) + " Open Parking Spaces"
    }

}
