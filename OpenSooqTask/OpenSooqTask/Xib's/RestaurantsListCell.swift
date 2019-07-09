//
//  RestaurantsListCell.swift
//  OpenSooqTask
//
//  Created by Qais Alnammari on 7/7/19.
//  Copyright © 2019 Qais Alnammari. All rights reserved.
//

import UIKit

class RestaurantsListCell: UITableViewCell {

    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.layer.cornerRadius = 20
        mainView.clipsToBounds = true
    }
    
}
