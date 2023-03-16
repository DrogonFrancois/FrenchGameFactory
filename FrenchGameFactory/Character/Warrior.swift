//
//  Warrior.swift
//  FrenchGameFactory
//
//  Created by Francois Mayeres on 09/03/2023.
//

import Foundation

class Warrior: Character {
    
    init() {
        super.init(characterType: "Warrior", name: "", lifePoint: 150, weapon: Axe())
    }
}


