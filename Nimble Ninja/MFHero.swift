//
//  MFHero.swift
//  Nimble Ninja
//
//  Created by Matthew Frampton on 01/09/2015.
//  Copyright (c) 2015 theswiftproject. All rights reserved.
//

import Foundation
import SpriteKit

class MFHero:SKSpriteNode{
    
    var body: SKSpriteNode!
    var arm: SKSpriteNode!
    var leftfoot: SKSpriteNode!
    var rightfoot: SKSpriteNode!
    var isUpsideDown = false
    
    init(){
        let size = CGSizeMake(32, 44)
        super.init(texture: nil, color: UIColor.clearColor(),size: size)
        
        loadAppearance()
        loadPhysicsBodyWithSize(size)
        
    }
    
    func loadAppearance(){
        body = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(self.frame.size.width,44))
        body.position = CGPointMake(0, 2)
        addChild(body)
        
        let skinColour = UIColor(red: 207.0/255.0, green: 193.0/255.0, blue: 168/255.0, alpha: 1.0)
        let face = SKSpriteNode(color: skinColour, size: CGSizeMake(self.frame.size.width, 12))
        face.position = CGPointMake(0, 6)
        body.addChild(face)
        
        let eyeColor = UIColor.whiteColor()
        let leftEye = SKSpriteNode(color: eyeColor, size:CGSizeMake(6, 6))
        let rightEye = leftEye.copy() as! SKSpriteNode
        let pupil = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(3, 3))
        
        pupil.position = CGPointMake(2, 0)
        leftEye.addChild(pupil)
        rightEye.addChild(pupil.copy() as! SKSpriteNode)
        
        leftEye.position = CGPointMake(-4, 0)
        face.addChild(leftEye)
        
        rightEye.position = CGPointMake(14, 0)
        face.addChild(rightEye)
        
        let eyebrow = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(11, 1))
        eyebrow.position = CGPointMake(-1, leftEye.size.height/2)
        leftEye.addChild(eyebrow)
        rightEye.addChild(eyebrow.copy() as! SKSpriteNode)
        
        let armColor = UIColor(red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0)
        arm = SKSpriteNode(color: armColor, size: CGSizeMake(8, 14))
        arm.anchorPoint = CGPointMake(0.5, 0.9)
        arm.position = CGPointMake(-10, -7)
        body.addChild(arm)
        
        let hand = SKSpriteNode(color: skinColour, size: CGSizeMake(arm.size.width, 5))
        hand.position = CGPointMake(0, -arm.size.height*0.9+hand.size.height/2)
        arm.addChild(hand)
        
        leftfoot = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(9, 4))
        leftfoot.position = CGPointMake( -6, -size.height/2 + leftfoot.size.height/2)
        addChild(leftfoot)
        
        rightfoot = leftfoot.copy() as!  SKSpriteNode
        rightfoot.position.x = 8
        addChild(rightfoot)
    }
    
    func loadPhysicsBodyWithSize(size: CGSize){
        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        //This says: When do you want the hero to register contact with an object
        physicsBody?.categoryBitMask = heroCatagory
        physicsBody?.contactTestBitMask = wallCatagory
        physicsBody?.affectedByGravity = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func flip(){
        //print(size.height)

        
        isUpsideDown = !isUpsideDown
        
        var scale: CGFloat!
        if isUpsideDown{
            scale = -1.0
        }else{
            scale = 1.0
        }
        
        //let translate = SKAction.moveByX(0, y: scale*(size.height + KMLGroundHeight), duration:0.1)
        let translate = SKAction.moveByX(0, y: scale*(44 + KMLGroundHeight), duration: 0.1)
        let flip = SKAction.scaleYTo(scale, duration: 0)
        
        //print(size.height)
        
        runAction(flip)
        runAction(translate)
        
        //print(size.height)
    }
    
    func fall(){
        physicsBody?.affectedByGravity = true
        physicsBody?.applyImpulse(CGVectorMake(-5, 30))
        
        let rotateBack = SKAction.rotateByAngle(CGFloat(M_PI) / 2, duration: 0.4)
        runAction(rotateBack)
    }
    
    func startRunning(){
        let rotateBack = SKAction.rotateByAngle(CGFloat(-M_PI)/2.0, duration: 0.1)
        arm.runAction(rotateBack)
        
        performOneRunCycle()
    }
    
    func performOneRunCycle(){
        let up = SKAction.moveByX(0, y: 2, duration: 0.05)
        let down = SKAction.moveByX(0, y: -2, duration: 0.05)
        
        //when left foot complete actions, will run the following
        leftfoot.runAction(up, completion: {() -> Void in
            self.leftfoot.runAction(down)
            self.rightfoot.runAction(up, completion: {() -> Void in
                self.rightfoot.runAction(down, completion: {() -> Void in
                    self.performOneRunCycle()
                })
            })
        })
    }
    
    func breath(){
        let breathOut = SKAction.moveByX(0, y: -1, duration: 1)
        let breathIN = SKAction.moveByX(0, y: 1, duration: 1)
        let breath = SKAction.sequence([breathOut, breathIN])
        body.runAction(SKAction.repeatActionForever(breath))
    }
    
    func stop(){
        body.removeAllActions()
        leftfoot.removeAllActions()
        rightfoot.removeAllActions()
    }
    
}
//up to tutorial 6