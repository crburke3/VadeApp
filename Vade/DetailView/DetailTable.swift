//
//  DetailTable.swift
//  Vade
//
//  Created by Christian Burke on 2/12/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import UIKit

extension DetailViewController :UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DetailTableViewCell
        cell.spot = spots[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spots.count
    }
    
    
    
}
