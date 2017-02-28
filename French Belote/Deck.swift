//
//  Deck.swift
//  French Belote
//
//  Created by Stefan Auvergne on 12/4/16.
//  Copyright © 2016 com.example. All rights reserved.
//

import Foundation

class Deck{
    
    func shuffleDeck(deck:[Card]) -> [Card]{
       
        var tempDeck = deck
        for i in 0 ..< (deck.count - 1) {
            let j = Int(arc4random_uniform(UInt32(deck.count - i))) + i
            if(i != j){
            swap(&tempDeck[i], &tempDeck[j])
            }else{
                swap(&tempDeck[i+1], &tempDeck[j])
            }
        }
        return tempDeck
    }
    
    func dealCards(player1:Player,player2:Player,player3:Player,player4:Player, deck:[Card]){
        
        player1.cardsInHand.append(deck[0])
        player1.cardsInHand.append(deck[1])
        player1.cardsInHand.append(deck[2])
        player1.cardsInHand.append(deck[3])
        player1.cardsInHand.append(deck[4])
        player1.cardsInHand.append(deck[5])
        player1.cardsInHand.append(deck[6])
        player1.cardsInHand.append(deck[7])
        
        player2.cardsInHand.append(deck[8])
        player2.cardsInHand.append(deck[9])
        player2.cardsInHand.append(deck[10])
        player2.cardsInHand.append(deck[11])
        player2.cardsInHand.append(deck[12])
        player2.cardsInHand.append(deck[13])
        player2.cardsInHand.append(deck[14])
        player2.cardsInHand.append(deck[15])
        
        player3.cardsInHand.append(deck[16])
        player3.cardsInHand.append(deck[17])
        player3.cardsInHand.append(deck[18])
        player3.cardsInHand.append(deck[19])
        player3.cardsInHand.append(deck[20])
        player3.cardsInHand.append(deck[21])
        player3.cardsInHand.append(deck[22])
        player3.cardsInHand.append(deck[23])
        
        player4.cardsInHand.append(deck[24])
        player4.cardsInHand.append(deck[25])
        player4.cardsInHand.append(deck[26])
        player4.cardsInHand.append(deck[27])
        player4.cardsInHand.append(deck[28])
        player4.cardsInHand.append(deck[29])
        player4.cardsInHand.append(deck[30])
        player4.cardsInHand.append(deck[31])
    }
    
    func dealRemaining(player1:Player,deck:[Card]){
        player1.cardsInHand.append(deck[5])
        player1.cardsInHand.append(deck[6])
        player1.cardsInHand.append(deck[7])
    }
}
