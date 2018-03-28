//
//  Etapa2ViewController.swift
//  IrrigerCorp
//
//  Created by Rodrigo Fuscaldi on 6/7/17.
//  Copyright © 2017 std1. All rights reserved.
//

import UIKit
import ColorWithHex
import RealmSwift

class Etapa2ViewController: UIViewController {
    
    var idLocal = UserDefaults.standard.object(forKey: "idLocal") as? Int ?? 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnProximo: UIButton!
    
    //Vem da Etapa 1
    var nomeFazenda: String!
    var idFazenda: String!
    var latitude: String!
    var longitude: String!
    var cidadeEstado: String!
    
    var horaInicio: String!
    var identificador: String!
    var dataInicio: String!
    var tipoVisita: String!
    var arrayAtividades = List<Atividade>()
    var stringAtividades: String!
    
    var idsEscolhidos = [String]()
    var itensEscolhidos: [String] = []
    var arraySelectedItens = NSMutableArray()
    var arraySelecionado = [String]()
    let itensTabelaImplantacao = ["Configuração e acesso ao sistema", "Configuração de partes técnicas", "Testes físico hídricos do solo", "Treinamento da equipe da fazenda", "Levantamento das contas de energia", "Aferição de Equipamentos de Irrigação:",
                                  "Aferição de pressão", "Levantamento mapa de bocais", "Levantamento espaçamento", "Aferição de velocidade de deslocamento", "Aferição de tensão e amperagem", "Aferição de RPM do motor Diesel"]
    
    let itensTabelaAcompanhamento = ["Checagem do desenvolvimento da cultura", "Checagem de umidade", "Checagem do balanço hídrico", "Análise de risco/plantio", "Ajustes na configuração do solo", "Ajustes na Configuração da Cultura:", "Kc/Ks/Kl", "Profundidade radicular", "Duração da fase", "Ajustes na configuração do equipamento", "Estratégia/planejamento de irrigação", "Estudo/aferição das contas de energia", "Apresentação de relatório de safra", "Apresentação de relatório anual", "Treinamento de equipe da fazenda", "Verificação de ajustes de solicitações",
                                     "Checagens Periódicas de Operação:", "Aferição de pressão", "Levantamento mapa de bocais", "Levantamento espaçamento", "Aferição de velocidade de deslocamento", "Aferição de tensão e amperagem", "Aferição de RPM do motor Diesel"]
    
    override func viewDidLoad() {
        //ID LOCAL
        idLocal += 1
        UserDefaults.standard.set(idLocal, forKey: "idLocal")
        automaticallyAdjustsScrollViewInsets = false
        
        iniciarVisita()
        arrayImagens.removeAll()
        design()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        arrayAtividades.removeAll()
        tableView.reloadData()
    }
    
    func design() {
        tableView.separatorColor = UIColor.clear
    }
    
    func iniciarVisita() {
        
        let hora = DateFormatter()
        hora.dateFormat = "hh:mm:ss"
        let horaInicio = hora.string(from: Date())
        
        let data = DateFormatter()
        data.dateFormat = "yyyy/MM/dd"
        let dataInicio = data.string(from: Date())
        
        let identificador = DateFormatter()
        identificador.dateFormat = "yyyyMMddhhmmss\(usuario.idUsuario)"
        let identificadorString = identificador.string(from: Date())
        
        self.identificador = identificadorString
        self.dataInicio = dataInicio
        self.horaInicio = horaInicio
        
        if trabalho == "Implantação" {
            arraySelecionado = itensTabelaImplantacao
            self.tableView.reloadData()
        } else if trabalho == "Acompanhamento" {
            arraySelecionado = itensTabelaAcompanhamento
            self.tableView.reloadData()
        }
    }
    
