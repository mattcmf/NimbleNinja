//
//  GameScene.swift
//  Nimble Ninja
//
//  Created by Matthew Frampton on 01/09/2015.
//  Copyright (c) 2015 theswiftproject. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var movingGround: MFMovingGround!
    var hero: MFHero!
    var cloudGenerator = MFCloudGenerator()
    var wallGenerator = MFWallGenerator()
    
    var isStarted = false
    var isGameOver = false
    
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
        
        //Add physics world
        //Delegate = promise of a certain class that will implement certain methods
        physicsWorld.contactDelegate = self
    }
    
    //MARK: - Game Lifecycle
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
    
    func gameOver(){
        //stop everything
        isGameOver = true
        hero.physicsBody = nil 
        wallGenerator.stopWalls()
        movingGround.stop()
        hero.stop()
        
        //create gameover label
        let gameOverLabel = SKLabelNode(text: "Game Over!")
        gameOverLabel.fontColor = UIColor.blackColor()
        gameOverLabel.fontName = "Helvetica"
        gameOverLabel.position.x = view!.center.x
        gameOverLabel.position.y = view!.center.y + 40
        gameOverLabel.fontSize = 22.0
        addChild(gameOverLabel)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if isGameOver{
            restart()
        }
        else if !isStarted{
            start()
        }else{
         hero.flip()
        }
    }
    
    func restart(){
        cloudGenerator.stopGenerating()
        let newScene = GameScene(size: view!.bounds.size)
        newScene.scaleMode = .AspectFill
        
        view!.presentScene(newScene)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    //MARK: - SK physics SK delegate
    func didBeginContact(contact: SKPhysicsContact) {
        gameOver()
        println("did begin contact caller")
    }
}
