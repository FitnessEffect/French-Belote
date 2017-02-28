//
//  ViewController.swift
//  French Belote
//
//  Created by Stefan Auvergne on 12/4/16.
//  Copyright © 2016 com.example. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var selectAtout: UILabel!
    @IBOutlet weak var winnerLabel: UILabel!
    
    @IBOutlet weak var card1: UIImageView!
    @IBOutlet weak var card2: UIImageView!
    @IBOutlet weak var card3: UIImageView!
    @IBOutlet weak var card4: UIImageView!
    @IBOutlet weak var card5: UIImageView!
    @IBOutlet weak var card6: UIImageView!
    @IBOutlet weak var card7: UIImageView!
    @IBOutlet weak var card8: UIImageView!
    
    @IBOutlet weak var team1Score: UILabel!
    @IBOutlet weak var team2Score: UILabel!
    
    @IBOutlet weak var heartBtnOutlet: UIButton!
    @IBOutlet weak var diamondBtnOutlet: UIButton!
    @IBOutlet weak var clubBtnOutlet: UIButton!
    @IBOutlet weak var spadeBtnOutlet: UIButton!
    @IBOutlet weak var newGameBtn: UIButton!
    
    @IBOutlet weak var playedCard1: UIImageView!
    @IBOutlet weak var playedCard2: UIImageView!
    @IBOutlet weak var playedCard3: UIImageView!
    @IBOutlet weak var playedCard4: UIImageView!
    @IBOutlet weak var pass: UIButton!
    
    
    let game = GameSession()
    let player = Player(playerNum: 0)
    let deckObj = Deck()
    var tempPlayableCards = [Card]()
    var cardImageArray:[UIImageView]!
    let cardImage = UIImage()
    var cardObj:Card!
    var tagNum:Int = 0
    var deck:[Card]!
    var roundCount = 0
    var tapCount = 0
    var selectedCardView:UIImageView!
    var shuffledDeck = [Card]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newGameBtn.isHidden = true
        
        cardImageArray = [card1, card2, card3, card4, card5, card6, card7, card8]
        
        cardObj = Card(rank: Card.Rank.seven, suit: Card.Suit.club, image: cardImage)
        deck = cardObj.generateDeck()
        
        shuffledDeck = deckObj.shuffleDeck(deck: deck)
        
        deckObj.dealCards(player1: game.player1, player2: game.player2, player3: game.player3, player4: game.player4, deck: shuffledDeck)
        
        card1.image = game.player1.cardsInHand[0].image
        card2.image = game.player1.cardsInHand[1].image
        card3.image = game.player1.cardsInHand[2].image
        card4.image = game.player1.cardsInHand[3].image
        card5.image = game.player1.cardsInHand[4].image
        card6.image = UIImage(named: "back")
        card7.image = UIImage(named: "back")
        card8.image = UIImage(named: "back")
        
        cardInteraction()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectAtoutBtns(_ sender: UIButton) {
        if sender.titleLabel?.text == "Heart"{
            game.setAtout(atout: "heart")
         //   deckObj.dealRemaining(player1: game.player1, deck: shuffledDeck)
            card6.image = game.player1.cardsInHand[5].image
            card7.image = game.player1.cardsInHand[6].image
            card8.image = game.player1.cardsInHand[7].image
        }else if sender.titleLabel?.text == "Diamond"{
            game.setAtout(atout: "diamond")
         //   deckObj.dealRemaining(player1: game.player1, deck: shuffledDeck)
            card6.image = game.player1.cardsInHand[5].image
            card7.image = game.player1.cardsInHand[6].image
            card8.image = game.player1.cardsInHand[7].image
        }else if sender.titleLabel?.text == "Club"{
            game.setAtout(atout: "club")
          //  deckObj.dealRemaining(player1: game.player1, deck: shuffledDeck)
            card6.image = game.player1.cardsInHand[5].image
            card7.image = game.player1.cardsInHand[6].image
            card8.image = game.player1.cardsInHand[7].image
        }else if sender.titleLabel?.text == "Spade"{
            game.setAtout(atout: "spade")
          //  deckObj.dealRemaining(player1: game.player1, deck: shuffledDeck)
            card6.image = game.player1.cardsInHand[5].image
            card7.image = game.player1.cardsInHand[6].image
            card8.image = game.player1.cardsInHand[7].image
        }else if sender.titleLabel?.text == "Pass"{
           // deckObj.dealRemaining(player1: game.player1, deck: shuffledDeck)
            pass.isHidden = true
                card6.image = game.player1.cardsInHand[5].image
                card7.image = game.player1.cardsInHand[6].image
                card8.image = game.player1.cardsInHand[7].image
            return
            
        }
        
        selectAtout.isHidden = true
        heartBtnOutlet.isHidden = true
        diamondBtnOutlet.isHidden = true
        clubBtnOutlet.isHidden = true
        spadeBtnOutlet.isHidden = true
        pass.isHidden = true
        
    }
    
    func pingServer(){
        let urlRequest = NSMutableURLRequest(url: URL(string:"http://138.197.16.105:3000/ping")!)
        
        //setting the method to post
        urlRequest.httpMethod = "POST"
        
        //creating the post parameter by concatenating the keys and values from text field
        //create url
        let postParameters = ""
       
        //adding the parameters to request body
        //urlRequest.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: urlRequest as URLRequest){
            (data, response, error) in
            
//                guard let data = data, error == nil else {                                                 // check for fundamental networking error
//                    print("error=\(error)")
//                    return
//                }
//                
//                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
//                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                    print("response = \(response)")
//                }
//                
//                let responseString = String(data: data, encoding: .utf8)
//                print("responseString = \(responseString)")
//            }
//            task.resume()
//        }
//
            do {
                
                //  let jsonData = NSData(contentsOfFile: jsonFile!)
                // let jsonData = NSData(contentsOf: url! as URL)
                
                //converting response to NSDictionary
                let myJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
                
                print(myJSON)
               
                for eachElement in 0...myJSON.count-1{
                    
                    if let jsonObject = myJSON[eachElement] as? NSDictionary{
                        
                    }
                }
            } catch {
                print(error)
            }
            print(String(describing: response))
            print(String(describing: data!))
        }
        //executing the task
        task.resume()
        
