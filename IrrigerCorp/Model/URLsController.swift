//
//  URLsController.swift
//  IrrigerCorp
//
//  Created by Rodrigo Fuscaldi on 6/21/17.
//  Copyright © 2017 std1. All rights reserved.
//

import Foundation

class URLs {
    let urlBase = "https://irrigerconnect.com/Webservices/Apps/Irriger/v1/public"
    
    //POST do login
    func postLoginUrl() -> URL {
        return URL(string: "\(urlBase)/login")!
    }
    
    //GET das Fazendas
    func getFazendasUrl() -> URL {
        return URL(string: "\(urlBase)/\(usuario.tipoUsuario)/\(usuario.idUsuario)/fazendas")!
    }
    
    //POST da visita
    func postVisitaUrl() -> URL {
        return URL(string: "\(urlBase)/visita")!
    }
    
    //POST da foto
    func postFotoUrl() -> URL {
        return URL(string: "\(urlBase)/visita/foto")!
    }
}
