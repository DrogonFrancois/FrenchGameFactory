//
//  Weapon.swift
//  FrenchGameFactory
//
//  Created by Francois Mayeres on 09/03/2023.
//

import Foundation

class Weapon {
    var damage: Int
    var description: String
    
    init(damage: Int, description: String) {
        self.damage = damage
        self.description = description
    }
}
