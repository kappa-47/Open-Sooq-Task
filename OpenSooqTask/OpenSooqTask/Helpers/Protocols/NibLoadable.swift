//
//  NibLoadable.swift
//  BaseiOS
//
//  Created by Qais Alnammari on 2/9/18.
//  Copyright © 2018 base. All rights reserved.
//


import UIKit

// MARK: - Normal XIB UIViews
//This way us useded to prevent miss spelling for registeration IDs
protocol NibViewProtocol: class {
    var contentView: UIView? { get set }
    func xibSetup()
    func loadViewFromNib() -> UIView?
}

extension NibViewProtocol where Self: UIView {
    func xibSetup() {
        contentView = loadViewFromNib()
        contentView!.frame = bounds
        contentView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView!)
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = (nib.instantiate(withOwner: self, options: nil)[0] as? UIView)!
        return view
    }
}

// MARK: - Cells

protocol ReusableView: class {}

extension ReusableView where Self: UIView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

protocol NibLoadableView: class {}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}


extension UITableView {
    
    func register<T: UITableViewCell>(_: T.Type) where T : ReusableView, T: NibLoadableView {
        
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<Z : UITableViewCell>(forIndexPath indexPath: IndexPath) -> Z where Z : ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: Z.reuseIdentifier, for: indexPath as IndexPath) as? Z else {
            fatalError("Could not dequeue cell with identifier: \(Z.reuseIdentifier)")
        }
        
        return cell
    }
}


extension UITableViewCell: ReusableView,NibLoadableView {}

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_: T.Type) where T : ReusableView, T: NibLoadableView {
        
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T : ReusableView {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath as IndexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        
        return cell
    }
}

extension UICollectionViewCell: ReusableView,NibLoadableView {}
