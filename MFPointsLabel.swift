//
//  MFPointsLabel.swift
//  Nimble Ninja
//
//  Created by Matthew Frampton on 13/10/2015.
//  Copyright © 2015 theswiftproject. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class MFPointsLabel : SKLabelNode{
    
    var number = 0
    
    init(num: Int){
        super.init()
        
        fontColor = UIColor.blackColor()
        fontName =  "Helvetica"
        fontSize = 20.0

        number = num
        text = "\(num)"
    
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func increment(){
        number++
        text = "\(number)"
    }
    
    func setTo(num: Int){
        self.number = num
        text = "\(self.number)"
    }
}
