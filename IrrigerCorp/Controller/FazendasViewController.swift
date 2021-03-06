//
//  FazendasViewController.swift
//  IrrigerCorp
//
//  Created by Rodrigo Fuscaldi on 5/25/17.
//  Copyright © 2017 std1. All rights reserved.
//

import UIKit
import SwiftyGif
import CoreLocation
import SWRevealViewController
import Alamofire
import SwiftyJSON
import RealmSwift

var usuario = Usuario(idUsuario: tempId ?? UserDefaults.standard.object(forKey: "idUsuario") as! String, tipoUsuario: tempTipo ?? UserDefaults.standard.object(forKey: "tipoUsuario") as! String)

class FazendasViewController: UIViewController {
    
    @IBOutlet weak var viewSemFazenda: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewCarregando: UIView!
    @IBOutlet weak var imgCarregando: UIImageView!
    @IBOutlet weak var lblVisita: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var fazendas: Results<Fazenda>!
    
    let remoteDatabase = RemoteDatabase()
    
    let urls = URLs()
    
    var currentLocation: CLLocation!
    var locManager = CLLocationManager()
    
    var fazendasProximas = [[String:String]]()
    var todasFazendas: [Fazenda] = []
    
    var idFazenda: String!
    var latitude: String!
    var longitude: String!
    var nomeFazenda: String!
    var cidadeEstado: String!
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        viewSemFazenda.isHidden = true
        
        usuario.idUsuario = tempId ?? UserDefaults.standard.object(forKey: "idUsuario") as! String
        usuario.tipoUsuario = tempTipo ?? UserDefaults.standard.object(forKey: "tipoUsuario") as! String
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let gifmanager = SwiftyGifManager(memoryLimit:20)
        let gif = UIImage(gifName: "carregando", levelOfIntegrity: 1)
        imgCarregando.setGifImage(gif, manager: gifmanager)
        
        collectionView.isHidden = true
        lblVisita.isHidden = true
        loadData()
    }
    
    func loadData() {
        remoteDatabase.getFazendas { (arrFazendas) in
            if let arrayFazendas = arrFazendas {
                self.todasFazendas = arrayFazendas
                self.carregarFazendasProximas(fazendas: self.todasFazendas)
            }
        }
        

    }
    
    func carregarFazendasProximas(fazendas: [Fazenda]) {
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            currentLocation = locManager.location
            
            for fazenda in fazendas {
                //Latitude
                let latitude = fazenda.latitude!
                let doubleLatitude = Double(latitude)
                
                //Longitude
                let longitude = fazenda.longitude!
                let doubleLongitude = Double(longitude)
                
                if doubleLongitude != nil && doubleLatitude != nil {
                    let localFazenda = CLLocation(latitude: doubleLatitude!, longitude: doubleLongitude!)
                    let distanceInMeters = currentLocation.distance(from: localFazenda) // resultado em metros
                    
                    if(distanceInMeters <= 25000) {
                        self.fazendasProximas.append(fazenda)
                    }
                }
            }
            
            if self.fazendasProximas.count > 0 {
                viewCarregando.isHidden = true
                collectionView.isHidden = false
                lblVisita.isHidden = false
                
                self.collectionView.reloadData()
            } else {
                viewCarregando.isHidden = true
                viewSemFazenda.isHidden = false
            }
            
        } else {
            let alert = UIAlertController(title: "Erro ao buscar as fazendas", message: "Para localizar as fazendas próximas, por favor ative seu serviço de localização nas privacidades de seu celular.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alert) in
                self.todasFazendas.removeAll()
                self.loadData()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func iniciarVisita(_ sender: UIButton) {
        let row = sender.tag
        let fazenda = fazendasProximas[row]
        let alert = UIAlertController(title: "\(fazenda["nome"]!)", message: "Deseja iniciar uma visita?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sim", style: .default, handler: { (alert) in
            self.idFazenda = fazenda["idFazenda"]!
            self.latitude = String(self.currentLocation.coordinate.latitude)
            self.longitude = String(self.currentLocation.coordinate.longitude)
            self.nomeFazenda = fazenda["nome"]!
            self.cidadeEstado = "\(fazenda["cidade"]!)/\(fazenda["estado"]!)"
            trabalho = nil
            self.performSegue(withIdentifier: "iniciarVisita", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "iniciarVisita" {
            let proximaEtapa = segue.destination as! Etapa1ViewController
            proximaEtapa.idFazenda = self.idFazenda
            proximaEtapa.latitude = self.latitude
            proximaEtapa.longitude = self.longitude
            proximaEtapa.nomeFazenda = self.nomeFazenda
            proximaEtapa.cidadeEstado = self.cidadeEstado
        }
    }
    
    @IBAction func btnRecarregarFazendas(_ sender: Any) {
        todasFazendas.removeAll()
        viewSemFazenda.isHidden = true
        viewCarregando.isHidden = false
        loadData()
    }
}

extension FazendasViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FazendasCell
        let itemFazenda = fazendasProximas[indexPath.row]
        
        cell.lblCidadeFazenda.text = "\(itemFazenda["cidade"]!)/\(itemFazenda["estado"]!)"
        cell.lblNomeFazenda.text = itemFazenda["nome"]!
        cell.btnIniciarVisita.tag = indexPath.row
        cell.btnIniciarVisita.addTarget(self, action: #selector(iniciarVisita(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fazendasProximas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - 16, height: self.view.frame.height/2 - 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 20)
    }
    
}

