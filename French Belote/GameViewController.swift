//
//  ViewController.swift
//  French Belote
//
//  Created by Stefan Auvergne on 12/4/16.
//  Copyright © 2016 com.example. All rights reserved.
//

import UIKit
import SocketIO
import FirebaseAuth

class GameViewController: UIViewController {
    
    @IBOutlet weak var winnerLabel: UILabel!

    @IBOutlet weak var player4Image: UIImageView!
    @IBOutlet weak var player3Image: UIImageView!
    @IBOutlet weak var player2Image: UIImageView!
    @IBOutlet weak var atoutLabel: UILabel!
    
    @IBOutlet weak var player2username: UILabel!
    @IBOutlet weak var player3username: UILabel!
    @IBOutlet weak var player4username: UILabel!
    
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
    @IBOutlet weak var waitingLabel: UILabel!
    
    @IBOutlet weak var heartBtnOutlet: UIButton!
    @IBOutlet weak var diamondBtnOutlet: UIButton!
    @IBOutlet weak var clubBtnOutlet: UIButton!
    @IBOutlet weak var spadeBtnOutlet: UIButton!
    @IBOutlet weak var newGameBtn: UIButton!
    @IBOutlet weak var talkBtn: UIButton!
    
    @IBOutlet weak var playedCard1: UIImageView!
    @IBOutlet weak var playedCard2: UIImageView!
    @IBOutlet weak var playedCard3: UIImageView!
    @IBOutlet weak var playedCard4: UIImageView!
    @IBOutlet weak var pass: UIButton!
    
    @IBOutlet weak var player2Dialogue: UIImageView!
    @IBOutlet weak var player2Message: UILabel!
    
    @IBOutlet weak var player3Dialogue: UIImageView!
    @IBOutlet weak var player3Message: UILabel!
    
    @IBOutlet weak var player4Dialogue: UIImageView!
    @IBOutlet weak var player4Message: UILabel!
    
    
    @IBOutlet weak var wagerCard: UIImageView!
    
    
    let player1 = Player(playerNum: 1)
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
    var socket:SocketIOClient!
    var uid:String!
    var seat1:Seat!
    var seat2:Seat!
    var seat3:Seat!
    var seat4:Seat!
    var dictionaryScore = [String:Any]()
    var totalSeatPlayers = [Seat]()
    var scoreTeam1:Int!
    var scoreTeam2:Int!
    var atoutSelected = ""
    var tempUsername = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newGameBtn.layer.cornerRadius = 10.0
        newGameBtn.clipsToBounds = true
        newGameBtn.layer.borderWidth = 1
        newGameBtn.layer.borderColor = UIColor.black.cgColor
        
        talkBtn.isHidden = true
        
        player2Dialogue.image = UIImage(named: "dialogue.png")
        player2Dialogue.isHidden = true
        player2Message.isHidden = true
        player2Dialogue.alpha = 0
        player2Message.alpha = 0
        
        player3Dialogue.image = UIImage(named: "dialogue.png")
        player3Dialogue.isHidden = true
        player3Message.isHidden = true
        player3Dialogue.alpha = 0
        player3Message.alpha = 0
        
        player4Dialogue.image = UIImage(named: "dialogue.png")
        player4Dialogue.isHidden = true
        player4Message.isHidden = true
        player4Dialogue.alpha = 0
        player4Message.alpha = 0
        
        player2username.isHidden = true
        player3username.isHidden = true
        player4username.isHidden = true
        
        uid = FIRAuth.auth()?.currentUser?.uid
        openSocket()
        //pingServer()
        
        seat1 = Seat()
        seat1.player = Player(playerNum: 1)
        seat1.player.uid = uid
        seat1.seatImage = playedCard1
        
        
        totalSeatPlayers.append(seat1)
        
        newGameBtn.isHidden = true
        
        //cardImageArray = [card1, card2, card3, card4, card5, card6, card7, card8]
        
        //cardInteraction()
        
        heartBtnOutlet.isHidden = true
        diamondBtnOutlet.isHidden = true
        clubBtnOutlet.isHidden = true
        spadeBtnOutlet.isHidden = true
        pass.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectAtoutBtns(_ sender: UIButton) {
        if sender.titleLabel?.text == "♥️"{
            atoutSelected = "heart"
            
        }else if sender.titleLabel?.text == "♦️"{
            atoutSelected = "diamond"
            
        }else if sender.titleLabel?.text == "♣️"{
            atoutSelected = "club"
            
        }else if sender.titleLabel?.text == "♠️"{
            atoutSelected = "spade"
            
        }else if sender.titleLabel?.text == "☞"{
            atoutSelected = "pass"
            socket.emit("setAtout", ["atout":"pass", "uid":seat1.player.uid])
            heartBtnOutlet.isHidden = true
            diamondBtnOutlet.isHidden = true
            clubBtnOutlet.isHidden = true
            spadeBtnOutlet.isHidden = true
            pass.isHidden = true
            return
        }
        
        wagerCard.isHidden = true
        socket.emit("setAtout", ["atout":atoutSelected, "id":seat1.player.uid])
        if atoutSelected != "pass"{
          self.waitingLabel.text = "Pick your card!"
        }
        heartBtnOutlet.isHidden = true
        diamondBtnOutlet.isHidden = true
        clubBtnOutlet.isHidden = true
        spadeBtnOutlet.isHidden = true
        pass.isHidden = true
    }
    
