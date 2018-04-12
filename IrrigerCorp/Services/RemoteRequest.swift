//
//  RemoteRequest.swift
//  IrrigerCorp
//
//  Created by Rodrigo Fuscaldi on 4/11/18.
//  Copyright © 2018 std1. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RemoteDatabase {
    
    func request(url: URL, method: HTTPMethod) -> JSON {
        var jsonRequest: JSON?
        Alamofire.request(url, method: method).validate().responseJSON { (response) in
            if let value = response.result.value {
                let json = JSON(value)
                
                jsonRequest = json
            }
        }
        return jsonRequest ?? JSON.null
    }
}
