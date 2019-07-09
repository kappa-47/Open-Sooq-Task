
//  OpenSooqTask
//
//  Created by Qais Alnammari on 7/6/19.
//  Copyright © 2019 Qais Alnammari. All rights reserved.
//

import Foundation

final class DataSource : DataSourceProtocol {
    //This layer determine the data source provider eather local or remote
    
    static var shared: DataSourceProtocol = DataSource()
    
    lazy var remoteDataSource:DataSourceProtocol = RemoteDataSource()
//    lazy var localDataSource = LocalDataSource()
    
    
    //check for internetConnection:-
    func checkForInterNetConnetion() -> Bool {
        return remoteDataSource.checkForInterNetConnetion()
    }
    
    // DataSource func:-
    
    func getVenues(ll: String, query: String, intent: String, radius: Int, version: String, limit: Int, success: ((PlacesModel) -> Void)?, failure: ((NSError) -> Void)?) {
        remoteDataSource.getVenues(ll: ll, query: query, intent: intent, radius: radius, version: version, limit: limit, success: { (places) in
            success?(places)
        }, failure: failure)
    }
}
