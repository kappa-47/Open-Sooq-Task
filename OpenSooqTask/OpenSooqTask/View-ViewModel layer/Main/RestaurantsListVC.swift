//
//  RestaurantsListVC.swift
//  OpenSooqTask
//
//  Created by Qais Alnammari on 7/7/19.
//  Copyright © 2019 Qais Alnammari. All rights reserved.
//

import UIKit


class RestaurantsListVC: UIViewController {
   
    //Outlets:-
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var restaurantTableView: UITableView!
    //Variables:-
    var viewModel = MainViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuerUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let vc = self.tabBarController?.viewControllers?.first as? MapVC { // getting MapVC viewModel to parss data insted of initialize it
            viewModel = vc.viewModel
        }
    }
    
    func configuerUI() {
        setupTableView()
        handlingOfflineView()
        titleLbl.text = localized(localizeKey: .nearByRestaurants)
    }
    
    func setupTableView() {
        restaurantTableView.register(RestaurantsListCell.self) // im using generic protocol for registering the cell,please check NibLoadable.swift file
        restaurantTableView.dataSource = self
        restaurantTableView.delegate = self
    }
    func handlingOfflineView() {
        if viewModel.checkForInternetConnection() { //Online
            restaurantTableView.isHidden = false
        } else { //OffLine
            restaurantTableView.isHidden = true
        }
        self.view.handelOfflineView(isConnected: viewModel.checkForInternetConnection())
    }
    
}

extension RestaurantsListVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getVenues().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = restaurantTableView.dequeueReusableCell(forIndexPath: indexPath) as RestaurantsListCell
        cell.selectionStyle = .none
        let venue = viewModel.getVenues()[indexPath.row].venue
        
        cell.name.text = "\(localized(localizeKey: .restaurantName)): \(venue?.name ?? "")"
        cell.distance.text = "\(localized(localizeKey: .distance)): \(venue?.location?.distance ?? 0) \(localized(localizeKey: .metersAway))"
        
        
        
        if let cat = venue?.categories?[0] {
            cell.type.text = "\(localized(localizeKey: .type)): \(cat.name)"
            // foursquare api is old,endpoint respons changed so you have buld the url this way [prefix + size + suffix]
            let url = (cat.icon?.prefix ?? "") + "bg_88" + ( cat.icon?.suffix ?? "") //bg_88 is the size of the icon
            cell.img.setImage(imageName: url) 
        } else {
            cell.type.text = localized(localizeKey: .unknown)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedMarkerIndex = indexPath.row
        self.tabBarController?.selectedIndex = 0 // return to the map view with selected marker
        
    }
}
