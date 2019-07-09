//
//  MainViewModel.swift
//  OpenSooqTask
//
//  Created by Qais Alnammari on 7/7/19.
//  Copyright © 2019 Qais Alnammari. All rights reserved.
//

import Foundation

class MainViewModel {
    
    var places:PlacesModel?
    var selectedMarkerIndex:Int?
    
    var longLat:String?
    var query = "restaurants and cafes"
    var intent = "brows"
    var radios = 500
    var version = "20190706"
    var limit = 10
    
    func getVenues(success:@escaping()->Void,failure:@escaping(NSError)->Void) {
        guard let ll = longLat else {return}
        DataSource.shared.getVenues(ll: ll, query: query, intent: intent, radius: radios, version: version, limit: limit, success: { [weak self] (places) in
            self?.places = places
            success()
        }, failure: failure)
    }
    
    func getVenues() -> [VenueItems] {
        
        guard let group = places?.response?.groups?[0] else {return []}
        let venues = group.items
        return venues ?? []
        
    }
    
    func checkForInternetConnection() -> Bool {
        return DataSource.shared.checkForInterNetConnetion()
    }
}
