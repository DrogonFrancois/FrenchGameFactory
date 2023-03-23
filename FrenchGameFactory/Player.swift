//
//  Player.swift
//  FrenchGameFactory
//
//  Created by Francois Mayeres on 09/03/2023.
//

import Foundation

class Player {
    var name: String 
    var characters: [Character]
    
    
    init(name: String, characters: [Character]) {
        self.name = name
        self.characters = characters
    }
}
