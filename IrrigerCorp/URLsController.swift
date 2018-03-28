//
//  URLsController.swift
//  IrrigerCorp
//
//  Created by Rodrigo Fuscaldi on 6/21/17.
//  Copyright © 2017 std1. All rights reserved.
//

import UIKit

let urlBase = "https://irrigerconnect.com/Webservices/Apps/Irriger/v1/public"

class URLsController {

    
    
    struct URLs {
        
        //POST do login
        static let postlogin = URL(string: "\(urlBase)/login")!
        
        //GET das Fazendas
        //static let getFazendas = URL(string: "\(urlBase)/\(tipoUsuario)/\(idUsuario)/fazendas")!
        //static let getFazendas = URL(string: "\(urlBase)/login")
        
        //POST da visita
        static let postVisita = URL(string: "\(urlBase)/visita")!
        
        //POST da foto
        static let postFoto = URL(string: "\(urlBase)/visita/foto")!
        
        //static let getRelatorios = URL(string: "\(urlBase)/login")
    }
    
    
}
