//
//  RelatoriosViewController.swift
//  IrrigerCorp
//
//  Created by Rodrigo Fuscaldi on 6/21/17.
//  Copyright © 2017 std1. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import ColorWithHex

class RelatoriosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var descricaoConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var btnUploadManual: UIBarButtonItem!
    
    let urls = URLs()
    let realm = try! Realm()
    let dateFormatter = DateFormatter()

    var refresher:UIRefreshControl!
    var relatorios: Results<Visita>!
    
    override func viewDidLoad() {
        automaticallyAdjustsScrollViewInsets = false
        
        self.refresher = UIRefreshControl()
        self.collectionView!.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.colorWithHex("#85A53D")
        self.refresher.addTarget(self, action: #selector(atualizarRelatorios), for: .valueChanged)
        self.collectionView!.addSubview(refresher)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        atualizarRelatorios()
    }
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getImage(image: Imagens){
        let fileManager = FileManager.default
        let imagePath = (self.getDirectoryPath() as NSString).appendingPathComponent(image.nome)
        
        if fileManager.fileExists(atPath: imagePath){
            let imagem = UIImage(contentsOfFile: imagePath)
            let parameters = ["identificador": image.identificador , "identificadorVisita": image.identificadorVisita, "latitude": image.latitude, "longitude": image.longitude, "data": image.data, "hora": image.hora, "observacao": image.observacao]
            let url = urls.postFotoUrl()
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(UIImageJPEGRepresentation(imagem!, 0.5)!, withName: "picture", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
                for (key, value) in parameters {
                    multipartFormData.append((value?.data(using: String.Encoding.utf8)!)!, withName: key)
                }
            }, to:url) { (result) in
                switch result {
                case .success(let upload, _, _):

                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                        self.progressView.setProgress(Float(Progress.fractionCompleted), animated: true)
                        if Progress.fractionCompleted == 1.0 {
                            try! self.realm.write {
                                image.salvaNoServidor = "1"
                            }
                        }
                    })
                case .failure:
                    self.btnUploadManual.isEnabled = true
                }
            }
            
        }
    }
    
    func stopRefresher() {
        self.refresher.endRefreshing()
    }
    
    @IBAction func btnUploadFotos(_ sender: Any) {
        atualizarRelatorios()
    }
    
    @objc func atualizarRelatorios() {
        relatorios = realm.objects(Visita.self)

        for relatorio in relatorios {
            for foto in relatorio.arrayImagens {
                if foto.salvaNoServidor == "0" {
                    self.btnUploadManual.isEnabled = false
                    self.refresher.isEnabled = false
                    getImage(image: foto)
                }
            }
            
            if relatorio.salvoNoServidor == "0" {
                Alamofire.request(urls.postVisitaUrl(), method: .post, parameters: ["idUsuario": usuario.idUsuario, "tipoUsuario": usuario.tipoUsuario, "identificador": relatorio.identificador, "idFazenda": relatorio.idFazenda, "tipoVisita": relatorio.tipoVisita, "tipoObservacao": relatorio.tipoObservacao, "observacao": relatorio.observacao, "latitude": relatorio.latitude, "longitude": relatorio.longitude, "dataInicio": relatorio.dataInicio, "horaInicio": relatorio.horaInicio, "dataTermino": relatorio.dataTermino, "horaTermino": relatorio.horaTermino, "dispositivo": "iOS", "atividades": relatorio.stringAtividades], encoding: URLEncoding.default, headers: nil).validate().responseJSON() { response in
                    if response.result.value != nil {
                        try! self.realm.write {
                            relatorio.salvoNoServidor = "1"
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }

        if self.progressView.progress == 1.0 {
            self.btnUploadManual.isEnabled = true
            self.refresher.isEnabled = true
        }
        
        stopRefresher()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RelatoriosCell
        let relatorio = relatorios[indexPath.row]
        
        var x = 0
        while x < relatorio.arrayAtividades.count {
            x += 1
        }
        
        if x > 12 {
            x = 12
        }
        
        cell.stackViewConstraint.constant = CGFloat(x * 15)
        
        if relatorio.salvoNoServidor == "1" {
            cell.imgEnvioRelatorio.image = #imageLiteral(resourceName: "relatorio_enviado")
            cell.lblEnviado.text = "Enviado"
            cell.lblEnviado.textColor = UIColor.colorWithHex("85A53D")
        } else {
            cell.imgEnvioRelatorio.image = #imageLiteral(resourceName: "relatorio_enviando")
            cell.lblEnviado.text = "Pendente"
            cell.lblEnviado.textColor = UIColor.colorWithHex("E1422C")
        }
        
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.locale = Locale.init(identifier: "pt_BR")
        
        let dateOBJ = dateFormatter.date(from: relatorio.dataInicio)
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        cell.lblDataVisita.text = "\(String(describing: dateFormatter.string(from: dateOBJ!)))"
        cell.lblnomeFazenda.text = relatorio.nomeFazenda
        
        for view in cell.imagensStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        cell.imagensStackView.addArrangedSubview(cell.stackViewSemFotos)
        
        if relatorio.arrayImagens.count == 0 {
            cell.stackViewSemFotos.isHidden = false
        } else {
            cell.stackViewSemFotos.isHidden = true
            
            let item = UILabel()
            
            if relatorio.arrayImagens.count == 1 {
                item.text = "Esta visita contém \(relatorio.arrayImagens.count) foto"
            } else {
                item.text = "Esta visita contém \(relatorio.arrayImagens.count) fotos"
            }
            
            item.font = item.font.withSize(14)
            
            var temImagemSemUpload = false
            for imagem in relatorio.arrayImagens {
                if imagem.salvaNoServidor == "0" {
                    temImagemSemUpload = true
                }
            }
            
            if temImagemSemUpload {
                item.textColor = UIColor.colorWithHex("#E1422C")
            } else {
                item.textColor = UIColor.colorWithHex("#85A53D")
            }
            cell.imagensStackView.addArrangedSubview(item)
        }
        
        for view in cell.stackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        var count = 0
        for x in relatorio.arrayAtividades {
            if count < 12 {
                let item = UILabel()
                item.text = "• \(String(describing: x["descricao"]!))"
                item.font = item.font.withSize(12)
                item.textColor = UIColor.colorWithHex("2B3F33")
                
                cell.stackView.addArrangedSubview(item)
            }
            count += 1
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return relatorios.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width - 16, height: self.collectionView.frame.height/1.75)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: self.collectionView.frame.width, height: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: 8)
    }
}
