//
//  Fazenda.swift
//  IrrigerCorp
//
//  Created by Rodrigo Fuscaldi on 7/12/17.
//  Copyright © 2017 std1. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Fazenda: Object {
    
    dynamic var idFazenda: String!
    dynamic var nome: String!
    dynamic var cidade: String!
    dynamic var estado: String!
    dynamic var latitude: String!
    dynamic var longitude: String!
    
}