    func openSocket(){
        socket = SocketIOClient(socketURL: URL(string: "http://fitchal.website")!, config: [.log(true), .forcePolling(true)])
        socket.on("connect") {data, ack in
            self.socket.emit("addNewPlayer", ["id":self.uid, "username":self.tempUsername])
            //self.socket.emit("updatePlayers")
            //check if seat is occupied by a player
            
        }
        
        
        socket.on("showCard"){ data, ack in
            print(data)
            let cardPlayed = data[0] as! [String:Any]
            if cardPlayed["description"] as! String == "Seven"{
                if cardPlayed["suit"] as! String == "Heart"{
                    self.wagerCard.image = UIImage(named: "7_of_hearts")
                }
                if cardPlayed["suit"] as! String == "Diamond"{
                    self.wagerCard.image = UIImage(named: "7_of_diamonds")
                }
                if cardPlayed["suit"] as! String == "Club"{
                    self.wagerCard.image = UIImage(named: "7_of_clubs")
                }
                if cardPlayed["suit"] as! String == "Spade"{
                    self.wagerCard.image = UIImage(named: "7_of_spades")
                }
            }
            if cardPlayed["description"] as! String == "Eight"{
                if cardPlayed["suit"] as! String == "Heart"{
                    self.wagerCard.image = UIImage(named: "8_of_hearts")
                }
                if cardPlayed["suit"] as! String == "Diamond"{
                    self.wagerCard.image = UIImage(named: "8_of_diamonds")
                }
                if cardPlayed["suit"] as! String == "Club"{
                    self.wagerCard.image = UIImage(named: "8_of_clubs")
                }
                if cardPlayed["suit"] as! String == "Spade"{
                    self.wagerCard.image = UIImage(named: "8_of_spades")
                }
            }
            if cardPlayed["description"] as! String == "Nine"{
                if cardPlayed["suit"] as! String == "Heart"{
                    self.wagerCard.image = UIImage(named: "9_of_hearts")
                }
                if cardPlayed["suit"] as! String == "Diamond"{
                    self.wagerCard.image = UIImage(named: "9_of_diamonds")
                }
                if cardPlayed["suit"] as! String == "Club"{
                    self.wagerCard.image = UIImage(named: "9_of_clubs")
                }
                if cardPlayed["suit"] as! String == "Spade"{
                    self.wagerCard.image = UIImage(named: "9_of_spades")
                }
            }
            if cardPlayed["description"] as! String == "Ten"{
                if cardPlayed["suit"] as! String == "Heart"{
                    self.wagerCard.image = UIImage(named: "10_of_hearts")
                }
                if cardPlayed["suit"] as! String == "Diamond"{
                    self.wagerCard.image = UIImage(named: "10_of_diamonds")
                }
                if cardPlayed["suit"] as! String == "Club"{
                    self.wagerCard.image = UIImage(named: "10_of_clubs")
                }
                if cardPlayed["suit"] as! String == "Spade"{
                    self.wagerCard.image = UIImage(named: "10_of_spades")
                }
            }
            if cardPlayed["description"] as! String == "Jack"{
                if cardPlayed["suit"] as! String == "Heart"{
                    self.wagerCard.image = UIImage(named: "jack_of_hearts")
                }
                if cardPlayed["suit"] as! String == "Diamond"{
                    self.wagerCard.image = UIImage(named: "jack_of_diamonds")
                }
                if cardPlayed["suit"] as! String == "Club"{
                    self.wagerCard.image = UIImage(named: "jack_of_clubs")
                }
                if cardPlayed["suit"] as! String == "Spade"{
                    self.wagerCard.image = UIImage(named: "jack_of_spades")
                }
            }
            if cardPlayed["description"] as! String == "Queen"{
                if cardPlayed["suit"] as! String == "Heart"{
                    self.wagerCard.image = UIImage(named: "queen_of_hearts")
                }
                if cardPlayed["suit"] as! String == "Diamond"{
                    self.wagerCard.image = UIImage(named: "queen_of_diamonds")
                }
                if cardPlayed["suit"] as! String == "Club"{
                    self.wagerCard.image = UIImage(named: "queen_of_clubs")
                }
                if cardPlayed["suit"] as! String == "Spade"{
                    self.wagerCard.image = UIImage(named: "queen_of_spades")
                }
            }
            if cardPlayed["description"] as! String == "King"{
                if cardPlayed["suit"] as! String == "Heart"{
                    self.wagerCard.image = UIImage(named: "king_of_hearts")
                }
                if cardPlayed["suit"] as! String == "Diamond"{
                    self.wagerCard.image = UIImage(named: "king_of_diamonds")
                }
                if cardPlayed["suit"] as! String == "Club"{
                    self.wagerCard.image = UIImage(named: "king_of_clubs")
                }
                if cardPlayed["suit"] as! String == "Spade"{
                    self.wagerCard.image = UIImage(named: "king_of_spades")
                }
            }
            if cardPlayed["description"] as! String == "Ace"{
                if cardPlayed["suit"] as! String == "Heart"{
                    self.wagerCard.image = UIImage(named: "ace_of_hearts")
                }
                if cardPlayed["suit"] as! String == "Diamond"{
                    self.wagerCard.image = UIImage(named: "ace_of_diamonds")
                }
                if cardPlayed["suit"] as! String == "Club"{
                    self.wagerCard.image = UIImage(named: "ace_of_clubs")
                }
                if cardPlayed["suit"] as! String == "Spade"{
                    self.wagerCard.image = UIImage(named: "ace_of_spades")
                }
            }
        
        }
    
        socket.on("nudge") {data, ack in
            let dictionary = data[0] as! [String:Any]
            self.player2Dialogue.isHidden = false
            self.player2Message.isHidden = false
            let pNum = dictionary["num"] as! Int
            for seat in self.totalSeatPlayers{
                if seat.player.playerNum == pNum{
                    if pNum == 2{
                        self.player2Message.text = (dictionary["message"] as! String)
                        UIView.animate(withDuration: 1.0, animations: {
                            self.player2Message.alpha = 1.0
                            self.player2Dialogue.alpha = 1.0
                        })
                        let when = DispatchTime.now() + 3 // number of seconds
                        DispatchQueue.main.asyncAfter(deadline: when) {
                            // Your code with delay
                            self.player2Message.alpha = 0
                            self.player2Dialogue.alpha = 0
                            self.player2Message.text = ""
                            self.player2Dialogue.isHidden = true
                        }
                    }else if pNum == 3{
                        self.player3Message.text = (dictionary["message"] as! String)
                        UIView.animate(withDuration: 1.0, animations: {
                            self.player3Message.alpha = 1.0
                            self.player3Dialogue.alpha = 1.0
                        })
                        let when = DispatchTime.now() + 3 // number of seconds
                        DispatchQueue.main.asyncAfter(deadline: when) {
                            // Your code with delay
                            self.player3Message.alpha = 0
                            self.player3Dialogue.alpha = 0
                            self.player3Message.text = ""
                            self.player3Dialogue.isHidden = true
                        }
                    }else if pNum == 4{
                        self.player4Message.text = (dictionary["message"] as! String)
                        UIView.animate(withDuration: 1.0, animations: {
                            self.player4Message.alpha = 1.0
                            self.player4Dialogue.alpha = 1.0
                        })
                        let when = DispatchTime.now() + 3 // number of seconds
                        DispatchQueue.main.asyncAfter(deadline: when) {
                            // Your code with delay
                            self.player4Message.alpha = 0
                            self.player4Dialogue.alpha = 0
                            self.player4Message.text = ""
                            self.player4Dialogue.isHidden = true
                        }
                    }
                }
            }
            self.player2Message.text = (dictionary["message"] as! String)
            UIView.animate(withDuration: 1.0, animations: {
                 self.player2Message.alpha = 1.0
                self.player2Dialogue.alpha = 1.0
            })
            let when = DispatchTime.now() + 3 // number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                // Your code with delay
                self.player2Message.alpha = 0
                self.player2Dialogue.alpha = 0
                self.player2Message.text = ""
                self.player2Dialogue.isHidden = true
            }
        }
        
