//
//  MarvelAPIService.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste 
//
import UIKit
import Foundation
import SystemConfiguration
class MarvelAPIService: NSObject {
    
   var privateKey = "4da961812496c30cf73ed692b494f315"
   var publicKey = "d7fc2827797d7e47f6417dca83b3beeb4c5607ee"
   var baseUrl = "https://gateway.marvel.com:443/v1/public/characters?limit=50&offset=0&apikey=4da961812496c30cf73ed692b494f315"
    // Request characters api with pagination
    func getRequestWithPagination(url: String, offset: Int, limit: Int, completion: @escaping (_ jsonData: Data?, _ error: Error?, _ statuscode: Int?) -> ()) {
        
        if InternetConnectCheckClass.isConnectedToNetwork() {
            var urlComponents = URLComponents(string: url)
            let offsetQueryItem = URLQueryItem(name: "offset", value: "\(offset)")
            let limitQueryItem = URLQueryItem(name: "limit", value: "\(limit)")
            urlComponents?.queryItems = [offsetQueryItem, limitQueryItem]
            
            guard let finalURL = urlComponents?.url else {
                completion(nil, NSError(domain: "InvalidURL", code: 0, userInfo: nil), nil)
                return
            }
            
            let request = URLRequest(url: finalURL)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    guard let httpResponse = response as? HTTPURLResponse else { return }
                    
                    if let error = error {
                        completion(nil, error, httpResponse.statusCode)
                        return
                    }
                    
                    guard let responseData = data else {
                        return
                    }
                    
                    if httpResponse.statusCode == 200 {
                        completion(responseData, nil, httpResponse.statusCode)
                    } else {
                        completion(responseData, nil, httpResponse.statusCode)
                    }
                }
            }
            
            task.resume()
        } else {
            Utils().showAlertView(title: ErrorString.internetIssue.rawValue, messsage: ErrorString.connectToInternet.rawValue)
        }
    }
}

class InternetConnectCheckClass {
    
    //Verificar conexion a internet
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
    
    
}
