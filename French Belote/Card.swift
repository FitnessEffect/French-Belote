//
//  Card.swift
//  French Belote
//
//  Created by Stefan Auvergne on 12/4/16.
//  Copyright © 2016 com.example. All rights reserved.
//

import Foundation
import UIKit

class Card{
    
    var rank:Rank
    var suit:Suit
    var image:UIImage
    
    
    init(rank:Rank, suit:Suit, image:UIImage){
        self.rank = rank
        self.suit = suit
        self.image = image
    }
    
    enum Rank:Int{
        case seven, eight, nine, ten, jack, queen, king, ace
        
        func rankDescription() -> String{
            switch self{
            case .seven: return "seven"
            case .eight: return "eight"
            case .nine: return "nine"
            case .ten: return "ten"
            case .jack: return "jack"
            case .queen: return "queen"
            case .king: return "king"
            case .ace: return "ace"
            }
        }
        
        
        func cardsValueAtout()-> Int{
            switch self{
            case .seven: return 0
            case .eight: return 0
            case .nine: return 14
            case .ten: return 10
            case .jack: return 20
            case .queen: return 3
            case .king: return 4
            case .ace: return 11
            }
        }
        
        func cardsValueNonAtout()-> Int{
            switch self{
            case .seven: return 0
            case .eight: return 0
            case .nine: return 0
            case .ten: return 10
            case .jack: return 2
            case .queen: return 3
            case .king: return 4
            case .ace: return 11
            }
        }
    }
    
    enum Suit: String{
        case spade = "spade"
        case heart = "heart"
        case diamond = "diamond"
        case club = "club"
    }
    
    func addImagesToCards(deck:[Card]) -> [Card]{
        let cardImages = ["7_of_clubs.png", "7_of_diamonds.png", "7_of_hearts.png", "7_of_spades.png", "8_of_clubs.png", "8_of_diamonds.png", "8_of_hearts.png", "8_of_spades.png","9_of_clubs.png", "9_of_diamonds.png", "9_of_hearts.png", "9_of_spades.png","10_of_clubs.png", "10_of_diamonds.png", "10_of_hearts.png", "10_of_spades.png","jack_of_clubs.png", "jack_of_diamonds.png", "jack_of_hearts.png", "jack_of_spades.png","queen_of_clubs.png", "queen_of_diamonds.png", "queen_of_hearts.png", "queen_of_spades.png","king_of_clubs.png", "king_of_diamonds.png", "king_of_hearts.png", "king_of_spades.png","ace_of_clubs.png", "ace_of_diamonds.png", "ace_of_hearts.png", "ace_of_spades.png"]
        
        for x in 0...deck.count-1{
            deck[x].image = UIImage(named:cardImages[x])!
        }
        
        return deck
    }

    
    func generateDeck() -> [Card]{
        var deck: Array = [Card]()
        let maxRank = Card.Rank.ace
        let aSuit:Array = [Card.Suit.club.rawValue, Card.Suit.diamond.rawValue, Card.Suit.heart.rawValue, Card.Suit.spade.rawValue]
        
        for count in 0...maxRank.rawValue{
            for suit in aSuit{
                let aRank = Card.Rank.init(rawValue: count)
                let aSuit = Card.Suit.init(rawValue: suit)
                let myCard = Card(rank: aRank!, suit: aSuit!, image: image)
                deck.append(myCard)
            }
        }
        
        deck = addImagesToCards(deck: deck)
        return deck
    }
}
