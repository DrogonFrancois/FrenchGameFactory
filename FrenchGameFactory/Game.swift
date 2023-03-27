//
//  Game.swift
//  FrenchGameFactory
//
//  Created by Francois Mayeres on 09/03/2023.

import Foundation

class Game {
    
    // MAJ + CTRL = Sélection multiple (curseurs)
    private var players = [Player]()
    private var maxCharacters = 3
    private var turnCounter = 0
    
    // STARTING THE GAME //
    
    func start() {
        print("FrenchFactoryGame \n")
        createPlayers()
        startBattle()
        showStatistics()
    }
    
    // MARK: - Create Players
    
    private func createPlayers() {
        
        // Create the number of players (here 2) //
        
        for i in 1...2 {
            print("\nBonjour Joueur \(i), quel est le nom de l'équipe que vous avez choisi ?")
            
            // check if their name is unique //
            
            var name = ""
            var nameIsUnique = false
            
            while !nameIsUnique || name.isEmpty {
                name = readLine() ?? ""
                name = name.capitalized.trimmingCharacters(in: .whitespacesAndNewlines)
                nameIsUnique = !players.contains(where: { $0.name == name })
                
                if name.isEmpty {
                    print("Le nom de l'équipe ne peut être vide, veuillez commencer:")
                }
                
                if !nameIsUnique {
                    print("Ce nom de cette équipe existe déjà, veuillez en choisir un autre :")
                }
            }
            
            print("\nHello \(name) !\n")
            
            // Creation of the player's character (name of each class) //
            var characters = [Character]()
            var selectedCharactersIndices = Set<Int>()
            
            for index in 1...3 {
                let charactersToSelect = [Dwarf(), Magus(), Colossus(), Warrior()]
                print("Veuillez choisir le combattant numéro \(index)")
                
                // Display of available characters //
                for (index, character) in charactersToSelect.enumerated() {
                    print("\(index + 1). \(character.getDescription())")
                }
                
                // Select a character //
                
                var selectedCharacter: Character?
                repeat {
                    if let selectedIndex = readLine(), let indexToVerified = Int(selectedIndex), indexToVerified > 0, indexToVerified <= charactersToSelect.count {
                        if !selectedCharactersIndices.contains(indexToVerified - 1) {
                            selectedCharacter = charactersToSelect[indexToVerified - 1]
                            selectedCharactersIndices.insert(indexToVerified - 1)
                        } else {
                            print("Vous avez déjà choisi ce combattant. Veuillez en choisir un autre :")
                        }
                    } else {
                        
                        // Assign a name to the selected character //
                        
                        print("Entrez un nombre valide pour sélectionner un combattant:")
                    }
                } while selectedCharacter == nil
                
                guard let selectedCharacter else { return }
                
                print("Vous avez choisi \(selectedCharacter.characterType). Veuillez lui donner un nom:")
                
                var characterName = ""
                var nameIsUnique = false
                
                while !nameIsUnique || characterName.isEmpty {
                    characterName = (readLine() ?? "").capitalized
                    
                    let nameIsUniqueAmongMyCharacters = !characters.contains(where: { $0.name == characterName })
                    let nameIsUniqueAmongOtherPlayersCharacters = !players.contains(where: { player in
                        player.characters.contains(where: { $0.name == characterName })
                    })
                    
                    nameIsUnique = nameIsUniqueAmongMyCharacters && nameIsUniqueAmongOtherPlayersCharacters
                    
                    if characterName.isEmpty {
                        print("Vous n'avez pas donné de nom. Veuillez en donner un:")
                    } else if !nameIsUnique {
                        print("Le nom existe déjà, veuillez recommencer:")
                    }
                }
                // Add the character to the player's character list//
                
                selectedCharacter.name = characterName
                characters.append(selectedCharacter)
            }
            
            // Creation of the player with his characters //
            
            let player = Player(name: name, characters: characters)
            players.append(player)
        }
    }
    
