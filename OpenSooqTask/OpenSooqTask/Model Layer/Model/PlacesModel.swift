//
//  PlacesModel.swift
//  OpenSooqTask
//
//  Created by Qais Alnammari on 7/7/19.
//  Copyright © 2019 Qais Alnammari. All rights reserved.
//

import Foundation

struct PlacesModel:Codable {
    
    var response:Response?
}

struct Response: Codable {
    var headerLocation:String?
    var headerFullLocation:String?
    var headerLocationGranularity:String?
    var query:String?
    var totalResults:Int?
    var groups : [Groups]?
}

struct Groups: Codable {
    var type:String?
    var name:String?
    var items:[VenueItems]?
}

struct VenueItems: Codable {
    var venue:VenueDetails?
}

struct VenueDetails: Codable {
    var name:String?
    var location:VenueLocation?
    var categories:[Categories]?
}

struct VenueLocation: Codable {
    var address:String?
    var lat:Double?
    var lng:Double?
    var distance:Int?
//    var categories
}

struct Categories: Codable {
    var name :String
    var icon:Icon?
}

struct Icon: Codable {
    var prefix:String
    var suffix:String
}
