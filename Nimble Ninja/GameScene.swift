//
//  GameScene.swift
//  Nimble Ninja
//
//  Created by Matthew Frampton on 01/09/2015.
//  Copyright (c) 2015 theswiftproject. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var movingGround: MFMovingGround!
    var hero: MFHero!
    var isStarted = false
    var cloudGenerator = MFCloudGenerator()
    var wallGenerator = MFWallGenerator()
    
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor(red: 159.0/255.0, green: 201.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        
        //Add Ground
        movingGround = MFMovingGround(size: CGSizeMake(view.frame.width, KMLGroundHeight))
        movingGround.position = CGPointMake(0, view.frame.size.height/2)
        addChild(movingGround)
        
        //Add Hero
        hero = MFHero()
        hero.position = CGPointMake(70,movingGround.position.y + movingGround.frame.size.height/2 + hero.frame.size.height/2)
        addChild(hero)
        hero.breath()
        
        //Add Cloud Generator
        cloudGenerator = MFCloudGenerator(color: UIColor.clearColor(), size: view.frame.size)
        cloudGenerator.position = view.center
        addChild(cloudGenerator)
        cloudGenerator.populate(7)
        cloudGenerator.startGeneratingWithSpawnTime(5)
        
        //Add Wall
        wallGenerator = MFWallGenerator(color: UIColor.clearColor(), size: view.frame.size)
        wallGenerator.position = view.center
        
        //Add Start Label
        let tapToStartLabel = SKLabelNode(text: "Tap to start!")
        tapToStartLabel.name = "tapToStartLabel"
        tapToStartLabel.position.x = view.center.x
        tapToStartLabel.position.y = view.center.y + 40
        tapToStartLabel.fontName = "Helvitica"
        tapToStartLabel.fontColor = UIColor.blackColor()
        tapToStartLabel.fontSize = 22.0
        addChild(tapToStartLabel)
    }
    
    func start(){
        isStarted = true
        
        let tapToStartLabel = childNodeWithName("tapToStartLabel")
        tapToStartLabel?.removeFromParent()
        
        hero.stop()
        hero.startRunning()
        movingGround.start()
        addChild(wallGenerator)
        wallGenerator.startGeneratingWallsEvery(1)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if !isStarted{
            start()
        }else{
         hero.flip()
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
