//
//  Magus.swift
//  FrenchGameFactory
//
//  Created by Francois Mayeres on 09/03/2023.
//

import Foundation

class Magus: Character {
    let healingPower: Int
    
    init(healingPower: Int = 50) {
        self.healingPower = healingPower
        super.init(characterType: "Magus", name: "", lifePoint: 200, weapon: Stick())
    }
    
    func heal(target: Character) {
        target.lifePoint += healingPower
        if target.lifePoint > target.maxLifePoint {
            target.lifePoint = target.maxLifePoint
        }
        print("\(name) a soigné \(target.name) pour \(healingPower) points de vie.")
    }
    
}



