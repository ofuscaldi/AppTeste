//
//  Etapa1ViewController.swift
//  IrrigerCorp
//
//  Created by Rodrigo Fuscaldi on 7/24/17.
//  Copyright © 2017 std1. All rights reserved.
//

import Foundation
import UIKit

class Etapa1ViewController: UIViewController {

    @IBOutlet weak var btnImplantacao: UIButton!
    @IBOutlet weak var btnAcompanhamento: UIButton!
    @IBOutlet weak var lblNomeFazenda: UILabel!
    
    var cidadeEstado: String!
    var nomeFazenda: String!
    var idFazenda: String!
    var latitude: String!
    var longitude: String!
    
    override func viewDidLoad() {
        arrayImagens.removeAll()
        imagens.removeAll()
    }

    override func viewWillAppear(_ animated: Bool) {
        lblNomeFazenda.text = nomeFazenda
        if trabalho != nil {
            if trabalho == "Implantação" {
                btnImplantacao.setImage(#imageLiteral(resourceName: "botaoCirculoMarcado"), for: .normal)
                btnAcompanhamento.setImage(#imageLiteral(resourceName: "botaoCirculo"), for: .normal)
            } else if trabalho == "Acompanhamento" {
                btnAcompanhamento.setImage(#imageLiteral(resourceName: "botaoCirculoMarcado"), for: .normal)
                btnImplantacao.setImage(#imageLiteral(resourceName: "botaoCirculo"), for: .normal)
            }
        }
    }

    @IBAction func btnImplantacao(_ sender: Any) {
        trabalho = "Implantação"
        performSegue(withIdentifier: "etapa12", sender: self)
    }

    @IBAction func btnAcompanhamento(_ sender: Any) {
        trabalho = "Acompanhamento"
        performSegue(withIdentifier: "etapa12", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "etapa12" {
            let proximaEtapa = segue.destination as! Etapa2ViewController
            proximaEtapa.idFazenda = self.idFazenda
            proximaEtapa.latitude = self.latitude
            proximaEtapa.longitude = self.longitude
            proximaEtapa.nomeFazenda = self.nomeFazenda
            proximaEtapa.cidadeEstado = self.cidadeEstado
        }
    }


}
