//
//  Game.swift
//  FrenchGameFactory
//
//  Created by Francois Mayeres on 09/03/2023.

import Foundation

class Game {
    var players = [Player]()
    var maxCharacters = 3
    
    // DEMARRAGE DU JEUX //
    
    func start() {
        print("FrenchFactoryGame \n")
        createPlayers()
        startBattle()
        showStatistics()
    }
    // Creation des Joueurs //
    
    private func createPlayers() {
        
        // Création tu nombre de Joueurs ( ici 2)  //
        
        for i in 1...2 {
            print("\nBonjour Joueur \(i), quel est le nom du personnage que vous avez choisi ?")
            
            // verification si leurs nom est unique //
            
            var name = ""
            var nameIsUnique = false
            
            while !nameIsUnique || name.isEmpty {
                name = readLine() ?? ""
                name = name.capitalized.trimmingCharacters(in: .whitespacesAndNewlines)
                nameIsUnique = !players.contains(where: { $0.name == name })
            }
            
            print("\nHello \(name) !\n")
            
            // Creation des personnage du Joueur ( nom de chaque classe) //
            
            var characters = [Character]()
            
            for index in 1...3 {
                let charactersToSelect = [Dwarf(), Magus(), Colossus(), Warrior()]
                
                print("Veuillez choisir le personnage numéro \(index)")
                
                for (index, character) in charactersToSelect.enumerated() {
                    print("\(index + 1). \(character.getDescription())")
                }
                
                var selectedCharacter: Character?
                repeat {
                    if let selectedIndex = readLine(), let indexToVerified = Int(selectedIndex), indexToVerified > 0, indexToVerified <= charactersToSelect.count {
                        selectedCharacter = charactersToSelect[indexToVerified - 1]
                    } else {
                        print("Entrez un nombre valide pour sélectionner un personnage:")
                    }
                } while selectedCharacter == nil

                
                print("Vous avez choisi \(selectedCharacter!.characterType). Veuillez lui donner un nom:")
                
                var characterName = ""
                var nameIsUnique = false
                
                while !nameIsUnique || characterName.isEmpty {
                    characterName = (readLine() ?? "").capitalized
                    
                    nameIsUnique = !players.contains(where: { player in
                        player.characters.contains(where: { $0.name == characterName })
                    })
                    
                    if characterName.isEmpty {
                        print("Vous n'avez pas donné de nom. Veuillez en donner un:")
                    } else if !nameIsUnique {
                        print("Le nom existe déjà, veuillez recommencer:")
                    }
                }
                
                selectedCharacter!.name = characterName
                characters.append(selectedCharacter!)
            }
            // Creation du joueur avec ses personnages //
            
            let player = Player(name: name, characters: characters)
            players.append(player)
        }
    }
    
    // Bataille entre les joueurs //
    
    private func startBattle() {
        print("La bataille commence !")
        var turnCounter = 0
        
        while !isGameOver() {
            turnCounter += 1
            print("\nTour \(turnCounter)")
            
            for (playerIndex, player) in players.enumerated() {
                print("\nAu tour du joueur \(playerIndex + 1) (\(player.name)):")
                
                let attacker = selectCharacter(from: player)
                var shouldHeal = false
                
                if attacker is Magus {
                               print("\(attacker.name) est un Magus. Voulez-vous soigner un personnage de votre équipe? (o/n)")
                               if let input = readLine(), input.lowercased() == "o" {
                                   shouldHeal = true
                               }
                           }
                
                print("Choisissez un personnage \(shouldHeal ? "à soigner" : "à attaquer"):")
                let targetPlayerIndex = 1 - playerIndex
                let targetPlayer = players[targetPlayerIndex]
                let target = selectTarget(from: targetPlayer, attacker: attacker, shouldHeal: shouldHeal)
                
                performAttack(attacker: attacker, target: target, shouldHeal: shouldHeal)
            }
        }
    }
    
    
    
    // Selectionne de attaquent pour un joueur //
    
    func selectCharacter(from player: Player) -> Character {
        print("Choisissez un personnage pour attaquer:")
        for (index, character) in player.characters.enumerated() {
            print("\(index + 1). \(character.name) - \(character.getDescription())")
        }
        
        var selectedCharacterIndex: Int?
        repeat {
            if let input = readLine(), let inputNumber = Int(input), inputNumber > 0, inputNumber <= player.characters.count {
                let characterIndex = inputNumber - 1
                if player.characters[characterIndex].lifePoint > 0 {
                    selectedCharacterIndex = characterIndex
                } else {
                    print("Ce personnage est éliminé. Veuillez en choisir un autre:")
                }
            } else {
                print("Entrez un nombre valide pour sélectionner un personnage:")
            }
        } while selectedCharacterIndex == nil
        
        return player.characters[selectedCharacterIndex!]
    }

    

    
    // Selectionne une cible a attaquer pour un joueur //
    
    private func selectTarget(from player: Player, attacker: Character, shouldHeal: Bool) -> Character {
        var selectedTargetIndex: Int?
        repeat {
            if let input = readLine(), let inputNumber = Int(input), inputNumber > 0, inputNumber <= player.characters.count {
                let characterIndex = inputNumber - 1
                if shouldHeal {
                    if player.characters[characterIndex].lifePoint < player.characters[characterIndex].maxLifePoint {
                        selectedTargetIndex = characterIndex
                    } else {
                        print("Ce personnage a déjà tous ses points de vie. Veuillez en choisir un autre:")
                    }
                } else {
                    if player.characters[characterIndex].lifePoint > 0 {
                        selectedTargetIndex = characterIndex
                    } else {
                        print("Ce personnage est éliminé. Veuillez en choisir un autre:")
                    }
                }
            } else {
                print("Entrez un nombre valide pour sélectionner un personnage:")
            }
        } while selectedTargetIndex == nil
        
        return player.characters[selectedTargetIndex!]
    }
    
    

    
    
    
    // verification si la partie est terminée //
    
    private func isGameOver() -> Bool {
        for player in players {
            if player.characters.allSatisfy({ $0.lifePoint <= 0 }) {
                return true
            }
        }
        return false
    }
    
    // Effectue une attaque d'un personnage sur un cible //
    
    private func performAttack(attacker: Character, target: Character, shouldHeal: Bool) {
        if let magus = attacker as? Magus, shouldHeal {
            let healAmount = magus.weapon.damage
            target.lifePoint += healAmount
            print("\(attacker.name) soigne \(target.name) pour \(healAmount) points de vie.")
            if target.lifePoint > target.maxLifePoint {
                target.lifePoint = target.maxLifePoint
            }
        } else {
            let damage = attacker.weapon.damage
            target.lifePoint -= damage
            print("\(attacker.name) attaque \(target.name) et inflige \(damage) points de dégâts.")
            if target.lifePoint <= 0 {
                target.lifePoint = 0
                
                
                print("\(target.name) est éliminé!")
            }
        }
    }
            
            
            
            
            
            // affiche les statistique finales //
            
            func showStatistics() {
                print("\nStatistiques finales:")
                for (index, player) in players.enumerated() {
                    print("\nJoueur \(index + 1): \(player.name)")
                    for character in player.characters {
                        print("\(character.name) - \(character.getDescription())")
                    }
                }
                let winnerIndex = players[0].characters.allSatisfy({ $0.lifePoint <= 0 }) ? 1 : 0
                print("\nFélicitations, Joueur \(winnerIndex + 1) (\(players[winnerIndex].name))! Vous avez gagné la partie!")
            }
            
        }
    
