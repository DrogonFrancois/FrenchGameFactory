//
//  Player.swift
//  FrenchGameFactory
//
//  Created by Francois Mayeres on 09/03/2023.
//

import Foundation

class Player {
    var name: String // nom du joueur
    var characters: [Character] // Les personnage du joueur sous forme de tableau
    
    // Initialisation de la classe Player
    
    init(name: String, characters: [Character]) {
        self.name = name
        self.characters = characters
    }
}
