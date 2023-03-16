//
//  Weapon.swift
//  FrenchGameFactory
//
//  Created by Francois Mayeres on 09/03/2023.
//

import Foundation

class Weapon {
    var damage: Int // Degat infligé par l'arme
    var description: String // Description de l'arme
    
    // Initialisateur de la classe Weapon
    
    init(damage: Int, description: String) {
        self.damage = damage
        self.description = description
    }
}
