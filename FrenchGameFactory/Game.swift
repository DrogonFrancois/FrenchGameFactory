//  Game.swift
//  FrenchGameFactory
//
//  Created by Francois Mayeres on 09/03/2023.

import Foundation

class Game {
    var players = [Player]()
    var maxCharacters = 3
    var turnCounter = 0
    
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
            print("\nBonjour Joueur \(i), quel est le nom de l'équipe que vous avez choisi ?")
            
            // verification si leurs nom est unique //
            
            var name = ""
            var nameIsUnique = false
            
            while !nameIsUnique || name.isEmpty {
                name = readLine() ?? ""
                name = name.capitalized.trimmingCharacters(in: .whitespacesAndNewlines)
                nameIsUnique = !players.contains(where: { $0.name == name })
                
                if !nameIsUnique && !name.isEmpty {
                    print("Ce nom de cette équipe existe déjà, veuillez en choisir un autre :")
                }
            }
            
            print("\nHello \(name) !\n")
            
            // Creation des personnage du Joueur ( nom de chaque classe) //
            
            var characters = [Character]()
            var selectedCharactersIndices = Set<Int>()
            
            for index in 1...3 {
                let charactersToSelect = [Dwarf(), Magus(), Colossus(), Warrior()]
                print("Veuillez choisir le combattant numéro \(index)")
                
                // Affichage des personnages disponibles //
                for (index, character) in charactersToSelect.enumerated() {
                    print("\(index + 1). \(character.getDescription())")
                }
                
                // Sélection d'un personnage //
                
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
                        
                        // Attribution d'un nom au personnage sélectionné //
                        
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
                // Ajout du personnage à la liste des personnages du joueur//
                
                selectedCharacter.name = characterName
                characters.append(selectedCharacter)
            }
            
            // Creation du joueur avec ses personnages //
            
            let player = Player(name: name, characters: characters)
            players.append(player)
        }
    }
    
    // Bataille entre les joueurs //
    
    private func startBattle() {
        print("La bataille commence !")
        
        var playerWhoAttack = players[0]
        var attacked = players[1]
        
        while !isGameOver() {
            turnCounter += 1
            print("\nTour \(turnCounter)")
            
            print("\nAu tour de (\(playerWhoAttack.name)):")
            
            // Sélection du personnage attaquant //
            
            let attacker = selectCharacter(from: playerWhoAttack)
            var shouldHeal = false
            
            // Vérification si le personnage attaquant est un Magus et demande si le joueur veut soigner un allié //
            
            if attacker is Magus {
                if canHealCharacter(in: playerWhoAttack) {
                    print("\(attacker.name) est un Magus. Voulez-vous soigner un combattant de votre équipe? (o/n)")
                    if let input = readLine(), input.lowercased() == "o" {
                        shouldHeal = true
                    }
                } else {
                    print("Votre équipe n'a pas besoin de soins.")
                }
            }
            
            // Sélection de la cible //
            
            print("Choisissez un combattant \(shouldHeal ? "à soigner" : "à attaquer"):")
            let target = selectTarget(from: shouldHeal ? playerWhoAttack : attacked, shouldHeal: shouldHeal)
            
            // Exécution de l'attaque ou du soin //
            
            performAttack(attacker: attacker, target: target, shouldHeal: shouldHeal)
            
            swap(&playerWhoAttack, &attacked)
            
            func canHealCharacter(in player: Player) -> Bool {
                return player.characters.contains { character in
                    character.lifePoint < character.maxLifePoint
                }
            }
        }
    }
    
    // Selectionne de attaquent pour un joueur //
    
    func selectCharacter(from player: Player) -> Character {
        print("Choisissez un combattant pour attaquer:")
        for (index, character) in player.characters.enumerated() {
            print("\(index + 1). \(character.name) - \(character.getDescription())")
        }
        // Vérification de la validité de la sélection//
        
        var selectedCharacterIndex: Int?
        repeat {
            if let input = readLine(), let inputNumber = Int(input), inputNumber > 0, inputNumber <= player.characters.count {
                let characterIndex = inputNumber - 1
                if player.characters[characterIndex].lifePoint > 0 {
                    selectedCharacterIndex = characterIndex
                } else {
                    print("Ce combattant est éliminé. Veuillez en choisir un autre:")
                }
            } else {
                print("Entrez un nombre valide pour sélectionner un combattant:")
            }
            
            
        } while selectedCharacterIndex == nil
        
        return player.characters[selectedCharacterIndex!]
    }
    
    // Selectionne une cible a attaquer ou a soignée pour un joueur //
    
    private func selectTarget(from player: Player, shouldHeal: Bool) -> Character {
        for (index, character) in player.characters.enumerated() {
            print("\(index + 1). \(character.name) - \(character.getDescription())")
        }
        
        var selectedTargetIndex: Int?
        repeat {
            if let input = readLine(), let inputNumber = Int(input), inputNumber > 0, inputNumber <= player.characters.count {
                let characterIndex = inputNumber - 1
                if shouldHeal {
                    if player.characters[characterIndex].lifePoint < player.characters[characterIndex].maxLifePoint {
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
    
    // verification si la partie est terminée //
    
    func isGameOver() -> Bool {
        for player in players {
            if player.characters.allSatisfy({ $0.lifePoint <= 0 }) {
                return true
            }
        }
        return false
    }
    
    // Effectue une attaque ou le soin sur un cible //
    
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
        let winnerIndex = players[0].characters.allSatisfy({ $0.lifePoint <= 0 }) ? 1 : 0
        print("\nFélicitations, équipe \(winnerIndex + 1) (\(players[winnerIndex].name))! Vous avez gagné la partie!")
        
        print("\nStatistiques finales:")
        print("Nombre de tours effectués : \(turnCounter)")
        
        for (index, player) in players.enumerated() {
            print("\nJoueur \(index + 1): \(player.name)")
            for character in player.characters {
                
                print("\(character.name) - \(character.getDescription()) - Points de vie : \(character.lifePoint)")
            }
        }
    }
}

