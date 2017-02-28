//
//  GameSession.swift
//  French Belote
//
//  Created by Stefan Auvergne on 12/4/16.
//  Copyright © 2016 com.example. All rights reserved.
//

import Foundation
import UIKit

class GameSession{
    
    var atoutSelected = ""
    var playedCards = [Card]()
    var tempWinningCard:Card!
    var tempPoints = 0
    
    var team1Score = 0
    var team2Score = 0
    
    
    let player1 = Player(playerNum: 1)
    let player2 = Player(playerNum: 2)
    let player3 = Player(playerNum: 3)
    let player4 = Player(playerNum: 4)
    
    func playCard(card:Card){
        playedCards.append(card)
        
    }
    
    func getPlayedCards() -> [Card]{
        return playedCards
    }
    
    func setAtout(atout:String){
        atoutSelected = atout
    }
    
    func compareTwoCards(card1:Card, card2:Card) -> Card{
        
        //BOTH ATOUT
        if(card1.suit.rawValue == atoutSelected) && (card2.suit.rawValue == atoutSelected){
            if(card1.rank.cardsValueAtout() > card2.rank.cardsValueAtout()){
                tempWinningCard = card1
            }else{
                tempWinningCard = card2
            }
            //1st CARD ATOUT
        }else if (card1.suit.rawValue == atoutSelected){
            tempWinningCard = card1
            
            //2nd CARD ATOUT
        }else if(card2.suit.rawValue == atoutSelected){
            tempWinningCard = card2
            
        }else{
            //BOTH NON ATOUT
            let winningSuit = card1.suit.rawValue
            if card2.suit.rawValue != winningSuit{
                tempWinningCard = card1
            }else if card2.suit.rawValue == winningSuit{
                if(card1.rank.cardsValueNonAtout() > card2.rank.cardsValueNonAtout()){
                    tempWinningCard = card1
                }else{
                    tempWinningCard = card2
                }
            }
            
        }
        
        return tempWinningCard
    }
    
    func comparePlayedCards() -> Player{
        var index = 1
        var playerWinnerNumber = 0
        let image = UIImage()
        
        var tempLeader = compareTwoCards(card1: playedCards[0], card2: playedCards[1])
        print("Winner ", tempLeader.rank, tempLeader.suit)
        tempLeader = compareTwoCards(card1: tempLeader, card2: playedCards[2])
        print("Winner ", tempLeader.rank, tempLeader.suit)
        tempLeader = compareTwoCards(card1: tempLeader, card2: playedCards[3])
        print("Winner ", tempLeader.rank, tempLeader.suit)
        
        for card in playedCards{
            if (card.rank.rawValue == tempLeader.rank.rawValue && card.suit.rawValue == tempLeader.suit.rawValue){
                playerWinnerNumber = index
            }
            index += 1
        }
        
        if player1.playerNum == playerWinnerNumber{
            return player1
        }else if player2.playerNum == playerWinnerNumber{
            return player2
        }else if player3.playerNum == playerWinnerNumber{
            return player3
        }else{
            return player4
        }
    }
    
    func checkNextCard(card:Card, player:Player){
        let tempCardSuit = card.suit.rawValue
        
        if(player.playerNum == 1){
            
            player2.playableCards.removeAll()
            if (card.suit.rawValue == atoutSelected){
                
                
                for index in 0...player2.cardsInHand.count-1{
                    if (player2.cardsInHand[index].suit.rawValue == atoutSelected){
                        player2.playableCards.append(player2.cardsInHand[index])
                    }
                }
                
                if (player2.playableCards.count == 0){
                    player2.playableCards = player2.cardsInHand
                }
            }else{
                for index in 0...player2.cardsInHand.count-1{
                    if player2.cardsInHand[index].suit.rawValue == tempCardSuit{
                        player2.playableCards.append(player2.cardsInHand[index])
                    }
                }
                
                if player2.playableCards.count == 0{
                    for index in 0...player2.cardsInHand.count-1{
                        if player2.cardsInHand[index].suit.rawValue == atoutSelected{
                            player2.playableCards.append(player2.cardsInHand[index])
                        }
                    }
                }
                
                if player2.playableCards.count == 0{
                      player2.playableCards = player2.cardsInHand
                }
            }
        }else if(player.playerNum == 2){
            player3.playableCards.removeAll()
            if (card.suit.rawValue == atoutSelected){
                for index in 0...player3.cardsInHand.count-1{
                    if (player3.cardsInHand[index].suit.rawValue == atoutSelected){
                        player3.playableCards.append(player3.cardsInHand[index])
                    }
                }
                
                if (player3.playableCards.count == 0){
                    player3.playableCards = player3.cardsInHand
                }
            }else{
                for index in 0...player3.cardsInHand.count-1{
                    if player3.cardsInHand[index].suit.rawValue == tempCardSuit{
                        player3.playableCards.append(player3.cardsInHand[index])
                    }
                }
                
                if player3.playableCards.count == 0{
                    for index in 0...player3.cardsInHand.count-1{
                        if player3.cardsInHand[index].suit.rawValue == atoutSelected{
                            player3.playableCards.append(player3.cardsInHand[index])
                        }
                    }
                }
                
                if player3.playableCards.count == 0{
                    player3.playableCards = player3.cardsInHand
                }
            }
        }else if(player.playerNum == 3){
            player4.playableCards.removeAll()
            if (card.suit.rawValue == atoutSelected){
                for index in 0...player4.cardsInHand.count-1{
                    if player4.cardsInHand[index].suit.rawValue == atoutSelected{
                        player4.playableCards.append(player4.cardsInHand[index])
                    }
                }
                if (player4.playableCards.count == 0){
                    player4.playableCards = player4.cardsInHand
                }
            }else{
                for index in 0...player4.cardsInHand.count-1{
                    if player4.cardsInHand[index].suit.rawValue == tempCardSuit{
                        player4.playableCards.append(player4.cardsInHand[index])
                    }
                }
                
                if player4.playableCards.count == 0{
                    for index in 0...player4.cardsInHand.count-1{
                        if player4.cardsInHand[index].suit.rawValue == atoutSelected{
                            player4.playableCards.append(player4.cardsInHand[index])
                        }
                    }
                }
                
                if player4.playableCards.count == 0{
                    player4.playableCards = player4.cardsInHand
                }
            }
        }else if player.playerNum == 4{
            player4.playableCards.removeAll()
            if (card.suit.rawValue == atoutSelected){
                for index in 0...player1.cardsInHand.count-1{
                    if (player1.cardsInHand[index].suit.rawValue == atoutSelected){
                        player1.playableCards.append(card)
                    }
                }
                if (player1.playableCards.count == 0){
                    player1.playableCards = player1.cardsInHand
                }
            }else{
                for index in 0...player1.cardsInHand.count-1{
                    if player1.cardsInHand[index].suit.rawValue == tempCardSuit{
                        player1.playableCards.append(player1.cardsInHand[index])
                    }
                }
                
                if player1.playableCards.count == 0{
                    for index in 0...player1.cardsInHand.count-1{
                        if player1.cardsInHand[index].suit.rawValue == atoutSelected{
                            player1.playableCards.append(player1.cardsInHand[index])
                        }
                    }
                }
                
                if player1.playableCards.count == 0{
                    player1.playableCards = player1.cardsInHand
                }
            }
        }
    }
    
    func calculateScore() -> Int{
        for card in playedCards{
            if card.suit.rawValue == atoutSelected{
                tempPoints = tempPoints + card.rank.cardsValueAtout()
            }else{
                tempPoints = tempPoints + card.rank.cardsValueNonAtout()
            }
        }
        return tempPoints
    }
}

