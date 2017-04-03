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
    
    @IBOutlet weak var selectAtout: UILabel!
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var player2NameLabel: UILabel!
    @IBOutlet weak var atoutLabel: UILabel!
    
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
    
    @IBOutlet weak var playedCard1: UIImageView!
    @IBOutlet weak var playedCard2: UIImageView!
    @IBOutlet weak var playedCard3: UIImageView!
    @IBOutlet weak var playedCard4: UIImageView!
    @IBOutlet weak var pass: UIButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uid = FIRAuth.auth()?.currentUser?.uid
        openSocket()
        //pingServer()
        
        seat1 = Seat()
        seat1.player = Player(playerNum: 1)
        seat1.player.uid = uid
        seat1.seatImage = playedCard1
        
        totalSeatPlayers.append(seat1)
        
        newGameBtn.isHidden = true
        
        cardImageArray = [card1, card2, card3, card4, card5, card6, card7, card8]
        
        cardInteraction()
        
        selectAtout.isHidden = true
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
            
        }else if sender.titleLabel?.text == "Pass"{
            
            socket.emit("setAtout", ["atout":"pass", "uid":seat1.player.uid])
            selectAtout.isHidden = true
            heartBtnOutlet.isHidden = true
            diamondBtnOutlet.isHidden = true
            clubBtnOutlet.isHidden = true
            spadeBtnOutlet.isHidden = true
            pass.isHidden = true
            return
        }
        
        socket.emit("setAtout", ["atout":atoutSelected])
        selectAtout.isHidden = true
        heartBtnOutlet.isHidden = true
        diamondBtnOutlet.isHidden = true
        clubBtnOutlet.isHidden = true
        spadeBtnOutlet.isHidden = true
        pass.isHidden = true
    }
    
    func openSocket(){
        socket = SocketIOClient(socketURL: URL(string: "http://fitchal.website")!, config: [.log(true), .forcePolling(true)])
        socket.on("connect") {data, ack in
            self.socket.emit("addNewPlayer", ["id":self.uid])
            self.socket.emit("updatePlayers")
            //check if seat is occupied by a player
            
        }
        
        //        socket.on("updatePlayers"){data, ack in
        //            print(data)
        //            //find out number of players
        //        }
        
        socket.on("playerJoined") {data, ack in
            let dictionary = data[0] as! [String:Any]
            let id = dictionary["id"] as! String
            for seat in self.totalSeatPlayers{
                
                if seat.player.uid == id{
                    //do nothing player already exists
                }else{
                    //add new player
                    if self.totalSeatPlayers.count == 1{
                        let player2 = Player(playerNum: self.totalSeatPlayers.count + 1)
                        let d = data[0] as! [String:String]
                        player2.uid = d["id"]
                        self.seat2 = Seat()
                        self.seat2.player = player2
                        self.player2NameLabel.text = "Player: " + String(player2.playerNum)
                        self.totalSeatPlayers.append(self.seat2)
                        self.seat2.seatImage = self.playedCard2
                    }else if self.totalSeatPlayers.count == 2{
                        let player3 = Player(playerNum: self.totalSeatPlayers.count + 1)
                        let d = data[0] as! [String:String]
                        player3.uid = d["id"]
                        self.seat3 = Seat()
                        self.seat3.player = player3
                        self.seat3.seatImage = self.playedCard3
                        //self.player3NameLabel.text = String(player3.playerNum)
                        self.totalSeatPlayers.append(self.seat2)
                    }else if self.totalSeatPlayers.count == 3{
                        let player4 = Player(playerNum: self.totalSeatPlayers.count + 1)
                        let d = data[0] as! [String:String]
                        player4.uid = d["id"]
                        self.seat4 = Seat()
                        self.seat4.player = player4
                        self.seat4.seatImage = self.playedCard4
                        //self.player4NameLabel.text = String(player4.playerNum)
                        self.totalSeatPlayers.append(self.seat2)
                    }
                }
            }
            
            self.newGameBtn.isHidden = false
            
            // var playersArray: [Player]
            // grab indices: playersArray.index(of: Player)
            // alternatively, have a Seat() class, Seat.player = Player()
        }
        
        socket.on("cardsDealt"){data, ack in
            self.newGameBtn.isHidden = true
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
                    
                    self.cardImageArray[5].image = UIImage(named:"back")
                    self.cardImageArray[6].image = UIImage(named:"back")
                    self.cardImageArray[7].image = UIImage(named:"back")
                    var maxCards = 5
                    if self.atoutSelected != ""{
                        maxCards = 8
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
                self.waitingLabel.isHidden = true
                self.selectAtout.isHidden = false
                self.heartBtnOutlet.isHidden = false
                self.diamondBtnOutlet.isHidden = false
                self.clubBtnOutlet.isHidden = false
                self.spadeBtnOutlet.isHidden = false
                self.pass.isHidden = false
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
            let score = result["score"] as! Int
            let winnerID = result["winnerID"] as! String
            for seat in self.totalSeatPlayers{
                if winnerID == seat.player.uid{
                    self.waitingLabel.text = "Player " + String(seat.player.playerNum) + " wins!"
                    if seat.player.playerNum == 1 || seat.player.playerNum == 3{
                        self.team1Score.text = "Team 1: " + String(score)
                    }else{
                        self.team2Score.text = "Team 2: " + String(score)
                    }
                }
            }
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
                    waitingLabel.isHidden = false
                }else{
                    socket.emit("cardPlayed", ["id":uid,"rank":seat1.player.cardsInHand[tag].rank.rawValue, "suit":seat1.player.cardsInHand[tag].suit.rawValue, "value":seat1.player.cardsInHand[tag].rank.cardsValueNonAtout()])
                    waitingLabel.isHidden = false
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
    
    
    @IBAction func newGameBtn(_ sender: UIButton) {
        socket.emit("startGame", ["uid":seat1.player.uid])
    }
    
}
