//
//  Colossus.swift
//  FrenchGameFactory
//
//  Created by Francois Mayeres on 09/03/2023.
//

import Foundation

class Colossus: Character {
    
    init() {
        super.init(characterType: "Colossus", name: "", lifePoint: 200, weapon: Sword())
    }
}