//        DispatchQueue.main.async(execute: { () -> Void in
//            //UI Work
//            
//        })
    }
    
    func cardInteraction(){
      tagNum = 0
        
        for index in 0...cardImageArray.count-1{
            cardImageArray[index].tag = tagNum
            cardImageArray[index].isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardImageTapped(sender:)))
            cardImageArray[index].addGestureRecognizer(tapGesture)
            tagNum += 1
        }
    }
    
    func moveImage(view: UIImageView) -> UIImageView{
        
       
      //  view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y - 20, width: view.frame.width, height: view.frame.height)
        
        UIView.animate(withDuration: 0.2, animations: {
        view.frame.origin.y -= 20
        })
        return view
    }
    
    func cardImageTapped(sender:UITapGestureRecognizer){
       // pingServer()
        tapCount += 1
        
        print(tapCount)
        if tapCount == 1{
            selectedCardView = moveImage(view: sender.view as! UIImageView)
        }
        
        if tapCount == 2 {
            if sender.view == selectedCardView{
                tapCount = 0
                playedCard1.image = nil
                playedCard2.image = nil
                playedCard3.image = nil
                playedCard4.image = nil
                
                game.playedCards.removeAll()
                cardInteraction()
                
                let tag = sender.view!.tag
                
                game.playCard(card: game.player1.cardsInHand[tag])
                
                cardImageArray[tag].isHidden = true
                selectedCardView.transform = CGAffineTransform(translationX: 0, y: 0)
                cardImageArray.remove(at: tag)
                
                //check next card with previous card
                game.checkNextCard(card: game.player1.cardsInHand[tag], player: game.player1)
                
                displayPlayedCards()
                
                deck = game.player1.removeCardFromHand(player:game.player1, passedCard:game.player1.cardsInHand[tag], deck: deck)
                
                let winner = game.comparePlayedCards()
                winnerLabel.text = "Player " + String(winner.playerNum) + " wins!"
                let tempScore = game.calculateScore()
                if winner.playerNum == game.player1.playerNum || winner.playerNum == game.player3.playerNum{
                    team1Score.text = "Team 1: " + String(tempScore)
                }else if winner.playerNum == game.player2.playerNum || winner.playerNum == game.player4.playerNum{
                    team2Score.text = "Team 2: " + String(tempScore)
                }
                
                tapCount = 0
                }else{
             //   selectedCardView.frame = CGRect(x: selectedCardView.frame.origin.x, y: selectedCardView.frame.origin.y + 20, width: selectedCardView.frame.width, height: selectedCardView.frame.height)
                UIView.animate(withDuration: 0.2, animations: {
                    self.selectedCardView.frame.origin.y += 20
                })
                tapCount = 0
            }
        }
        if game.player1.cardsInHand.count == 0{
            newGameBtn.isHidden = false
        }
    }
    
    func startGame(){
        newGameBtn.isHidden = true
        selectAtout.isHidden = false
        pass.isHidden = false
        heartBtnOutlet.isHidden = false
        diamondBtnOutlet.isHidden = false
        clubBtnOutlet.isHidden = false
        spadeBtnOutlet.isHidden = false
        
        cardImageArray = [card1, card2, card3, card4, card5, card6, card7, card8]
        
        
        deck = cardObj.generateDeck()
        
        let shuffledDeck = deckObj.shuffleDeck(deck: deck)
        
        deckObj.dealCards(player1: game.player1, player2: game.player2, player3: game.player3, player4: game.player4, deck: shuffledDeck)
        card1.isHidden = false
        card2.isHidden = false
        card3.isHidden = false
        card4.isHidden = false
        card5.isHidden = false
        card6.isHidden = false
        card7.isHidden = false
        card8.isHidden = false
        card1.image = game.player1.cardsInHand[0].image
        card2.image = game.player1.cardsInHand[1].image
        card3.image = game.player1.cardsInHand[2].image
        card4.image = game.player1.cardsInHand[3].image
        card5.image = game.player1.cardsInHand[4].image
        card6.image = UIImage(named: "back")
        card7.image = UIImage(named: "back")
        card8.image = UIImage(named: "back")

        
        cardInteraction()
    }

    func displayPlayedCards(){
        //Played Cards from other players
        
        game.playCard(card:game.player2.playableCards.first!)
        print(game.playedCards[1].rank, game.playedCards[1].suit.rawValue)
        game.checkNextCard(card: game.playedCards.first!, player: game.player2)
        
        game.playCard(card:game.player3.playableCards.first!)
        print(game.playedCards[2].rank, game.playedCards[2].suit.rawValue)
        game.checkNextCard(card: game.playedCards.first!, player: game.player3)
        
        game.playCard(card:game.player4.playableCards.first!)
        print(game.playedCards[3].rank, game.playedCards[3].suit.rawValue)
        
        //remove card from hand
        deck = game.player2.removeCardFromHand(player:game.player2, passedCard:game.player2.playableCards.first!, deck: deck)
        deck = game.player3.removeCardFromHand(player:game.player3, passedCard: game.player3.playableCards.first! , deck: deck)
        deck = game.player4.removeCardFromHand(player:game.player4, passedCard:game.player4.playableCards.first!, deck: deck)
        
        let cards = game.getPlayedCards
        
        playedCard1.image = cards()[0].image
        playedCard2.image = cards()[1].image
        playedCard3.image = cards()[2].image
        playedCard4.image = cards()[3].image
    }
    
    @IBAction func newGameBtn(_ sender: UIButton) {
        playedCard1.image = nil
        playedCard2.image = nil
        playedCard3.image = nil
        playedCard4.image = nil
        startGame()
    }
    
}


