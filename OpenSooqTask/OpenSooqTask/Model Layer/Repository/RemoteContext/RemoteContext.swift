
//  OpenSooqTask
//
//  Created by Qais Alnammari on 7/6/19.
//  Copyright © 2019 Qais Alnammari. All rights reserved.
//

import Alamofire
import AlamofireNetworkActivityLogger

enum ContentType: String{
    case propertyList = "application/x-plist"
    case json = "application/json"
    case urlEncoded = "application/x-www-form-urlencoded"
}

final class RemoteContext {
    
    //This layer is used to handle requests and to isolate Alamofire,incase of changes 
    //MARK: - Properties
    
    
    private var sessionManager: SessionManager!
    
    private var baseURL: String!
    //////////////////////////////////
    
    
    //MARK: - Initializers
    
    
    /// Initialize session manager and Alamofire configurations
    init(baseURL: String){
        self.baseURL = baseURL
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        
        //        configuration.httpAdditionalHeaders?.updateValue("application/json", forKey: "Accept")
        self.sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    
  
    
    
    /// Creates an HTTP request to a given endpoint address
    ///
    /// - Parameters:
    ///   - endPoint: Endpoint
    ///   - parameters: [String: Any], Optional
    ///   - completion: A callback function invoked when the operation is completed.
    func request(endPoint: EndPointProtocol, parameters:[String: Any]?, completion:  ((Bool, Any?) -> Void)?){
        sendRequest(endPoint: endPoint, parameters: parameters,
                    completion: { (success: Bool, response: Any?) -> Void in
                        
                        guard success else {
                            completion?(false, response)
                            return
                        }
                        
                        guard let wsResponse = response as? DataResponse<Any> else{
                            completion?(true, Data())
                            return
                        }
                        
                        if let wsData = wsResponse.data {
                            completion?(true, wsData)
                        }
                        
        });//End sendRequest
    }
    
    
    /// Helper method to send an Http request to a given Endpoint.
    ///
    /// - Parameters:
    ///   - endPoint: Endpoint object
    ///   - parameters: Http request parameter as [String: Any], optional.
    ///   - completion: A callback function
    private func sendRequest (endPoint: EndPointProtocol, parameters:[String: Any]?, completion:  ((Bool, Any?) -> Void)? ) {
        let url = buildURlRequest(endPoint: endPoint, params: parameters)
     //   print("URL :: ", url, "\n" ,"httpMethod :: ",endPoint.httpMethod , "\n" , "headers :: ", endPoint.headers as Any  , "\n" , "params :: ", parameters , "\n" , "\n" )
        
        self.shouldDisplayActivityIndictor(true)
        sessionManager.request(url).validate().responseJSON { [weak self](response) in
			
			self?.shouldDisplayActivityIndictor(false)
			
            switch response.result {
            case .success:
                completion?(true, response)
            case .failure(let err as NSError):
                if response.response?.statusCode == 200 {
                    completion?(true, nil)
                    return
                }
                
                
                if let data = response.data{
                    let err = self?.parseError(data: data, err: err)
                    completion?(false,  err)
                }else{
                    completion?(false, err)
                }
            }
            
        }//End sessionManager.request

    }
	
	
	private func shouldDisplayActivityIndictor(_ flag: Bool){
		DispatchQueue.main.async {
			UIApplication.shared.isNetworkActivityIndicatorVisible = flag
		}
	}
    
    
    /// Helper method to build an HTTP request.
    ///
    /// - Parameters:
    ///   - endPoint: Endpoint object.
    ///   - params: Http request parameter as [String: Any], optional.
    /// - Returns: An Http request object of type URLRequestConvertible.
    private func buildURlRequest(endPoint: EndPointProtocol, params: [String: Any]?) -> URLRequestConvertible{
        let relativePath = baseURL + endPoint.address 
        let url = URL(string: relativePath)!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endPoint.httpMethod.rawValue
        
        var encoding: ParameterEncoding!
        
        if let headers = endPoint.headers {
            headers.keys.forEach({ (key) in
                urlRequest.setValue(headers[key]!, forHTTPHeaderField: key )
            })
            
            if let contentType = headers["Content-Type"] {
                switch contentType {
                case ContentType.json.rawValue:
                    encoding = JSONEncoding.default
                case ContentType.propertyList.rawValue:
                    encoding = PropertyListEncoding.default
                case ContentType.urlEncoded.rawValue:
                    encoding = URLEncoding.default
                default:
                    encoding = JSONEncoding.default
                }
            }else{
                encoding = JSONEncoding.default
            }
        }
        if endPoint.httpMethod == .get || endPoint.httpMethod == .delete{
            encoding = URLEncoding.default
        }
        return try! encoding.encode(urlRequest, with: params)
    }
    
    
    //Error Parser
    func parseError(data: Data, err: NSError?) -> NSError?{
        return err
//        do {
//            let json = try JSON(data: data)
//
//            let userInfo: [String : Any] = [
//                NSLocalizedDescriptionKey :  json["message"].stringValue ,
//                NSLocalizedFailureReasonErrorKey : json["messageDetail"].stringValue
//            ]
//            let error = NSError(domain: "RemoteDataSourceDomain", code: ErrorCode.badRequest.rawValue, userInfo: userInfo)
//            return error
//        }catch(_){
//            return err
//        }
    }
}