    func testarJSON() {
        var ids = [Any]()
        
        for index in idsEscolhidos {
            let x = ["id": index] as Any
            ids.append(x)
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject:ids, options:[])
            self.stringAtividades = String(data: data, encoding: String.Encoding.utf8)!
        } catch {
            
        }
        
    }
    
    @IBAction func btnProximo(_ sender: UIButton) {
        
        testarJSON()
        
        if arraySelectedItens.count != 0 {
            var index = 0
            for item in itensEscolhidos {
                let atividade = Atividade()
                atividade.descricao = item
                atividade.id = idsEscolhidos[index]
                
                self.arrayAtividades.append(atividade)
                
                index += 1
            }
            performSegue(withIdentifier: "etapa23", sender: self)
        }
        else {
            let alert = UIAlertController(title: "Etapa obrigatória", message: "Por favor, selecione pelo menos um item da tabela acima para prosseguir.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "etapa23" {
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
            proximaEtapa.cidadeEstado = self.cidadeEstado
        }
    }
}

extension Etapa2ViewController: UITableViewDelegate,  UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Etapa2Cell
        let item = arraySelecionado[indexPath.row]
        cell.contentView.backgroundColor = UIColor.colorWithHex("FFFEF1")
        cell.backgroundColor = UIColor.colorWithHex("FFFEF1")
        cell.lblItem.text = item
        
        if item == "Ajustes na Configuração da Cultura:" || cell.lblItem.text == "Checagens Periódicas de Operação:" || cell.lblItem.text == "Aferição de Equipamentos de Irrigação:" {
            cell.imgCheckmark.image = nil
            cell.lblItem.font = UIFont.boldSystemFont(ofSize: 15)
            cell.constraintEsquerdaLbl.constant = 0
        } else {
            if arraySelectedItens.contains(indexPath.row) {
                cell.imgCheckmark.image = #imageLiteral(resourceName: "botaoCirculoMarcado")
            } else {
                cell.imgCheckmark.image = #imageLiteral(resourceName: "botaoCirculo")
            }
            cell.lblItem.font = UIFont.systemFont(ofSize: 13)
            cell.constraintEsquerdaLbl.constant = 51
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arraySelecionado.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! Etapa2Cell
        let item = arraySelecionado[indexPath.row]
        
        cell.contentView.backgroundColor = UIColor.colorWithHex("FFFEF1")
        cell.backgroundColor = UIColor.colorWithHex("FFFEF1")
        
        let index = indexPath.row
        
        if trabalho == "Implantação" { //Implantacao
            if item == "Aferição de Equipamento de Irrigação:" {
                cell.imgCheckmark.image = nil
            } else {
                if arraySelectedItens .contains(index) {
                    arraySelectedItens.remove(index)
                    cell.imgCheckmark.image = #imageLiteral(resourceName: "botaoCirculo")
                    for itens in itensEscolhidos {
                        if itens == item {
                            itensEscolhidos = itensEscolhidos.filter{$0 != itens}
                            print(itensEscolhidos)
                        }
                    }
                } else {
                    arraySelectedItens .add(index)
                    cell.imgCheckmark.image = #imageLiteral(resourceName: "botaoCirculoMarcado")
                    itensEscolhidos.append(itensTabelaImplantacao[indexPath.row])
                    print("ID: \(1 + indexPath.row)")
                    idsEscolhidos.append("\(1 + indexPath.row)")
                    
                }
            }
        } else {  //Detalhamento
            if item == "Ajustes na Configuração da Cultura:" || item == "Checagens Periódicas de Operação:" {
                cell.imgCheckmark.image = nil
            } else {
                if arraySelectedItens .contains(index) {
                    arraySelectedItens.remove(index)
                    cell.imgCheckmark.image = #imageLiteral(resourceName: "botaoCirculo")
                    
                    for itens in itensEscolhidos {
                        if itens == item {
                            itensEscolhidos = itensEscolhidos.filter{$0 != itens}
                            print(itensEscolhidos)
                        }
                    }
                } else {
                    arraySelectedItens .add(index)
                    cell.imgCheckmark.image = #imageLiteral(resourceName: "botaoCirculoMarcado")
                    itensEscolhidos.append(itensTabelaAcompanhamento[indexPath.row])
                    print("ID: \(13 + indexPath.row)")
                    idsEscolhidos.append("\(13 + indexPath.row)")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.colorWithHex("FFFEF1")
        cell?.backgroundColor = UIColor.colorWithHex("FFFEF1")
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.colorWithHex("FFFEF1")
        cell?.backgroundColor = UIColor.colorWithHex("FFFEF1")
    }
}
