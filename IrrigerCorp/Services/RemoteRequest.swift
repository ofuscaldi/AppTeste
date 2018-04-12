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
    
    let urls = URLs()
    
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
    
    func getFazendas(completionHandler: @escaping (_ fazendas: [Fazenda]?, Error?) -> Void) {
        
        let url = urls.getFazendasUrl()
        var arrFazendas: [Fazenda] = []
        
        Alamofire.request(url, method: .get)
            .validate()
            .responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    let data = json["data"].arrayValue
                    
                    for fazendas in data {
                        let fazenda = Fazenda()
                        fazenda.idFazenda = fazendas["idFazenda"].stringValue
                        fazenda.nome = fazendas["nome"].stringValue
                        fazenda.cidade = fazendas["cidade"].stringValue
                        fazenda.estado = fazendas["estado"].stringValue
                        fazenda.latitude = fazendas["latitude"].stringValue
                        fazenda.longitude = fazendas["longitude"].stringValue
                        
                        arrFazendas.append(fazenda)
                    }
                }
                UserDefaults.standard.set(arrFazendas, forKey: "todasFazendas")
                completionHandler(arrFazendas, nil)
                
            case .failure(let error):
                completionHandler(nil, error)
                let todasFazendas = UserDefaults.standard.object(forKey: "todasFazendas") as? [[String:String]] ?? [[String:String]]()
                if todasFazendas.count > 0 {
                    //self.carregarFazendasProximas(fazendas: todasFazendas)
                } else {
                    let alert = UIAlertController(title: "Sem Conexão", message: "Por favor, conecte-se à uma rede para buscar as fazendas próximas.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alert) in
                        //self.loadData()
                    }))
                    //self.present(alert, animated: true, completion: nil)
                }
            }
            //FIM SWITCH
        }
        
    }
    
}
