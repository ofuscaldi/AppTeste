//
//  BarraLateralViewController.swift
//  IrrigerCorp
//
//  Created by Std1 on 06/09/17.
//  Copyright © 2017 std1. All rights reserved.
//

import UIKit

class BarraLateralViewController: UIViewController {

    @IBOutlet weak var imgIcone: UIImageView!

    override func viewDidLoad() {
        
        imgIcone.layer.cornerRadius = imgIcone.layer.frame.width/2
        imgIcone.clipsToBounds = true
    }
    
    @IBAction func btnSair(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "logado")
        
        UserDefaults.standard.removeObject(forKey: "idUsuario")
        UserDefaults.standard.removeObject(forKey: "tipoUsuario")
        UserDefaults.standard.removeObject(forKey: "todasFazendas")
        
        UserDefaults.standard.synchronize()
        
        performSegue(withIdentifier:"logoutSucesso", sender: self)
    }
    



}
