
//  OpenSooqTask
//
//  Created by Qais Alnammari on 7/6/19.
//  Copyright © 2019 Qais Alnammari. All rights reserved.
//

import Foundation
import UIKit





// MARK: - Activity Indicator Type
@IBDesignable
class SKActivityIndicator: UIView{
    private var spinnerContainerView:UIView!
    
    var style: ActivityIndicatorStyle = .defaultSpinner{
        didSet{
            self.configure()
        }
    }
    
    var colors: [UIColor] = [.red]{
        didSet{
            self.configure()
        }
    }
    
    private func configure(){
        
        
        
        self.backgroundColor = .clear
        if spinnerContainerView != nil{
            spinnerContainerView.removeFromSuperview()
            spinnerContainerView = nil
        }
        
        spinnerContainerView = UIView(frame: self.bounds)
        spinnerContainerView.backgroundColor = .clear
        addSubview(spinnerContainerView)
        SKActivityIndicatorStyle.createSpinner(in: spinnerContainerView.layer, size: spinnerContainerView.layer.bounds.size, colors: colors, style: style)
    }
}



