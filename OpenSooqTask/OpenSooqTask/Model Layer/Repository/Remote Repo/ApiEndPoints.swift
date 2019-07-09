
//  OpenSooqTask
//
//  Created by Qais Alnammari on 7/6/19.
//  Copyright © 2019 Qais Alnammari. All rights reserved.
//

import Alamofire

//MARK: - ApiEndPoints
public enum ApiEndPoints: String{
    static let baseUrl = "https://api.foursquare.com/"
   
    case getVenues = "v2/venues/explore"
    
}

//MARK: - Endpoint
protocol EndPointProtocol {
    var address: String { get set }
    var httpMethod: HTTPMethod { get set }
    var headers: [String:String]? { get set }
}

struct EndPoint: EndPointProtocol {
    
    
    //MARK: - Properties
    var address: String
    var httpMethod: HTTPMethod
    var headers: [String:String]?
    //MARK: - Initializers
    
    /// Initializes an Endpoint object.
    ///
    /// - Parameters:
    ///   - address: TIAApiEndPoints Enum
    ///   - httpMethod: HTTPMethod
    ///   - headers: [[String: String]], Optional with nil as default value.
    init(address: ApiEndPoints, httpMethod: HTTPMethod, headers: [String:String]? = nil) {
        self.address = address.rawValue
        self.httpMethod = httpMethod
        self.headers = headers
    }
    
    init(address: String, httpMethod: HTTPMethod, headers: [String:String]? = nil) {
        self.address = address
        self.httpMethod = httpMethod
        self.headers = headers
    }
}
