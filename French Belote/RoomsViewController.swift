//
//  RoomsViewController.swift
//  French Belote
//
//  Created by Stefan Auvergne on 4/30/17.
//  Copyright © 2017 com.example. All rights reserved.
//

import UIKit
import SocketIO
import FirebaseAuth


class RoomsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var usernamePassed = ""
    var socket2:SocketIOClient!
    var listOfIdRooms = [String]()
    var listOfNameRooms = [String]()
    var listOfPlayersInEachRoom = [Int]()
    var uid:String!
    
     let prefs = UserDefaults.standard
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(RoomsViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    @IBOutlet weak var createRoomBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var roomNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createRoomBtn.layer.cornerRadius = 10.0
        createRoomBtn.clipsToBounds = true
        createRoomBtn.layer.borderWidth = 1
        createRoomBtn.layer.borderColor = UIColor.darkGray.cgColor
        
        self.tableView.addSubview(self.refreshControl)

        // save user ID
        uid = FIRAuth.auth()?.currentUser?.uid
        prefs.set(uid, forKey: "userID")
        prefs.set(usernamePassed, forKey: "username")
          openSocket()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let temp = self.prefs.object(forKey: "userID") as? String{
            self.uid = temp
        }
        if let temp = self.prefs.object(forKey: "username") as? String{
            self.usernamePassed = temp
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        socket2.emit("refreshTableView")
        refreshControl.endRefreshing()
    }
    
    @IBAction func createRoom(_ sender: UIButton) {
        let name = roomNameTextField.text
        socket2.emit("createRoom", ["name":name])
    }

    func setUsername(username:String){
        usernamePassed = username
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let x = indexPath.row
            listOfPlayersInEachRoom.remove(at: x)
            listOfNameRooms.remove(at: x)
            listOfIdRooms.remove(at: x)
            socket2.emit("removeRoom", ["roomID":listOfIdRooms[x]])
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfIdRooms.count // your number of cell here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "roomCell") as UITableViewCell!
        let x = indexPath.row
        cell.textLabel?.text = listOfNameRooms[x]
        cell.detailTextLabel?.text = String(listOfPlayersInEachRoom[x]) + " Player(s)"
        return cell
    }

    func openSocket(){
        socket2 = SocketIOClient(socketURL: URL(string: "http://fitchal.website")!, config: [.log(true), .forcePolling(true)])
        socket2.on("connect") {data, ack in
            //do nothing
        }
        
        socket2.on("allRooms"){data, ack in
            print(data[0])
            self.listOfIdRooms.removeAll()
            self.listOfNameRooms.removeAll()
            self.listOfPlayersInEachRoom.removeAll()
            let temp = data[0] as! [AnyObject]
            if temp.count != 0{
                for index in 0...temp.count-1{
                    let dictionary = temp[index] as! [String:Any]
                    let roomId = dictionary["id"] as! String
                    let name = dictionary["name"] as! String
                    let players = dictionary["players"] as! [AnyObject]
                    self.listOfPlayersInEachRoom.append(players.count)
                    self.listOfNameRooms.append(name)
                    self.listOfIdRooms.append(roomId)
                }
            }
            self.tableView.reloadData()
        }
        
        socket2.connect()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let x = tableView.indexPathForSelectedRow?.row
        let gameVC:GameViewController = segue.destination as! GameViewController
        //pass username to GameViewController
        gameVC.setUsername(username: usernamePassed)
        //pass roomID to GameViewController
        gameVC.setRoomId(roomID: listOfIdRooms[x!])
        //pass userID to GameViewController
        gameVC.setUserID(userID: uid)
    }
 
}


