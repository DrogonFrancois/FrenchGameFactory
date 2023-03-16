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
                
// Selectionner un Personnage //

                var selectedCharacter: Character?
                repeat {
                    if let selectedIndex = readLine(), let indexToVerified = Int(selectedIndex), indexToVerified > 0, indexToVerified <= charactersToSelect.count {
                        selectedCharacter = charactersToSelect[indexToVerified - 1]
                    } else {
                        print("Entrez un nombre valide pour sélectionner un personnage:")
                    }
                } while selectedCharacter == nil
                
// Donne un nom au personnage sélectionné //

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
    
// Commence la bataille entre les joueurs //

    func startBattle() {
        var currentPlayerIndex = 0
        while !isGameOver() {
            let currentPlayer = players[currentPlayerIndex]
            let opponentPlayer = players[1 - currentPlayerIndex]
            print("\n\(currentPlayer.name), c'est à votre tour de jouer !")
            let attacker = selectAttacker(for: currentPlayer)
            let target = selectTarget(for: opponentPlayer)
            performAttack(attacker: attacker, target: target)
            currentPlayerIndex = 1 - currentPlayerIndex
        }
        showStatistics()
    }
    
// Selectionne l'attaquent pour un joueur //

    private func selectAttacker(for player: Player) -> Character {
        print("\(player.name), choisissez un personnage pour attaquer:")
        for (index, character) in player.characters.enumerated() {
            if character.lifePoint > 0 {
                print("\(index + 1). \(character.name) - \(character.getDescription())")
            }
        }
        
// Selectionne un personnage Attaquant //

        var selectedAttackerIndex: Int?
        repeat {
            if let input = readLine(), let inputNumber = Int(input), inputNumber > 0, inputNumber <= player.characters.count {
                let characterIndex = inputNumber - 1
                if player.characters[characterIndex].lifePoint > 0 {
                    selectedAttackerIndex = characterIndex
                } else {
                    print("Ce personnage est éliminé. Veuillez en choisir un autre:")
                }
            } else {
                print("Entrez un nombre valide pour sélectionner un personnage:")
            }
        } while selectedAttackerIndex == nil

        return player.characters[selectedAttackerIndex!]
    }

// Selectionne une cible a attaquer pour un joueur //
    
    private func selectTarget(for player: Player) -> Character {
        print("\(player.name), choisissez un personnage à attaquer :")
        for (index, character) in player.characters.enumerated() {
            if character.lifePoint > 0 {
                print("\(index + 1). \(character.name) - \(character.getDescription())")
            }
        }

// Selectionne un cible a attaquer //
        
        
        var selectedTargetIndex: Int?
        repeat {
            if let input = readLine(), let inputNumber = Int(input), inputNumber > 0, inputNumber <= player.characters.count {
                let characterIndex = inputNumber - 1
                if player.characters[characterIndex].lifePoint > 0 {
                    selectedTargetIndex = characterIndex
                } else {
                    print("Ce personnage est éliminé. Veuillez en choisir un autre:")
                }
            } else {
                print("Entrez un nombre valide pour sélectionner un personnage:")
            }
        } while selectedTargetIndex == nil

        return player.characters[selectedTargetIndex!]
    }
    
// verifie si la partie est terminée //

    private func isGameOver() -> Bool {
        for player in players {
            if player.characters.allSatisfy({ $0.lifePoint <= 0 }) {
                return true
            }
        }
        return false
    }

// Effectue une attaque d'un personnage sur un cible //
    
    
    private func performAttack(attacker: Character, target: Character) {
        target.lifePoint -= attacker.weapon.damage
        if target.lifePoint <= 0 {
            target.lifePoint = 0
            print("\(attacker.name) a attaqué \(target.name) et lui a infligé \(attacker.weapon.damage) points de dégâts. \(target.name) est éliminé.")
        } else {
            print("\(attacker.name) a attaqué \(target.name) et lui a infligé \(attacker.weapon.damage) points de dégâts. Il reste \(target.lifePoint) points de vie à \(target.name).")
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
