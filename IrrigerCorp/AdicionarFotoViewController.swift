 //
//  AdicionarFotoViewController.swift
//  IrrigerCorp
//
//  Created by Rodrigo Fuscaldi on 6/27/17.
//  Copyright © 2017 std1. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift

class AdicionarFotoViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var alturaImagem: NSLayoutConstraint!
    @IBOutlet weak var larguraImagem: NSLayoutConstraint!
    @IBOutlet weak var imgVisita: UIImageView!
    @IBOutlet weak var categoriaTextField: UITextField!
    @IBOutlet weak var observacoesTextField: UITextField!
    @IBOutlet weak var btnSalvarObservacao: UIButton!
    @IBOutlet weak var viewImagem: UIView!
    
    dynamic var identificador: String!
    dynamic var latitude: String!
    dynamic var longitude: String!

    var ordemFoto = UserDefaults.standard.object(forKey: "ordemFoto") as? Int ?? 0
    var imagePickerController = UIImagePickerController()
    var cameraPermissions: Bool = false
    var fotoTirada: UIImage!
    
    var idAtividade: String!
    var imagem = [String:Any]()
    
    var observacaoPicker = UIPickerView()
    
    let pickerData = ["Configuração e acesso ao sistema", "Configuração de partes técnicas", "Testes físico hídricos do solo", "Treinamento da equipe da fazenda", "Levantamento das contas de energia", "Aferição de pressão", "Levantamento mapa de bocais", "Levantamento espaçamento", "Aferição de velocidade de deslocamento", "Aferição de tensão e amperagem", "Aferição de RPM do motor Diesel", "Checagem do desenvolvimento da cultura", "Checagem de umidade", "Checagem do balanço hídrico", "Análise de risco/plantio", "Ajustes na configuração do solo", "Kc/Ks/Kl", "Profundidade radicular", "Duração da fase", "Ajustes na configuração do equipamento", "Estratégia/planejamento de irrigação", "Estudo/aferição das contas de energia", "Apresentação de relatório de safra", "Apresentação de relatório anual", "Treinamento de equipe da fazenda", "Verificação de ajustes de solicitações", "Aferição de pressão", "Levantamento mapa de bocais", "Levantamento espaçamento", "Aferição de velocidade de deslocamento", "Aferição de tensão e amperagem", "Aferição de RPM do motor Diesel"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkPermissions()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    override func viewDidLoad() {
        
        categoriaTextField.isHidden = true
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: observacoesTextField.frame.height))
        let paddingViewCategoria = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: categoriaTextField.frame.height))
        observacoesTextField.leftView = paddingView
        observacoesTextField.leftViewMode = .always
        
        categoriaTextField.leftView = paddingViewCategoria
        categoriaTextField.leftViewMode = .always
        
        let takePictureGesture = UITapGestureRecognizer(target: self, action: #selector(takePictureTapped))
        imgVisita.addGestureRecognizer(takePictureGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.view.addGestureRecognizer(tapGesture)
        
        observacaoPicker.delegate = self
        observacaoPicker.dataSource = self
        observacoesTextField.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 43/255, green: 63/255, blue: 51/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Ok", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .camera
        
        categoriaTextField.inputView = observacaoPicker
        categoriaTextField.inputAccessoryView = toolBar
        
        //Teclado
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        createDirectory()
        design()
    }
    
    func design() {
        btnSalvarObservacao.layer.cornerRadius = 8.0
    }
    
    func donePicker (sender:UIBarButtonItem) {
        self.view.endEditing(false)
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
        idAtividade = String(row + 1)
        categoriaTextField.text = pickerData[row]
    }
    
    func createDirectory(){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("customDirectory")
        if !fileManager.fileExists(atPath: paths){
            try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
        }else{
            print("Already dictionary created.")
        }
    }
    
    func checkPermissions() {
        let cameraMediaType = AVMediaTypeVideo
        let cameraAuthorisationStatus = AVCaptureDevice.authorizationStatus(forMediaType: cameraMediaType)
        
        switch cameraAuthorisationStatus {
        case .authorized:
            cameraPermissions = true
            
        case .denied:
            cameraPermissions = false
            
        case.restricted:
            cameraPermissions = false
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: cameraMediaType, completionHandler: { granted in
                self.cameraPermissions = granted
            })
        }
        
    }
    
    func takePictureTapped() {
        guard cameraPermissions else {
            let permissionsAlertController = UIAlertController(title: "Camera", message: "Acessar a Camera", preferredStyle: .alert)
            let aceitar = UIAlertAction(title: "Permitir", style: .default, handler: nil)
            permissionsAlertController.addAction(aceitar)
            
            present(permissionsAlertController, animated: true, completion: nil)
            return
        }
        
        let alert = UIAlertController(title: "Atenção", message: "Para um melhor aproveitamento e visualização das fotos, vire o celular horizontalmente.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entendi", style: .default, handler: { (alert) in
            self.present(self.imagePickerController, animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let identificador = DateFormatter()
            identificador.dateFormat = "yyyyMMddhhmmss"
            let ident = identificador.string(from: Date())
            
            larguraImagem.constant = viewImagem.frame.width
            alturaImagem.constant = viewImagem.frame.width
        
            imgVisita.image = pickedImage
            fotoTirada = pickedImage
            let fileManager = FileManager.default
            let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(ident)\(usuario.idUsuario).jpg")
            
            arrayImagensPaths.append(paths)
            
            let dataVisita = DateFormatter()
            dataVisita.dateFormat = "yyyy/MM/dd"
            let data = dataVisita.string(from: Date())
            
            let horaVisita = DateFormatter()
            horaVisita.dateFormat = "hh:mm:ss"
            let hora = horaVisita.string(from: Date())

            imagem["identificador"] = "\(ident)\(usuario.idUsuario)"
            imagem["nome"] = "\(ident)\(usuario.idUsuario).jpg"
            imagem["imagemCaminho"] = paths
            imagem["data"] = data
            imagem["hora"] = hora
            imagem["latitude"] = self.latitude
            imagem["longitude"] = self.longitude
            imagem["identificadorVisita"] = self.identificador
            
            let imageData = UIImageJPEGRepresentation(pickedImage, 0.5)
            fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func viewTapped() {
        UIView.animate(withDuration: 0.6, animations: {
            self.view.endEditing(true)
        })
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if observacoesTextField.isEditing {
            
            let info = notification.userInfo!
            let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let keyboardTime = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            
            UIView.animate(withDuration: keyboardTime) {
                self.view.window?.frame.origin.y =  -(keyboardFrame.height) + 100
            }
            
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.view.window?.frame.origin.y != 0 {
            
            let info = notification.userInfo!
            let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let keyboardTime = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            
            UIView.animate(withDuration: keyboardTime) {
                self.view.window?.frame.origin.y += keyboardFrame.height - 100
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.6) {
            self.view.endEditing(true)
        }
        return false
    }
    
    @IBAction func btnSalvarObservacao(_ sender: UIButton) {

        if fotoTirada != nil {
            arrayImagens.append(fotoTirada)
            arrayDescricoes.append(categoriaTextField.text!)
            
            imagem["idAtividade"] = idAtividade
            imagem["salvaNoServidor"] = "0"
            
            if observacoesTextField.text == "" {
                observacoesTextField.text = ""
                arrayObservacoes.append(observacoesTextField.text!)
                imagem["observacao"] = observacoesTextField.text!
            } else {
                arrayObservacoes.append(observacoesTextField.text!)
                imagem["observacao"] = observacoesTextField.text!
            }
            print(imagem)
            //
            imagens.append(imagem)
            
            //arrayNomeImagens.append(nomeImagens)
            
            ordemFoto += 1
            UserDefaults.standard.set(ordemFoto, forKey: "ordemFoto")
            imgVisita.image = #imageLiteral(resourceName: "inserirFotoGrande")
            categoriaTextField.text = ""
            observacoesTextField.text = ""
            larguraImagem.constant = 100
            alturaImagem.constant = 100
            
            let alert = UIAlertController(title: "Foto salva", message: "Sua foto foi salva com sucesso! Retorne para a tela anterior para visualizá-la ou insira mais fotos.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(alert) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Erro ao salvar", message: "Para salvar uma foto, selecione o botão acima. Se necessário, adicione uma boservação.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
        
    }
    
}
