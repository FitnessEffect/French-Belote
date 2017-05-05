//
//  Seat.swift
//  French Belote
//
//  Created by Stefan Auvergne on 3/16/17.
//  Copyright © 2017 com.example. All rights reserved.
//

import UIKit

class Seat: UIImageView {

    var player:Player!
    var seatImage:UIImageView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    deinit{
        print("DEinitialized")
    }

}
