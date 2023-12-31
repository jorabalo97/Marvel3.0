//
//  Utils.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste
//


import Foundation
import UIKit
import CryptoKit

enum KeyString: String {
    case publicKey
    case privateKey
}
   // Mensaje de error
enum ErrorString: String {
    case error = "Error",
         serverMsg = "Wrong with the credentials",
         internetIssue = "Internet issue",
         connectToInternet = "Please connect to internet"
}
  //Error claves API
enum ErrorMessage: String {
    case invalidAPIKey = "The passed API key is invalid.",
         invalidCredetial = "InvalidCredentials",
         vaildTimeStamp = "You must provide a timestamp.",
         missingParams = "MissingParameter"
}

class Utils: NSObject {
    
    //Hashmd5 hexadecimal
    class func md5Hash(_ source: String) -> String {
        let digest = Insecure.MD5.hash(data: source.data(using: .utf8) ?? Data())
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
    
    //Diccionario apiKeys de MarvelPlist
    class func getAPIKeys() -> [String: Any] {
        if let path = Bundle.main.path(forResource: "MarvelPlist", ofType: "plist") {
            let plist = NSDictionary(contentsOfFile: path) ?? ["":""]
            let publicKey = plist[KeyString.publicKey.rawValue] as! String
            let privateKey = plist[KeyString.privateKey.rawValue] as! String
            let dict = [KeyString.publicKey.rawValue: publicKey, KeyString.privateKey.rawValue: privateKey]
            return dict
            
        }
        return ["": ""]
        
    }
    
    //Redondeado de esquinas de vista
    func setCornerRadius(view: UIView) {
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        
    }
    
    //Controlador de alerta button ok
    func showAlertView(title : String,messsage: String)  {
        let alertController = UIAlertController(title: title, message: messsage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
        }
        alertController.addAction(okAction)
    }
    
}
