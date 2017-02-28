//
//  cardView.swift
//  French Belote
//
//  Created by Stefan Auvergne on 12/6/16.
//  Copyright © 2016 com.example. All rights reserved.
//

import Foundation
import UIKit

class CardView:UIImageView{
    
    var tapGesture:UITapGestureRecognizer!
    var card:Card!
    var number:Int!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        tapGesture = UITapGestureRecognizer()
      //  card = Card(rank:Card.Rank.se)
    }
    
}
