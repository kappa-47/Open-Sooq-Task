//
//  CustomWindowsView.swift
//  OpenSooqTask
//
//  Created by Qais Alnammari on 7/7/19.
//  Copyright © 2019 Qais Alnammari. All rights reserved.
//

import UIKit

class CustomWindowsView: UIView {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 20
      
    }
}
