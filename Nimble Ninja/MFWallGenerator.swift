//
//  MFWallGenerator.swift
//  Nimble Ninja
//
//  Created by Matthew Frampton on 04/09/2015.
//  Copyright (c) 2015 theswiftproject. All rights reserved.
//

import Foundation
import SpriteKit

class MFWallGenerator: SKSpriteNode{
    
    var generationTimer: NSTimer!
    var walls = [MFWall]()
    var wallTrackers = [MFWall]()
    
    
    func startGeneratingWallsEvery(seconds: NSTimeInterval){
        generationTimer = NSTimer.scheduledTimerWithTimeInterval(seconds, target: self, selector: "generateWall", userInfo: nil, repeats: true)
    }
    
    func stopGenerating(){
        generationTimer?.invalidate()
    }
    
    func generateWall(){
        var scale: CGFloat
        let rand = arc4random_uniform(2)
        if rand == 0{
            scale = -1.0
        }else{
            scale = 1.0
        }
        
        let wall = MFWall()
        wall.position.x = size.width/2 + wall.size.width/2
        wall.position.y = scale * (KMLGroundHeight/2 + wall.size.height/2)
        walls.append(wall)
        wallTrackers.append(wall)
        addChild(wall)

    }
    
    func stopWalls(){
        stopGenerating()
        for wall in walls{
            wall.stopMoving()
        }
    }
    
}