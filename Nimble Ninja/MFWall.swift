//
//  MFWall.swift
//  Nimble Ninja
//
//  Created by Matthew Frampton on 04/09/2015.
//  Copyright (c) 2015 theswiftproject. All rights reserved.
//

import Foundation
import SpriteKit

class MFWall: SKSpriteNode {
    
    let WALL_WIDTH: CGFloat = 30.0
    let WALL_HEIGHT: CGFloat = 50.0
    let WALL_COLOR = UIColor.blackColor()
    
    init(){
        super.init(texture: nil, color: WALL_COLOR, size: CGSizeMake(WALL_WIDTH, WALL_HEIGHT))
        startMoving()
    }

      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
    }
    
    func startMoving(){
        let moveLeft = SKAction.moveByX(-kDefaultXToMovePerSecond, y: 0, duration: 1)
        runAction(SKAction.repeatActionForever(moveLeft))
    }
    
}