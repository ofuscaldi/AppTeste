//
//  EncerrarVisitaViewController.swift
//  IrrigerCorp
//
//  Created by Rodrigo Fuscaldi on 7/29/17.
//  Copyright © 2017 std1. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class EncerrarVisita: UIViewController {
    
    @IBOutlet weak var lblCidadeFazenda: UILabel!
    @IBOutlet weak var lblNomeFazenda: UILabel!
    
    var idLocal: Int!
    var nomeFazenda: String!
    dynamic var identificador: String!
    dynamic var dataInicio: String!
    dynamic var horaInicio: String!
    var idFazenda: String!
    var latitude: String!
    var longitude: String!
    dynamic var tipoVisita: String!
    var arrayAtividades = List<Atividade>()
    var stringAtividades: String!
    dynamic var tipoObservacao: String!
    dynamic var observacao: String!
    var cidadeEstado: String!
    
    var arrayImagensObjeto = List<Imagens>()
    var arrayDescricoesObjeto = List<Categorias>()
    var arrayObservacoesObjeto = List<Observacoes>()
    var dataTermino: String!
    var horaTermino: String!
    var salvoNoServidor: String!
    
    override func viewDidLoad() {
        lblNomeFazenda.text = nomeFazenda
        lblCidadeFazenda.text = cidadeEstado
    }
    
    @IBAction func btnEncerrarVisita(_ sender: UIButton) {
        let alert = UIAlertController(title: "Finalizar visita", message: "Gostaria de finalizar esta visita?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Finalizar", style: .default, handler: { (alert) in
            let realm = try! Realm()
            
            let dataVisita = DateFormatter()
            dataVisita.dateFormat = "yyyy/MM/dd"
            let data = dataVisita.string(from: Date())
            
            let hora = DateFormatter()
            hora.dateFormat = "hh:mm:ss"
            let horaTermino = hora.string(from: Date())
            
            self.dataTermino = data
            self.horaTermino = horaTermino
            self.salvoNoServidor = "0"
            
            for item in imagens {
                let imagem = Imagens()
                imagem.identificador = item["identificador"] as! String
                imagem.identificadorVisita = item["identificadorVisita"] as! String
                imagem.latitude = item["latitude"] as! String
                imagem.longitude = item["longitude"] as! String
//                imagem.idAtividade = item["idAtividade"] as! String
                imagem.observacao = item["observacao"] as! String
                imagem.imagemCaminho = item["imagemCaminho"] as! String
                imagem.nome = item["nome"] as! String
                imagem.data = item["data"] as! String
                imagem.hora = item["hora"] as! String
                imagem.salvaNoServidor = item["salvaNoServidor"] as! String
                
                self.arrayImagensObjeto.append(imagem)
            }
            
            for item in arrayDescricoes {
                let descricao = Categorias()
                descricao.categoria = item
                self.arrayDescricoesObjeto.append(descricao)
            }
            
            for item in arrayObservacoes {
                let observacao = Observacoes()
                observacao.observacao = item
                self.arrayObservacoesObjeto.append(observacao)
            }
            
            try! realm.write {
                let visita = Visita()
                visita.idLocal = self.idLocal
                visita.nomeFazenda = self.nomeFazenda
                visita.identificador = self.identificador
                visita.dataInicio = self.dataInicio
                visita.horaInicio = self.horaInicio
                visita.idFazenda = self.idFazenda
                visita.latitude = self.latitude
                visita.longitude = self.longitude
                visita.tipoVisita = self.tipoVisita
                visita.arrayAtividades = self.arrayAtividades
                visita.stringAtividades = self.stringAtividades
                visita.tipoObservacao = self.tipoObservacao
                visita.observacao = self.observacao
                visita.arrayImagens = self.arrayImagensObjeto
                visita.arrayDescricoes = self.arrayDescricoesObjeto
                visita.arrayObservacoes = self.arrayObservacoesObjeto
                visita.dataTermino = self.dataTermino
                visita.horaTermino = self.horaTermino
                visita.salvoNoServidor = self.salvoNoServidor
                
                realm.add(visita)
                
                // ---------------------------
                let alert = UIAlertController(title: "Visita concluída!", message: "Visita concluída com sucesso. Vá para a tela de relatórios.", preferredStyle: .alert)
                let okAlert = UIAlertAction(title: "Ok", style: .default, handler: {(alert) in
                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainVC") as UIViewController
                    tempObservacoes = ""
                    self.present(viewController, animated: false, completion: nil)
                })
                
                alert.addAction(okAlert)
                self.present(alert, animated: true, completion: nil)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Voltar", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}
