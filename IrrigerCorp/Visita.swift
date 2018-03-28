//
//  Visita.swift
//  IrrigerCorp
//
//  Created by Rodrigo Fuscaldi on 6/26/17.
//  Copyright © 2017 std1. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Visita: Object {
    //inicio
    var idLocal = 0
    dynamic var nomeFazenda: String!
    dynamic var identificador: String!
    dynamic var dataInicio: String!
    dynamic var horaInicio: String!
    dynamic var idFazenda: String!
    dynamic var latitude: String!
    dynamic var longitude: String!
    //etapa 1 e 2
    dynamic var tipoVisita: String!
    var arrayAtividades = List<Atividade>()
    dynamic var stringAtividades: String!
    //etapa 3
    dynamic var tipoObservacao: String!
    dynamic var observacao: String!
    //etapa 4
    var arrayImagens = List<Imagens>()
    var arrayDescricoes = List<Categorias>()
    var arrayObservacoes = List<Observacoes>()
    dynamic var dataTermino: String!
    dynamic var horaTermino: String!
    
    dynamic var salvoNoServidor: String!
    
    
    override static func primaryKey() -> String? {
        return "idLocal"
    }
    
}

class Atividade: Object {
    var descricao: String!
    var id: String!
    
    
}

class Imagens: Object {
    dynamic var imagemCaminho: String!
    dynamic var identificador: String!
    dynamic var identificadorVisita: String!
    dynamic var idAtividade: String!
    dynamic var nome: String!
    dynamic var latitude: String!
    dynamic var longitude: String!
    dynamic var observacao: String!
    dynamic var salvaNoServidor: String!
    dynamic var data: String!
    dynamic var hora: String!
}

class Categorias: Object {
    var categoria = ""
    
}

class Observacoes: Object {
    var observacao = ""
    
}
