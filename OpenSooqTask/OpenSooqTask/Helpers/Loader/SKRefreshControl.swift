
//  OpenSooqTask
//
//  Created by Qais Alnammari on 7/6/19.
//  Copyright © 2019 Qais Alnammari. All rights reserved.
//

import UIKit

class SKRefreshControl: UIRefreshControl {
    
    
    
    //MARK: - Properties
    var spinnerColors: [UIColor]{
        return [
            UIColor(red: 0.63, green: 0.15, blue: 0.46, alpha:1),
            UIColor(red: 0.44, green: 0.15, blue: 0.46, alpha:1),
            UIColor(red: 0.41, green: 0.15, blue: 0.46, alpha:1),
            UIColor(red: 0.44, green: 0.15, blue: 0.46, alpha:1),
            UIColor(red: 0.63, green: 0.15, blue: 0.46, alpha:1),
            UIColor(red: 0.84, green: 0.25, blue: 0.42, alpha:1),
            UIColor(red: 0.87, green: 0.35, blue: 0.36, alpha:1),
            UIColor(red: 0.84, green: 0.22, blue: 0.44, alpha:1)
        ]
    }
    
    private var spinnerView: SKActivityIndicator?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    override init() {
        super.init()
        configureView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let spinner = self.spinnerView else {
            return
        }
        spinner.center.x = self.center.x
    }
    
    //MARK: - Helper Methods
    
    private func configureView(){
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        self.spinnerView = SKActivityIndicator(frame: CGRect(x: 0, y: 10, width: 40, height: 40))
//        spinnerView?.frame = CGRect(x: 0, y: 10 , width: 40, height: 40)
        self.tintColor = .clear
        self.spinnerView!.center.x = self.center.x
        
        spinnerView!.colors = self.spinnerColors
        spinnerView!.style = .spinningFadeCircle
        
        self.addSubview(spinnerView!)
        self.sendSubviewToBack(spinnerView!)
        
    }
}
