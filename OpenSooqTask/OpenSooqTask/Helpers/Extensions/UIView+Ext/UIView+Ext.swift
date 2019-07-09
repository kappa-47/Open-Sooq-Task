//
//  UIView+Ext.swift
//  OpenSooqTask
//
//  Created by Qais Alnammari on 7/9/19.
//  Copyright © 2019 Qais Alnammari. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    
    func handelOfflineView(isConnected:Bool) {
        if !isConnected {
            let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            imgView.image = UIImage(named: "nointernet")
            imgView.contentMode = .scaleAspectFit
            self.addSubview(imgView)
            
        }
    }
}
