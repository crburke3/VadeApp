//
//  DetailTableViewCell.swift
//  Vade
//
//  Created by Christian Burke on 2/12/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet var spotColor: UIView!
    @IBOutlet var spotLbl: UILabel!
    
    var spot = ParkingSpot()
    var loaded = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        if !loaded{
            if !spot.occupied{
                spotLbl.text = spot.id + ": Open"
                spotColor.backgroundColor = UIColor.green
            }else{
                spotLbl.text = spot.id + ": Occupied"
                spotColor.backgroundColor = UIColor.red
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