        socket.on("resetGame"){
            data,ack in
            self.cardImageArray.removeAll()
            self.seat1.player.cardsInHand.removeAll()
            self.cardImageArray = [self.card1, self.card2, self.card3, self.card4, self.card5, self.card6, self.card7, self.card8]
            self.cardInteraction()
            
        }
    
        socket.on("waitingPlayers") {data, ack in
            let pID = data[0] as! String
            var tempPlayer = ""
            for seat in self.totalSeatPlayers{
                if seat.player.uid == pID{
                    tempPlayer = String(seat.player.playerNum)
                }
            }
            if self.seat1.player.uid != pID{
               self.waitingLabel.text = "Waiting for Player " + tempPlayer
                for card in self.cardImageArray{
                    card.isUserInteractionEnabled = false
                }
            }else{
                self.waitingLabel.text = "Pick your card!"
                for card in self.cardImageArray{
                    card.isUserInteractionEnabled = true
                }
            }
        }
        
        socket.on("removePlayer"){data, ack in
            let dictionary = data[0] as! [String:Any]
            let id = dictionary["uid"] as! String
            for index in 0...self.totalSeatPlayers.count-1{
                if self.totalSeatPlayers[index].player.uid == id {
                    
                    self.totalSeatPlayers.remove(at: index)
                    if index == 1{
                        self.player2Image.image = nil
                        self.playedCard2.image = nil
                    }else if index == 2{
                        self.player3Image.image = nil
                        self.playedCard3.image = nil
                    }else if index == 3{
                        self.player4Image.image = nil
                        self.playedCard4.image = nil
                    }
                }
            }
        }
        
