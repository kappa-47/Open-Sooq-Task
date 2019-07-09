
//  OpenSooqTask
//
//  Created by Qais Alnammari on 7/6/19.
//  Copyright © 2019 Qais Alnammari. All rights reserved.
//

import UIKit

/**
 Custom animation view used for preloading lists.
 */
class SKPreloadingView: UIView{
    
    var spinnerColors: [UIColor]{
        return [
            
            
            UIColor(red: 0, green: 0, blue: 0, alpha:0.6),
            UIColor(red: 0, green: 0, blue: 0, alpha:0.6),
            UIColor(red: 0, green: 0, blue: 0, alpha:0.7),
            UIColor(red: 0, green: 0, blue: 0, alpha:0.8),
            UIColor(red: 0, green: 0, blue: 0, alpha:0.9),
            UIColor(red: 0, green: 0, blue: 0, alpha:0.9),
            UIColor(red: 0, green: 0, blue: 0, alpha:1),
            UIColor(red: 0, green: 0, blue: 0, alpha:1),
        ]
    }
    
    private let spinnerView = SKActivityIndicator(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    override var frame: CGRect{
        didSet{
            spinnerView.center = self.center
        }
    }
    open class var shared: SKPreloadingView {
        struct Singleton {
            static let instance = SKPreloadingView(frame: UIApplication.shared.windows.first!.bounds)
        }
        return Singleton.instance
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure(){

        let backView = UIView(frame: self.bounds)
        backView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backView.backgroundColor = .clear
        self.addSubview(backView)

        self.layer.shadowColor = UIColor.red.cgColor
        self.layer.shadowRadius = 55
        self.layer.shadowOpacity = 0.9
        
        spinnerView.center = self.center
        
        spinnerView.colors = self.spinnerColors
        spinnerView.style = .spinningFadeCircle
        
        
        
        self.addSubview(spinnerView)
    }
    
    open class func show(inView view: UIView) -> SKPreloadingView {
        
        let spinner = SKPreloadingView.shared
        spinner.removeFromSuperview()
        if spinner.superview == nil {
            //show the spinner
            view.addSubview(spinner)
            spinner.frame = view.bounds//CGRect(x: 0, y: 0, width: 100, height: 100)
            spinner.center = view.center
        }
        return spinner
    }
    
    open class func show() -> SKPreloadingView? {
        
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        guard let window = appDel.window else{
            return nil
        }
        
        let spinner = SKPreloadingView.shared
        
        spinner.removeFromSuperview()
        if spinner.superview == nil {
            //show the spinner
            spinner.alpha = 0.0
            spinner.frame = window.bounds
            spinner.center = window.center
            window.addSubview(spinner)
            //            UIView.animate(withDuration: 0.33, delay: 0.0, options: .curveEaseOut, animations: {
            spinner.alpha = 1.0
            window.bringSubviewToFront(spinner)
            //            }, completion: nil)
            
        }
        return spinner
    }
    
    //
    // Hide the spinner
    //
    open class func hide(_ completion: (() -> Void)? = nil) {
        
        let spinner = SKPreloadingView.shared
        
        NotificationCenter.default.removeObserver(spinner)
        
        DispatchQueue.main.async(execute: {
            if spinner.superview == nil {
                return
            }
            UIView.animate(withDuration: 0.33, delay: 0.0, options: .curveEaseOut, animations: {
                spinner.alpha = 0.0
            }, completion: {_ in
                spinner.alpha = 1.0
                spinner.removeFromSuperview()
                completion?()
            })
            
        })
    }
    
}
