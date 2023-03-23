//
//  Character.swift
//  FrenchGameFactory
//
//  Created by Francois Mayeres on 09/03/2023.
//

import Foundation

class Character {
    let characterType: String
    var name: String
    var lifePoint: Int
    let maxLifePoint: Int
    let weapon: Weapon
    
    init(characterType: String, name: String, lifePoint: Int, weapon: Weapon) {
        self.characterType = characterType
        self.name = name
        self.lifePoint = lifePoint
        self.maxLifePoint = lifePoint
        self.weapon = weapon
    }
    
    func getDescription() -> String {
        return "\(characterType) possède \(lifePoint) points de vie. Son arme est : \(weapon.description). Cette arme provoque \(weapon.damage) points de dégâts."
    }
}

    

