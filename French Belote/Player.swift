//
//  Player.swift
//  French Belote
//
//  Created by Stefan Auvergne on 12/4/16.
//  Copyright © 2016 com.example. All rights reserved.
//

import Foundation

class Player{
    
    var cardsInHand = [Card]()
    var playerNum = 0
    var playableCards = [Card]()
    var uid:String!
    var username:String!
    
    init(playerNum:Int){
        self.playerNum = playerNum
    }
    
    func removeCardFromHand(player:Player, passedCard:Card, deck:[Card]) -> [Card]{
        var index = 0
        var deckIndex = 0
        
        for card in player.cardsInHand{
            if ((card.rank == passedCard.rank) && (card.suit.rawValue == passedCard.suit.rawValue)){
                player.cardsInHand.remove(at: index)
            }
             index += 1
        }
        var updatedDeck = deck
        for card in deck{
            if ((card.rank == passedCard.rank) && (card.suit.rawValue == passedCard.suit.rawValue)){
                updatedDeck.remove(at: deckIndex)
            }
            deckIndex += 1

        }
        return updatedDeck
        
    }
}
