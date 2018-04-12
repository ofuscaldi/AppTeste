//
//  Visita.swift
//  IrrigerCorp
//
//  Created by Rodrigo Fuscaldi on 6/26/17.
//  Copyright © 2017 std1. All rights reserved.
//

import RealmSwift
import Realm

class Visita: Object {
    //inicio
    var idLocal = 0
    @objc dynamic var nomeFazenda: String!
    @objc dynamic var identificador: String!
    @objc dynamic var dataInicio: String!
    @objc dynamic var horaInicio: String!
    @objc dynamic var idFazenda: String!
    @objc dynamic var latitude: String!
    @objc dynamic var longitude: String!
    //etapa 1 e 2
    @objc dynamic var tipoVisita: String!
    var arrayAtividades = List<Atividade>()
    @objc dynamic var stringAtividades: String!
    //etapa 3
    @objc dynamic var tipoObservacao: String!
    @objc dynamic var observacao: String!
    //etapa 4
    var arrayImagens = List<Imagens>()
    var arrayDescricoes = List<Categorias>()
    var arrayObservacoes = List<Observacoes>()
    @objc dynamic var dataTermino: String!
    @objc dynamic var horaTermino: String!
    
    @objc dynamic var salvoNoServidor: String!
    
    
    override static func primaryKey() -> String? {
        return "idLocal"
    }
    
}

class Atividade: Object {
    var descricao: String!
    var id: String!
    
    
}

class Imagens: Object {
    @objc dynamic var imagemCaminho: String!
    @objc dynamic var identificador: String!
    @objc dynamic var identificadorVisita: String!
    @objc dynamic var idAtividade: String!
    @objc dynamic var nome: String!
    @objc dynamic var latitude: String!
    @objc dynamic var longitude: String!
    @objc dynamic var observacao: String!
    @objc dynamic var salvaNoServidor: String!
    @objc dynamic var data: String!
    @objc dynamic var hora: String!
}

class Categorias: Object {
    var categoria = ""
    
}

class Observacoes: Object {
    var observacao = ""
    
}