        socket.on("playerJoined") {data, ack in
            print(data)
            let dictionary = data[0] as! [String:Any]
            var tag = 0
            //let id = dictionary["id"] as! String
            var players = dictionary["players"] as! [AnyObject]
            for x in 0...players.count-1{
                let player = players[x] as! [String:Any]
                if player["id"] as! String == self.seat1.player.uid{
                    tag = player["playerNumber"] as! Int
                    players.remove(at: x)
                    
                    break
                }
            }
            let tempUsername = dictionary["username"] as! String
            if players.count != 0{
                
                
                    //add new player
                    if players.count >= 1{
                        if tag == 3{
                            let player = players[0] as! [String:Any]
                            let player2 = Player(playerNum: player["playerNumber"] as! Int)
                            //let d = data[0] as! [String:Any]
                            player2.uid = player["id"] as! String
                            self.seat3 = Seat()
                            self.seat3.player = player2
                            self.player3Image.image = UIImage(named: "avatar1.png")
                            self.totalSeatPlayers.append(self.seat3)
                            self.seat3.seatImage = self.playedCard3
                            self.seat3.player.username = player["username"] as! String
                            self.player3username.text = (player["username"] as! String)
                            self.player3username.isHidden = false
                        }else{
                        let player = players[0] as! [String:Any]
                        let player2 = Player(playerNum: player["playerNumber"] as! Int)
                        //let d = data[0] as! [String:Any]
                        player2.uid = player["id"] as! String
                        self.seat2 = Seat()
                        self.seat2.player = player2
                        self.player2Image.image = UIImage(named: "avatar1.png")
                        self.totalSeatPlayers.append(self.seat2)
                        self.seat2.seatImage = self.playedCard2
                        self.seat2.player.username = player["username"] as! String
                        self.player2username.text = (player["username"] as! String)
                        self.player2username.isHidden = false
                        }
                    }
                    if players.count >= 2{
                         let player = players[1] as! [String:Any]
                        
                            if  tag == 2{
                                let player4 = Player(playerNum: player["playerNumber"] as! Int)
                                //let d = data[0] as! [String:Any]
                                player4.uid = player["id"] as! String
                                self.seat4 = Seat()
                                self.seat4.player = player4
                                self.seat4.seatImage = self.playedCard4
                                self.player4Image.image = UIImage(named: "avatar3.png")
                                self.totalSeatPlayers.append(self.seat4)
                                self.seat4.player.username = player["username"] as! String
                                self.player4username.text = (player["username"] as! String)
                                self.player4username.isHidden = false
                            }else if tag == 3{
                                let currentPlayer = Player(playerNum: player["playerNumber"] as! Int)
                                //let d = data[0] as! [String:Any]
                                currentPlayer.uid = player["id"] as! String
                                self.seat2 = Seat()
                                self.seat2.player = currentPlayer
                                self.player2Image.image = UIImage(named: "avatar1.png")
                                self.totalSeatPlayers.append(self.seat2)
                                self.seat2.seatImage = self.playedCard2
                                self.seat2.player.username = player["username"] as! String
                                self.player2username.text = (player["username"] as! String)
                                self.player2username.isHidden = false
                            }else{
                                let player3 = Player(playerNum: player["playerNumber"] as! Int)
                                //let d = data[0] as! [String:Any]
                                player3.uid = player["id"] as! String
                                self.seat3 = Seat()
                                self.seat3.player = player3
                                self.seat3.seatImage = self.playedCard3
                                self.player3Image.image = UIImage(named: "avatar2.png")
                                self.totalSeatPlayers.append(self.seat3)
                                self.seat3.player.username = player["username"] as! String
                                self.player3username.text = (player["username"] as! String)
                                self.player3username.isHidden = false
                            }
                        
                    }
                    if players.count >= 3{
                        let player = players[2] as! [String:Any]
                        if tag == 2{
                            let player4 = Player(playerNum: player["playerNumber"] as! Int)
                            //let d = data[0] as! [String:Any]
                            player4.uid = player["id"] as! String
                            self.seat3 = Seat()
                            self.seat3.player = player4
                            self.seat3.seatImage = self.playedCard3
                            self.player3Image.image = UIImage(named: "avatar3.png")
                            self.totalSeatPlayers.append(self.seat3)
                            self.seat3.player.username = player["username"] as! String
                            self.player3username.text = (player["username"] as! String)
                            self.player3username.isHidden = false

                        }else{
                        
                        let player4 = Player(playerNum: player["playerNumber"] as! Int)
                        //let d = data[0] as! [String:Any]
                        player4.uid = player["id"] as! String
                        self.seat4 = Seat()
                        self.seat4.player = player4
                        self.seat4.seatImage = self.playedCard4
                        self.player4Image.image = UIImage(named: "avatar3.png")
                        self.totalSeatPlayers.append(self.seat4)
                        self.seat4.player.username = player["username"] as! String
                        self.player4username.text = (player["username"] as! String)
                        self.player4username.isHidden = false
                        }
                    }
                
            }
            
            self.newGameBtn.isHidden = false
            if self.totalSeatPlayers.count > 1{
                self.talkBtn.isHidden = false
            }
        }
        
