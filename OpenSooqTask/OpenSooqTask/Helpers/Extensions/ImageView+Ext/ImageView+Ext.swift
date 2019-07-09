//
//  ImageView+Ext.swift
//  OpenSooqTask
//
//  Created by Qais Alnammari on 7/8/19.
//  Copyright © 2019 Qais Alnammari. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
extension UIImageView {
    //This way is used to isolate kingfisher in this method,incase of changing this third party
    func setImage(imageName: String){
        let url = URL(string: imageName)
        let placeHolder = UIImage(named: "placeHolder")
        self.kf.indicatorType = .activity
        
        self.kf.setImage(with: url, placeholder: placeHolder) { [weak self](result) in
            guard let self = self else{
                return
            }
            
            switch result{
            case .success(let imageObj):
                self.image = imageObj.image
            case .failure(_):
                self.image = placeHolder
            }
            
        }
    }
}
