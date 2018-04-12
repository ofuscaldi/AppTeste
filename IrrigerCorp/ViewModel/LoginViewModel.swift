//
//  LoginViewModel.swift
//  IrrigerCorp
//
//  Created by Rodrigo Fuscaldi on 4/11/18.
//  Copyright © 2018 std1. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class LoginViewModel {
    
    let urls = URLs()
    let remote = RemoteDatabase()
    
    func efetuarlogin() -> String {
        let urlPost = urls.postLoginUrl()
        let method: HTTPMethod = .get
        
        let json = remote.request(url: urlPost, method: method)
        let status = json["status"].stringValue
        
        return status
    }
    
    
    
}
