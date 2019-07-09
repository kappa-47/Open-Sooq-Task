
//  OpenSooqTask
//
//  Created by Qais Alnammari on 7/6/19.
//  Copyright © 2019 Qais Alnammari. All rights reserved.
//

import Foundation
import Alamofire

class RemoteDataSource : DataSourceProtocol {
    //This layer is responsible for API Requests and mapping
    
    
    //MARK:-Proparties
    lazy var remoteContext = RemoteContext(baseURL: ApiEndPoints.baseUrl)
    
    
    //Check for internet connection
//    func checkForInternetConnection(isConnected:Bool) -> Bool {
//        return NetworkReachabilityManager()?.isReachable ?? false
//    }
//    class var checkForInternetConnection : Bool {
//        return NetworkReachabilityManager()?.isReachable ?? false
//    }
    func checkForInterNetConnetion() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    // Requests:-
    func getVenues(ll: String, query: String, intent: String, radius: Int, version: String, limit: Int, success: ((PlacesModel) -> Void)?, failure: ((NSError) -> Void)?) {
        let url = ApiEndPoints.getVenues.rawValue
        let endPoint = EndPoint(address: url, httpMethod: .get)
        let prams = [
            "ll":ll,
            "query":query,
            "intent":intent,
            "radius":radius,
            "v":version,
            "limit":limit,
            "client_id":Constants.clientID,
            "client_secret":Constants.clientSecret
            ] as [String : Any]
        remoteContext.request(endPoint: endPoint, parameters: prams) { (result, data) in
            
            guard result else {
                //Failure
                let error = data as? NSError
                print("Error occured while authenticating user. In \(#function). \(error!.localizedDescription)")
                failure?(error!)
                return
            }
            
            let decoder = JSONDecoder()
            
            do{
                let model = try decoder.decode(PlacesModel.self, from: data as! Data)
                success?(model)
            }catch let err{
                failure?(err as NSError)
            }
        }
    }
    
}
    
    

