//
//  Etapa4ViewController.swift
//  IrrigerCorp
//
//  Created by Rodrigo Fuscaldi on 6/27/17.
//  Copyright © 2017 std1. All rights reserved.
//

import AVFoundation
import UIKit
import RealmSwift
import Alamofire

var imagens = [[String: Any]]()

class Etapa4ViewController: UIViewController {
    
    //Variaveis das etapas anteriores
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
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var stackBotoes: UIStackView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        
        if arrayImagens.count > 0 {
            collectionView.isHidden = false
            stackBotoes.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        automaticallyAdjustsScrollViewInsets = false

        collectionView.isHidden = true
        stackBotoes.isHidden = true
        
//        arrayImagens.removeAll()
//        imagens.removeAll()
    }
    
    @IBAction func btnAdicionarFoto(_ sender: Any) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        performSegue(withIdentifier: "adicionarFoto", sender: self)
    }
    
    @IBAction func btnSalvarVisita(_ sender: Any) {
        performSegue(withIdentifier: "encerrarVisita", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "adicionarFoto" {
            let proximaEtapa = segue.destination as! AdicionarFotoViewController
            proximaEtapa.latitude = self.latitude
            proximaEtapa.longitude = self.longitude
            proximaEtapa.identificador = self.identificador
        } else if segue.identifier == "encerrarVisita" {
            let proximaEtapa = segue.destination as! EncerrarVisita
            proximaEtapa.idFazenda = self.idFazenda
            proximaEtapa.latitude = self.latitude
            proximaEtapa.longitude = self.longitude
            proximaEtapa.nomeFazenda = self.nomeFazenda
            proximaEtapa.tipoVisita = trabalho
            proximaEtapa.identificador = self.identificador
            proximaEtapa.dataInicio = self.dataInicio
            proximaEtapa.horaInicio = self.horaInicio
            proximaEtapa.arrayAtividades = self.arrayAtividades
            proximaEtapa.stringAtividades = self.stringAtividades
            proximaEtapa.idLocal = self.idLocal
            proximaEtapa.tipoObservacao = self.tipoObservacao
            proximaEtapa.observacao = self.observacao
            proximaEtapa.cidadeEstado = self.cidadeEstado
        }
    }
}

extension Etapa4ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Etapa4Cell
        let imagem = arrayImagens[indexPath.row]
        let categoria = arrayDescricoes[indexPath.row]
        let observacao = arrayObservacoes[indexPath.row]
        
        cell.lblDescricao.isHidden = true
        
        cell.layer.cornerRadius = 8.0
        cell.layer.masksToBounds = false
        cell.layer.shadowOffset = CGSize(width: 2, height: 2)
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowRadius = 3
        cell.layer.shadowOpacity = 0.2
        
        cell.imgCell.image = imagem
        cell.lblDescricao.text = categoria
        cell.lblObservacoes.text = observacao
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrayImagens.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - 20, height: self.view.frame.height - 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 8.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 8.0)
    }

    
}
