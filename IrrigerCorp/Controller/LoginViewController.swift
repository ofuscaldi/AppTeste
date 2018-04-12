//
//  LoginViewController.swift
//  IrrigerCorp
//
//  Created by Rodrigo Fuscaldi on 5/25/17.
//  Copyright © 2017 std1. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift
import Alamofire
import SwiftyJSON

var tempId: String!
var tempTipo: String!

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    
    var loginViewModel: LoginViewModel!
    let urls = URLs()
    
    var locManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        senhaTextField.delegate = self
        
        locManager.requestWhenInUseAuthorization()
        btnLogin.layer.cornerRadius = 8.0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.6) {
            self.view.endEditing(true)
        }
        return false
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        let urlPost = urls.postLoginUrl()
        Alamofire
            .request(urlPost, method: .post, parameters: ["email": emailTextField.text!, "senha": senhaTextField.text!])
            .validate()
            .responseJSON() { response in
                
                if response.result.value != nil {
                    let value = response.result.value
                    let json = JSON(value!)
                    let status = json["status"].stringValue
                    print(json)
                    
                    if status == "NAO_ENCONTRADO" {
                        self.criaAlertas(titulo: "Email incorreto", mensagem: "Por favor, confira se digitou seu email corretamente.")
                    } else if status == "OK" {
                        UserDefaults.standard.set(true, forKey: "logado")
                        let id = json["data"]["id"].stringValue
                        print(id)
                        tempId = id
                        UserDefaults.standard.set(id, forKey: "idUsuario")
                        
                        let tipo = json["data"]["tipo"].stringValue
                        print(tipo)
                        tempTipo = tipo
                        UserDefaults.standard.set(tipo, forKey: "tipoUsuario")
                        
                        UserDefaults.standard.synchronize()
                        
                        if CLLocationManager.locationServicesEnabled() {
                            self.performSegue(withIdentifier: "loginSucesso", sender: self)
                            
                        }
                        
                    } else if status == "ACESSO_NEGADO" {
                        self.criaAlertas(titulo: "Acesso negado", mensagem: "Sua senha está incorreta.")
                        self.senhaTextField.text = ""
                    } else {
                        self.criaAlertas(titulo: "Erro ao fazer o login", mensagem: "Nao foi possível efetuar seu login. Tente novamente.")
                    }
                } else {
                    
                }
        }
    }
    
    @objc func viewTapped() {
        UIView.animate(withDuration: 0.6, animations: {
            self.view.endEditing(true)
        })
    }
    
    func criaAlertas(titulo: String, mensagem: String) {
        let alert = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
