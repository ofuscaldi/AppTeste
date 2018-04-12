//
//  Etapa3ViewController.swift
//  IrrigerCorp
//
//  Created by Rodrigo Fuscaldi on 6/12/17.
//  Copyright © 2017 std1. All rights reserved.
//

import UIKit
import ColorWithHex
import RealmSwift

class Etapa3ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var fieldTipoObservacao: UITextField!
    @IBOutlet weak var btnProxima: UIButton!
    
    //Variaveis das etapas anteriores
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
    var cidadeEstado: String!
    
    var tipoObservacaoPicker = UIPickerView()
    
    var tipoObservacao: String!
    var arraySelectedItens = NSMutableArray()
    let pickerData = ["Engenharia", "Decisão de irrigação", "Energia", "Problemas"]
    
    var objVisita = Visita()
    
    override func viewDidLoad() {
        automaticallyAdjustsScrollViewInsets = false
        tipoObservacaoPicker.delegate = self
        tipoObservacaoPicker.dataSource = self
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: fieldTipoObservacao.frame.height))
        fieldTipoObservacao.leftView = paddingView
        fieldTipoObservacao.leftViewMode = .always
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 43/255, green: 63/255, blue: 51/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Ok", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        fieldTipoObservacao.inputView = tipoObservacaoPicker
        fieldTipoObservacao.inputAccessoryView = toolBar
        
        design()
    }
    
    func design() {
        btnProxima.layer.cornerRadius = btnProxima.frame.width/2
    }
    
    @objc func donePicker (sender:UIBarButtonItem) {
        UIView.animate(withDuration: 0.6) {
            self.view.endEditing(false)
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fieldTipoObservacao.text = pickerData[row]
    }

    @IBAction func btnProxima(_ sender: UIButton) {
        if arraySelectedItens.count != 0 {
            
            let index = arraySelectedItens[0] as! Int
            self.tipoObservacao = pickerData[index]
        } else {
            self.tipoObservacao = ""
        }
        performSegue(withIdentifier: "etapa331", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "etapa331" {
            let proximaEtapa = segue.destination as! Etapa31ViewController
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
            proximaEtapa.cidadeEstado = self.cidadeEstado
        }
    }
    
}
