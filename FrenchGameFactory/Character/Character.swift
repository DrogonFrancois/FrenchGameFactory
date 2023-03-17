//
//  Character.swift
//  FrenchGameFactory
//
//  Created by Francois Mayeres on 09/03/2023.
//

import Foundation

class Character {
    let characterType: String // Type du personnage
    var name: String // Type du personnage
    var lifePoint: Int // Type du personnage
    let maxLifePoint: Int // Points de vie maximum du personnage
    let weapon: Weapon // Arme du personnage
    
    // Initialisation de la classe Character
    
    init(characterType: String, name: String, lifePoint: Int, weapon: Weapon) {
        self.characterType = characterType
        self.name = name
        self.lifePoint = lifePoint
        self.maxLifePoint = lifePoint
        self.weapon = weapon
    }
    
    // Méthode pour obtenir une description du personnage
    
    func getDescription() -> String {
        return "\(characterType) possède \(lifePoint) points de vie. Son arme est : \(weapon.description). Cette arme provoque \(weapon.damage) points de dégâts."
    }
}

