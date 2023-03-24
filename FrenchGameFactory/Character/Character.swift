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
    
    func attack(character: Character) {
        let damage = weapon.damage
        character.lifePoint -= damage
        print("\(name) attaque \(character.name) et inflige \(damage) points de dégâts.")
        if character.lifePoint <= 0 {
            character.lifePoint = 0
            print("\(character.name) est éliminé!")
        }
    }
    
    func getDescription() -> String {
        return "\(characterType) possède \(lifePoint) points de vie. Son arme est : \(weapon.description). Cette arme provoque \(weapon.damage) points de dégâts."
    }
}

    