        socket.on("cardsDealt"){data, ack in
    
            self.newGameBtn.isHidden = true
            
            self.cardImageArray = [self.card1, self.card2, self.card3, self.card4, self.card5, self.card6, self.card7, self.card8]
            self.cardInteraction()
           
            self.seat1.player.cardsInHand.removeAll()
            //2 players
            let players = data[0] as! [AnyObject]
            
            for index in 0...players.count-1{
                //grab one player
                let player = players[index] as! [String:Any]
                let id = self.totalSeatPlayers[0].player.uid
                //compare using firebase ids
                if id == (player["id"] as! String){
                    //grab hand from player
                    let hand = player["hand"] as! [AnyObject]
                    
                    //list of cards
                    var temp = [String]()
                    for index in 0...hand.count-1{
                        
                        let rank = hand[index]["description"] as AnyObject
                        let suit = hand[index]["suit"] as AnyObject
                        
                        temp.append(rank as! String)
                        temp.append(suit as! String)
                    }
                    var tempCard = [String]()
                    
                    //why is cardImageArray=0 second time around?
                    self.cardImageArray[5].image = UIImage(named:"back")
                    self.cardImageArray[6].image = UIImage(named:"back")
                    self.cardImageArray[7].image = UIImage(named:"back")
                    
                    var maxCards = 5
                    if self.atoutSelected != ""{
                        maxCards = 8
                    }else{
                        self.wagerCard.isHidden = false
                    }
                    
                    for index in 0...maxCards-1{
                        tempCard.removeAll()
                       // self.cardImageArray[index].tag = index
                        
                        tempCard.append(temp[2*index])
                        tempCard.append(temp[2*index+1])
                        print(tempCard)
                        
                        if tempCard[0] == "Seven"{
                            if tempCard[1] == "Heart"{
                                self.cardImageArray[index].image = UIImage(named: "7_of_hearts")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.seven, suit: Card.Suit.heart, image: self.cardImageArray[index].image!))
                            }
                            if tempCard[1] == "Diamond"{
                                self.cardImageArray[index].image = UIImage(named: "7_of_diamonds")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.seven, suit: Card.Suit.diamond, image: self.cardImageArray[index].image!))
                            }
                            if tempCard[1] == "Spade"{
                                self.cardImageArray[index].image = UIImage(named: "7_of_spades")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.seven, suit: Card.Suit.spade, image: self.cardImageArray[index].image!))
                            }
                            if tempCard[1] == "Club"{
                                self.cardImageArray[index].image = UIImage(named: "7_of_clubs")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.seven, suit: Card.Suit.club, image: self.cardImageArray[index].image!))
                            }
                        }
                        if tempCard[0] == "Eight"{
                            if tempCard[1] == "Heart"{
                                self.cardImageArray[index].image = UIImage(named: "8_of_hearts")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.eight, suit: Card.Suit.heart, image: self.cardImageArray[index].image!))
                            }
                            if tempCard[1] == "Diamond"{
                                self.cardImageArray[index].image = UIImage(named: "8_of_diamonds")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.eight, suit: Card.Suit.diamond, image: self.cardImageArray[index].image!))
                            }
                            if tempCard[1] == "Spade"{
                                self.cardImageArray[index].image = UIImage(named: "8_of_spades")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.eight, suit: Card.Suit.spade, image: self.cardImageArray[index].image!))
                            }
                            if tempCard[1] == "Club"{
                                self.cardImageArray[index].image = UIImage(named: "8_of_clubs")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.eight, suit: Card.Suit.club, image: self.cardImageArray[index].image!))
                            }
                        }
                        if tempCard[0] == "Nine"{
                            if tempCard[1] == "Heart"{
                                self.cardImageArray[index].image = UIImage(named: "9_of_hearts")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.nine, suit: Card.Suit.heart, image: self.cardImageArray[index].image!))
                            }
                            if tempCard[1] == "Diamond"{
                                self.cardImageArray[index].image = UIImage(named: "9_of_diamonds")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.nine, suit: Card.Suit.diamond, image: self.cardImageArray[index].image!))
                            }
                            if tempCard[1] == "Spade"{
                                self.cardImageArray[index].image = UIImage(named: "9_of_spades")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.nine, suit: Card.Suit.spade, image: self.cardImageArray[index].image!))
                            }
                            if tempCard[1] == "Club"{
                                self.cardImageArray[index].image = UIImage(named: "9_of_clubs")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.nine, suit: Card.Suit.club, image: self.cardImageArray[index].image!))
                                
                            }
                        }
                        if tempCard[0] == "Ten"{
                            if tempCard[1] == "Heart"{
                                self.cardImageArray[index].image = UIImage(named: "10_of_hearts")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.ten, suit: Card.Suit.heart, image: self.cardImageArray[index].image!))
                                
                            }
                            if tempCard[1] == "Diamond"{
                                self.cardImageArray[index].image = UIImage(named: "10_of_diamonds")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.ten, suit: Card.Suit.diamond, image: self.cardImageArray[index].image!))
                            }
                            if tempCard[1] == "Spade"{
                                self.cardImageArray[index].image = UIImage(named: "10_of_spades")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.ten, suit: Card.Suit.spade, image: self.cardImageArray[index].image!))
                            }
                            if tempCard[1] == "Club"{
                                self.cardImageArray[index].image = UIImage(named: "10_of_clubs")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.ten, suit: Card.Suit.club, image: self.cardImageArray[index].image!))
                            }
                        }
                        if tempCard[0] == "Jack"{
                            if tempCard[1] == "Heart"{
                                self.cardImageArray[index].image = UIImage(named: "jack_of_hearts")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.jack, suit: Card.Suit.heart, image: self.cardImageArray[index].image!))
                            }
                            if tempCard[1] == "Diamond"{
                                self.cardImageArray[index].image = UIImage(named: "jack_of_diamonds")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.jack, suit: Card.Suit.diamond, image: self.cardImageArray[index].image!))
                            }
                            if tempCard[1] == "Spade"{
                                self.cardImageArray[index].image = UIImage(named: "jack_of_spades")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.jack, suit: Card.Suit.spade, image: self.cardImageArray[index].image!))
                            }
                            if tempCard[1] == "Club"{
                                self.cardImageArray[index].image = UIImage(named: "jack_of_clubs")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.jack, suit: Card.Suit.club, image: self.cardImageArray[index].image!))
                            }
                        }
                        if tempCard[0] == "Queen"{
                            if tempCard[1] == "Heart"{
                                self.cardImageArray[index].image = UIImage(named: "queen_of_hearts")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.queen, suit: Card.Suit.heart, image: self.cardImageArray[index].image!))
                            }
                            if tempCard[1] == "Diamond"{
                                self.cardImageArray[index].image = UIImage(named: "queen_of_diamonds")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.queen, suit: Card.Suit.diamond, image: self.cardImageArray[index].image!))
                            }
                            if tempCard[1] == "Spade"{
                                self.cardImageArray[index].image = UIImage(named: "queen_of_spades")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.queen, suit: Card.Suit.spade, image: self.cardImageArray[index].image!))
                            }
                            if tempCard[1] == "Club"{
                                self.cardImageArray[index].image = UIImage(named: "queen_of_clubs")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.queen, suit: Card.Suit.club, image: self.cardImageArray[index].image!))
                            }
                        }
                        if tempCard[0] == "King"{
                            if tempCard[1] == "Heart"{
                                self.cardImageArray[index].image = UIImage(named: "king_of_hearts")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.king, suit: Card.Suit.heart, image: self.cardImageArray[index].image!))
                            }
                            if tempCard[1] == "Diamond"{
                                self.cardImageArray[index].image = UIImage(named: "king_of_diamonds")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.king, suit: Card.Suit.diamond, image: self.cardImageArray[index].image!))
                            }
                            if tempCard[1] == "Spade"{
                                self.cardImageArray[index].image = UIImage(named: "king_of_spades")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.king, suit: Card.Suit.spade, image: self.cardImageArray[index].image!))
                            }
                            if tempCard[1] == "Club"{
                                self.cardImageArray[index].image = UIImage(named: "king_of_clubs")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.king, suit: Card.Suit.club, image: self.cardImageArray[index].image!))
                            }
                        }
                        if tempCard[0] == "Ace"{
                            if tempCard[1] == "Heart"{
                                self.cardImageArray[index].image = UIImage(named: "ace_of_hearts")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.ace, suit: Card.Suit.heart, image: self.cardImageArray[index].image!))
                            }
                            if tempCard[1] == "Diamond"{
                                self.cardImageArray[index].image = UIImage(named: "ace_of_diamonds")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.ace, suit: Card.Suit.diamond, image: self.cardImageArray[index].image!))
                            }
                            if tempCard[1] == "Spade"{
                                self.cardImageArray[index].image = UIImage(named: "ace_of_spades")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.ace, suit: Card.Suit.spade, image: self.cardImageArray[index].image!))
                            }
                            if tempCard[1] == "Club"{
                                self.cardImageArray[index].image = UIImage(named: "ace_of_clubs")
                                self.seat1.player.cardsInHand.append(Card(rank: Card.Rank.ace, suit: Card.Suit.club, image: self.cardImageArray[index].image!))
                            }
                        }
                    }
                }
            }
        }
        
        socket.on("selectAtout"){data, ack in
            if self.seat1.player.uid == data[0] as! String{
               // self.waitingLabel.isHidden = true
                self.heartBtnOutlet.isHidden = false
                self.diamondBtnOutlet.isHidden = false
                self.clubBtnOutlet.isHidden = false
                self.spadeBtnOutlet.isHidden = false
                self.pass.isHidden = false
                self.waitingLabel.text = "Select Suit!"
            }
        }
        
        socket.on("atoutSelected") {data, ack in
            self.atoutSelected = data[0] as! String
            let temp = self.atoutSelected
            if temp == "heart"{
                self.atoutLabel.text = "♥️"
            }else if temp == "diamond"{
                self.atoutLabel.text = "♦️"
            }else if temp == "spade"{
                self.atoutLabel.text = "♠️"
            }else if temp == "club"{
                self.atoutLabel.text = "♣️"
            }
        }
        
        
        socket.on("displayCard"){ data, ack in
            let cardPlayed = data[0] as! [String:Any]
            for seat in self.totalSeatPlayers{
                if seat.player.uid == cardPlayed["id"] as! String{
                    
                    if cardPlayed["rank"] as! Int64 == 0{
                        if cardPlayed["suit"] as! String == "heart"{
                            
                            seat.seatImage.image = UIImage(named: "7_of_hearts")
                        }
                        if cardPlayed["suit"] as! String == "diamond"{
                            seat.seatImage.image = UIImage(named: "7_of_diamonds")
                        }
                        if cardPlayed["suit"] as! String == "club"{
                            seat.seatImage.image = UIImage(named: "7_of_clubs")
                        }
                        if cardPlayed["suit"] as! String == "spade"{
                            seat.seatImage.image = UIImage(named: "7_of_spades")
                        }
                    }
                    if cardPlayed["rank"] as! Int64 == 1{
                        if cardPlayed["suit"] as! String == "heart"{
                            seat.seatImage.image = UIImage(named: "8_of_hearts")
                        }
                        if cardPlayed["suit"] as! String == "diamond"{
                            seat.seatImage.image = UIImage(named: "8_of_diamonds")
                        }
                        if cardPlayed["suit"] as! String == "club"{
                            seat.seatImage.image = UIImage(named: "8_of_clubs")
                        }
                        if cardPlayed["suit"] as! String == "spade"{
                            seat.seatImage.image = UIImage(named: "8_of_spades")
                        }
                    }
                    if cardPlayed["rank"] as! Int64 == 2{
                        if cardPlayed["suit"] as! String == "heart"{
                            seat.seatImage.image = UIImage(named: "9_of_hearts")
                        }
                        if cardPlayed["suit"] as! String == "diamond"{
                            seat.seatImage.image = UIImage(named: "9_of_diamonds")
                        }
                        if cardPlayed["suit"] as! String == "club"{
                            seat.seatImage.image = UIImage(named: "9_of_clubs")
                        }
                        if cardPlayed["suit"] as! String == "spade"{
                            seat.seatImage.image = UIImage(named: "9_of_spades")
                        }
                    }
                    if cardPlayed["rank"] as! Int64 == 3{
                        if cardPlayed["suit"] as! String == "heart"{
                            seat.seatImage.image = UIImage(named: "10_of_hearts")
                        }
                        if cardPlayed["suit"] as! String == "diamond"{
                            seat.seatImage.image = UIImage(named: "10_of_diamonds")
                        }
                        if cardPlayed["suit"] as! String == "club"{
                            seat.seatImage.image = UIImage(named: "10_of_clubs")
                        }
                        if cardPlayed["suit"] as! String == "spade"{
                            seat.seatImage.image = UIImage(named: "10_of_spades")
                        }
                    }
                    if cardPlayed["rank"] as! Int64 == 4{
                        if cardPlayed["suit"] as! String == "heart"{
                            seat.seatImage.image = UIImage(named: "jack_of_hearts")
                        }
                        if cardPlayed["suit"] as! String == "diamond"{
                            seat.seatImage.image = UIImage(named: "jack_of_diamonds")
                        }
                        if cardPlayed["suit"] as! String == "club"{
                            seat.seatImage.image = UIImage(named: "jack_of_clubs")
                        }
                        if cardPlayed["suit"] as! String == "spade"{
                            seat.seatImage.image = UIImage(named: "jack_of_spades")
                        }
                    }
                    if cardPlayed["rank"] as! Int64 == 5{
                        if cardPlayed["suit"] as! String == "heart"{
                            seat.seatImage.image = UIImage(named: "queen_of_hearts")
                        }
                        if cardPlayed["suit"] as! String == "diamond"{
                            seat.seatImage.image = UIImage(named: "queen_of_diamonds")
                        }
                        if cardPlayed["suit"] as! String == "club"{
                            seat.seatImage.image = UIImage(named: "queen_of_clubs")
                        }
                        if cardPlayed["suit"] as! String == "spade"{
                            seat.seatImage.image = UIImage(named: "queen_of_spades")
                        }
                    }
                    if cardPlayed["rank"] as! Int64 == 6{
                        if cardPlayed["suit"] as! String == "heart"{
                            seat.seatImage.image = UIImage(named: "king_of_hearts")
                        }
                        if cardPlayed["suit"] as! String == "diamond"{
                            seat.seatImage.image = UIImage(named: "king_of_diamonds")
                        }
                        if cardPlayed["suit"] as! String == "club"{
                            seat.seatImage.image = UIImage(named: "king_of_clubs")
                        }
                        if cardPlayed["suit"] as! String == "spade"{
                            seat.seatImage.image = UIImage(named: "king_of_spades")
                        }
                    }
                    if cardPlayed["rank"] as! Int64 == 7{
                        if cardPlayed["suit"] as! String == "heart"{
                            seat.seatImage.image = UIImage(named: "ace_of_hearts")
                        }
                        if cardPlayed["suit"] as! String == "diamond"{
                            seat.seatImage.image = UIImage(named: "ace_of_diamonds")
                        }
                        if cardPlayed["suit"] as! String == "club"{
                            seat.seatImage.image = UIImage(named: "ace_of_clubs")
                        }
                        if cardPlayed["suit"] as! String == "spade"{
                            seat.seatImage.image = UIImage(named: "ace_of_spades")
                        }
                    }
                }
            }
        }
        
        socket.on("roundResult"){data, ack in
            print("Winner player is: \(data)")
            let result = data[0] as! [String:Any]
            let winnerID = result["winnerID"] as! String
            let teamMateID = result["teamMateID"] as! String
            let score = result["score"] as! Int
            
            if self.seat1.player.uid == winnerID || self.seat1.player.uid == teamMateID{
                self.team1Score.text = "Team 1: " + String(score)
            }else{
                self.team2Score.text = "Team 2: " + String(score)
            }

            
            
            
            //            let score = result["score"] as! Int
            //            let winnerID = result["winnerID"] as! String
            //            for seat in self.totalSeatPlayers{
            //                if winnerID == seat.player.uid{
            //                    self.waitingLabel.text = "Player " + String(seat.player.playerNum) + " wins!"
            //                    if seat.player.playerNum == 1 || seat.player.playerNum == 3{
            //                        self.team1Score.text = "Team 1: " + String(score)
            //                    }else{
            //                        self.team2Score.text = "Team 2: " + String(score)
            //                    }
            //                }
            //            }
        }
        
        socket.on("clearWageCard"){ data, ack in
            self.wagerCard.isHidden = true
        }
        
        socket.on("clearAtout"){data, ack in
            self.atoutLabel.text = ""
            self.atoutSelected = ""
        }
        
        socket.on("clearBoard") {data, ack in
            let when = DispatchTime.now() + 3 // number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                // Your code with delay
                for seat in self.totalSeatPlayers{
                    seat.seatImage.image = nil
                }
            }
        }
        socket.connect()
    }
    
    func setUsername(username:String){
        tempUsername = username
    }
    
    
    func pingServer(){
        var urlRequest = URLRequest(url: URL(string:"http://159.203.87.174:5858")!)
        
        //setting the method to post
        urlRequest.httpMethod = "POST"
        
        //url params
        let postString = "name=Test"
        //create as data element
        urlRequest.httpBody = postString.data(using: .utf8)
        //task that sends request
        let task = URLSession.shared.dataTask(with: urlRequest){
            data,response,error in
            //checking for errors
            guard let data = data, error == nil else{
                print(error!)
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{
                print(httpStatus.statusCode)
                print(response!)
                return
            }
            let responseString = String(data:data, encoding:.utf8)
            print(responseString!)
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
            cardImageArray[index].isHidden = false
        }
    }
    
    func moveImage(view: UIImageView) -> UIImageView{
        UIView.animate(withDuration: 0.2, animations: {
            view.frame.origin.y -= 20
        })
        return view
    }
    
    func cardImageTapped(sender:UITapGestureRecognizer){
        
        tapCount += 1
        print(sender.view!)
        print(tapCount)
        if tapCount == 1{
            selectedCardView = moveImage(view: sender.view as! UIImageView)
        }
        
        if tapCount == 2 {
            if sender.view == selectedCardView{
                tapCount = 0
                
                let tag = sender.view!.tag
                
                //send player card value
                if seat1.player.cardsInHand[tag].suit.rawValue == atoutSelected{
                    socket.emit("cardPlayed", ["id":uid,"rank":seat1.player.cardsInHand[tag].rank.rawValue, "suit":seat1.player.cardsInHand[tag].suit.rawValue, "value":seat1.player.cardsInHand[tag].rank.cardsValueAtout()])
                  //  waitingLabel.isHidden = false
                }else{
                    socket.emit("cardPlayed", ["id":uid,"rank":seat1.player.cardsInHand[tag].rank.rawValue, "suit":seat1.player.cardsInHand[tag].suit.rawValue, "value":seat1.player.cardsInHand[tag].rank.cardsValueNonAtout()])
                   // waitingLabel.isHidden = false
                }
                
                
                cardImageArray[tag].isHidden = true
                selectedCardView.transform = CGAffineTransform(translationX: 0, y: 0)
                cardImageArray.remove(at: tag)
                seat1.player.cardsInHand.remove(at: tag)
                
                if seat1.player.cardsInHand.count != 0{
                    cardInteraction()
                    
                }else{
                    newGameBtn.isHidden = false
                }
                
                tapCount = 0
            }else{
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.selectedCardView.frame.origin.y += 20
                })
                tapCount = 0
            }
        }
    }
    
    @IBAction func nudgeBtn(_ sender: UIButton) {
        socket.emit("nudge", ["uid":seat1.player.uid, "message":"Hurry up!"])
    }
    
    @IBAction func newGameBtn(_ sender: UIButton) {
        socket.emit("startGame", ["uid":seat1.player.uid])
    }
    
    
    @IBAction func logoutBtn(_ sender: UIButton) {
        do{
            try FIRAuth.auth()?.signOut()
            socket.emit("playerLeft", ["uid":seat1.player.uid])
            self.dismiss(animated: true, completion: nil)
        }catch{
            print(error)
        }
    }
}
