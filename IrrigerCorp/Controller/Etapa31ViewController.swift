//
//  Etapa31ViewController.swift
//  IrrigerCorp
//
//  Created by Rodrigo Fuscaldi on 7/25/17.
//  Copyright © 2017 std1. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

var tempObservacoes: String!

class Etapa31ViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textField: UITextView!

    var idLocal: Int!
    var nomeFazenda: String!
    @objc dynamic var identificador: String!
    @objc dynamic var dataInicio: String!
    @objc dynamic var horaInicio: String!
    var idFazenda: String!
    var latitude: String!
    var longitude: String!
    @objc dynamic var tipoVisita: String!
    var arrayAtividades = List<Atividade>()
    var stringAtividades: String!
    var tipoObservacao: String!
    var cidadeEstado: String!

    var observacao: String!
    var dataTermino: String!
    var horaTermino: String!
    var salvoNoServidor: String!


    var objVisita = Visita()

    override func viewDidLoad() {
        automaticallyAdjustsScrollViewInsets = false
        textField.delegate = self
        
        if let observacoes = tempObservacoes {
            textField.text = observacoes
        }

        //Teclado
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
        
        design()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tempObservacoes = textField.text
    }

    func design() {
        textField.layer.cornerRadius = 8.0
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardTime = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        UIView.animate(withDuration: keyboardTime) {
            self.view.window?.frame.origin.y =  -(keyboardFrame.height) + keyboardFrame.height
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.window?.frame.origin.y != 0 {
            
            let info = notification.userInfo!
            let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let keyboardTime = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            
            UIView.animate(withDuration: keyboardTime) {
                self.view.window?.frame.origin.y += keyboardFrame.height - keyboardFrame.height
            }
        }
    }


//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n" {
//            UIView.animate(withDuration: 0.6, animations: {
//                self.view.endEditing(true)
//            })
//        }
//        return true
//    }
    
    @IBAction func etapa34(_ sender: UIButton) {
        self.observacao = textField.text
        print(self.observacao)
        performSegue(withIdentifier: "etapa34", sender: self)
    }
    
    @objc func viewTapped() {
        UIView.animate(withDuration: 0.6, animations: {
            self.view.endEditing(true)
        })
    }

//    @IBAction func btnSalvarVisita(_ sender: UIButton) {
//        let realm = try! Realm()
//        
//        let dataVisita = DateFormatter()
//        dataVisita.dateFormat = "yyyy/MM/dd"
//        let data = dataVisita.string(from: Date())
//        
//        let hora = DateFormatter()
//        hora.dateFormat = "hh:mm:ss"
//        let horaTermino = hora.string(from: Date())
//        
//        self.dataTermino = data
//        self.horaTermino = horaTermino
//        self.salvoNoServidor = "0"
//        
//        try! realm.write {
//            let visita = Visita()
//            visita.idLocal = self.idLocal
//            visita.nomeFazenda = self.nomeFazenda
//            visita.identificador = self.identificador
//            visita.dataInicio = self.dataInicio
//            visita.horaInicio = self.horaInicio
//            visita.idFazenda = self.idFazenda
//            visita.latitude = self.latitude
//            visita.longitude = self.longitude
//            visita.tipoVisita = self.tipoVisita
//            visita.arrayAtividades = self.arrayAtividades
//            visita.stringAtividades = self.stringAtividades
//            visita.tipoObservacao = self.tipoObservacao
//            visita.observacao = self.observacao
//            visita.dataTermino = self.dataTermino
//            visita.horaTermino = self.horaTermino
//            visita.salvoNoServidor = self.salvoNoServidor
//            
//            realm.add(visita)
//            
//            // ---------------------------
//            let alert = UIAlertController(title: "Visita concluída!", message: "Visita concluída com sucesso. Vá para a tela de relatórios.", preferredStyle: .alert)
//            let okAlert = UIAlertAction(title: "Ok", style: .default, handler: {(alert) in
//                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainVC") as UIViewController
//                
//                self.present(viewController, animated: false, completion: nil)
//            })
//            alert.addAction(okAlert)
//            self.present(alert, animated: true, completion: nil)
//        }
//
//    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "etapa34" {
            let proximaEtapa = segue.destination as! Etapa4ViewController
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
