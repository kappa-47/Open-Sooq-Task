
//  OpenSooqTask
//
//  Created by Qais Alnammari on 7/6/19.
//  Copyright © 2019 Qais Alnammari. All rights reserved.
//

import Foundation

protocol DataSourceProtocol {
    
    //local data source,remote data source and data source must implement those protocols
    
    
    func checkForInterNetConnetion() -> Bool
    
    func getVenues(ll:String,query:String,intent:String,radius:Int,version:String,limit:Int,success:((PlacesModel)->Void)? , failure:((NSError)->Void)?)
    
}
