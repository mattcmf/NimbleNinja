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
    
    var currentLevel = 0
    
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor(red: 159.0/255.0, green: 201.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        
        addMovingGround()
        addHero()
        addCloudGenerator()
        addWallGenerator()
        addTapToStartLabel()
        addPhysicalWorld()
        addPointsLabels()
        loadHighScore()
    }
    
    func addMovingGround(){
        movingGround = MFMovingGround(size: CGSizeMake(view!.frame.width, KMLGroundHeight))
        movingGround.position = CGPointMake(0, view!.frame.size.height/2)
        addChild(movingGround)
    }
    
    func addHero(){
        hero = MFHero()
        hero.position = CGPointMake(70,movingGround.position.y + movingGround.frame.size.height/2 + hero.frame.size.height/2)
        addChild(hero)
        hero.breath()
    }
    
    func addCloudGenerator(){
        cloudGenerator = MFCloudGenerator(color: UIColor.clearColor(), size: view!.frame.size)
        cloudGenerator.position = view!.center
        addChild(cloudGenerator)
        cloudGenerator.populate(7)
        cloudGenerator.startGeneratingWithSpawnTime(5)
    }
    
    func addWallGenerator(){
        wallGenerator = MFWallGenerator(color: UIColor.clearColor(), size: view!.frame.size)
        wallGenerator.position = view!.center
    }
    
    func addTapToStartLabel(){
        let tapToStartLabel = SKLabelNode(text: "Tap to start!")
        tapToStartLabel.name = "tapToStartLabel"
        tapToStartLabel.position.x = view!.center.x
        tapToStartLabel.position.y = view!.center.y + 40
        tapToStartLabel.fontName = "Helvitica"
        tapToStartLabel.fontColor = UIColor.blackColor()
        tapToStartLabel.fontSize = 28.0
        addChild(tapToStartLabel)
        tapToStartLabel.runAction(blinkAnimation())
    }
    
    func addPointsLabels(){
        let pointsLabel = MFPointsLabel(num: 0)
        pointsLabel.position = CGPointMake(20.0, (view?.frame.size.height)! - 35)
        pointsLabel.name = "PointsLabel"
        addChild(pointsLabel)
        
        let highScoreLabel = MFPointsLabel(num: 0)
        highScoreLabel.position = CGPointMake(view!.frame.size.width - 35, view!.frame.size.height - 35)
        highScoreLabel.name = "HighScoreLabel"
        addChild(highScoreLabel)
        
        let highScoreTextLabel = SKLabelNode(text: "Highscore")
        highScoreTextLabel.fontColor = UIColor.blackColor()
        highScoreTextLabel.fontSize = 14
        highScoreTextLabel.fontName = "Helvitica"
        highScoreTextLabel.position = CGPointMake(0, -30)
        highScoreLabel.addChild(highScoreTextLabel)
    }
    
    func addPhysicalWorld(){
        physicsWorld.contactDelegate = self
    }
    
    func loadHighScore(){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let highScoreLabel = childNodeWithName("HighScoreLabel") as! MFPointsLabel
        
        highScoreLabel.setTo(defaults.integerForKey("highscore"))
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
        hero.fall()
        wallGenerator.stopWalls()
        movingGround.stop()
        hero.stop()
        
        //create gameover label
        let gameOverLabel = SKLabelNode(text: "Game Over!")
        gameOverLabel.fontColor = UIColor.blackColor()
        gameOverLabel.fontName = "Helvetica"
        gameOverLabel.position.x = view!.center.x
        gameOverLabel.position.y = view!.center.y + 40
        gameOverLabel.fontSize = 28.0
        addChild(gameOverLabel)
        gameOverLabel.runAction(blinkAnimation())
        
        //save current points label value
        let pointsLabel = childNodeWithName("PointsLabel") as! MFPointsLabel
        let highScoreLabel = childNodeWithName("HighScoreLabel") as! MFPointsLabel
        
        if highScoreLabel.number < pointsLabel.number{
            highScoreLabel.setTo(pointsLabel.number)
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setInteger(highScoreLabel.number, forKey: "highscore")
        }
    }
    

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
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
        if wallGenerator.wallTrackers.count > 0 {
            let wall = wallGenerator.wallTrackers[0] as MFWall
            
            let wallLocation = wallGenerator.convertPoint(wall.position, toNode: self)
            if wallLocation.x < hero.position.x{
                wallGenerator.wallTrackers.removeAtIndex(0)
                
                let pointsLabel = childNodeWithName("PointsLabel") as! MFPointsLabel
                pointsLabel.increment()
                
                if (pointsLabel.number % kNumberOfPointsPerLevel == 0) && (currentLevel < kLevelGenerationTimes.count-1) {
                    currentLevel++
                    wallGenerator.stopGenerating()
                    wallGenerator.startGeneratingWallsEvery(kLevelGenerationTimes[currentLevel])
                }
                
                //Increase speed
                //kDefaultXToMovePerSecond + 25
                //print ("Speed = ", kDefaultXToMovePerSecond)
            }
        }
    }
    
    //MARK: - SK physics SK delegate
    func didBeginContact(contact: SKPhysicsContact) {
        if !isGameOver{
            gameOver()
        }
        print("did begin contact caller")
    }
    
    //MARK: - Animations
    func blinkAnimation() -> SKAction{
        let duration = 0.4
        let fadeOut = SKAction.fadeAlphaTo(0.0, duration: duration)
        let fadeIn =  SKAction.fadeAlphaTo(1.0, duration: duration)
        let blink = SKAction.sequence([fadeIn,fadeOut])
        return SKAction.repeatActionForever(blink)
        
    }
}
