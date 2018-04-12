//
//  Fazenda.swift
//  IrrigerCorp
//
//  Created by Rodrigo Fuscaldi on 7/12/17.
//  Copyright © 2017 std1. All rights reserved.
//

import Realm
import RealmSwift

class Fazenda: Object {
    
    @objc dynamic var idFazenda: String!
    @objc dynamic var nome: String!
    @objc dynamic var cidade: String!
    @objc dynamic var estado: String!
    @objc dynamic var latitude: String!
    @objc dynamic var longitude: String!
}