    // MARK: - Start Battle
    // Battle between the players //
    private func startBattle() {
        print("La bataille commence !")
        
        var playerWhoAttack = players[0]
        var attacked = players[1]
        
        while !isGameOver() {
            turnCounter += 1
            print("\nTour \(turnCounter)")
            
            print("\nAu tour de (\(playerWhoAttack.name)):")
            print("Choisissez un combattant pour attaquer")
            // Selection of the attacking character //
            
            let attacker = getCharacter(from: playerWhoAttack)
            
            
            // Check if the attacking character is a Magus and ask if the player wants to heal an ally //
            let canHealCharacter = playerWhoAttack.characters.contains { character in
                character.lifePoint < character.maxLifePoint && character.lifePoint > 0
            }
            
            if let magus = attacker as? Magus, canHealCharacter {
                print("\(attacker.name) est un Magus. Voulez-vous soigner un combattant de votre équipe? (o/n)")
                
                if let input = readLine(), input.lowercased() == "o" {
                    var characterToHeal: Character
                    repeat {
                        print("Choisissez un combattant à soigner :")
                        characterToHeal = getCharacter(from: playerWhoAttack, toHeal: true)
                        if characterToHeal.lifePoint >= characterToHeal.maxLifePoint {
                            print("Ce combattant a déjà tous ses points de vie ou est éliminé. Veuillez en choisir un autre:")
                        }
                    } while characterToHeal.lifePoint >= characterToHeal.maxLifePoint
                    
                    magus.heal(target: characterToHeal)
                    
                    swap(&playerWhoAttack, &attacked)
                    continue
                }
            }
            
            print("Choisissez un combattant à attaquer")
            let target = getCharacter(from: attacked)
            
            // Execution of the attack or treatment //
            
            attacker.attack(character: target)
            
            swap(&playerWhoAttack, &attacked)
        }
    }
    
    // MARK: - Show Statistics
    // displays the final statistics //
    
    private func showStatistics() {
        let winnerIndex = players[0].characters.allSatisfy({ $0.lifePoint <= 0 }) ? 1 : 0
        print("\nFélicitations, équipe \(winnerIndex + 1) (\(players[winnerIndex].name))! Vous avez gagné la partie!")
        
        print("\nStatistiques finales:")
        print("Nombre de tours effectués : \(turnCounter)")
        
        for (index, player) in players.enumerated() {
            print("\nJoueur \(index + 1): \(player.name)")
            for character in player.characters {
                
                print("\(character.name) - \(character.getDescription())")
            }
        }
    }
}

// MARK: - Convenience Methods

extension Game {
    // Select a character depending of the player - toHeal or not //
    
    private func getCharacter(from player: Player, toHeal: Bool = false) -> Character {
        for (index, character) in player.characters.enumerated() {
            print("\(index + 1). \(character.name) - \(character.getDescription())")
        }
        
        var selectedTargetIndex: Int?
        repeat {
            if let input = readLine(), let inputNumber = Int(input), inputNumber > 0, inputNumber <= player.characters.count {
                let characterIndex = inputNumber - 1
                if toHeal {
                    
                    if player.characters[characterIndex].lifePoint < player.characters[characterIndex].maxLifePoint && player.characters[characterIndex].lifePoint > 0 {
                        selectedTargetIndex = characterIndex
                    } else {
                        print("Ce combatant a déjà tous ses points de vie. Veuillez en choisir un autre:")
                    }
                } else {
                    if player.characters[characterIndex].lifePoint > 0 {
                        selectedTargetIndex = characterIndex
                    } else {
                        print("Ce combatant est éliminé. Veuillez en choisir un autre:")
                    }
                }
            } else {
                print("Entrez un nombre valide pour sélectionner un combattant:")
            }
        } while selectedTargetIndex == nil
        
        return player.characters[selectedTargetIndex!]
    }
    
    // check if the game is over //
    
    private func isGameOver() -> Bool {
        for player in players {
            if player.characters.allSatisfy({ $0.lifePoint <= 0 }) {
                return true
            }
        }
        return false
    }
}

