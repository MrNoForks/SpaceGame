//
//  GameScene.swift
//  SpaceGame
//
//  Created by Boppo on 06/05/19.
//  Copyright © 2019 Boppo. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene , SKPhysicsContactDelegate {
    
    var starField : SKEmitterNode!
    var player:SKSpriteNode!
    
    
    var scoreLabel : SKLabelNode!
    var score : Int = 0 {
        didSet{
            scoreLabel.text = "Score : \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        starField = SKEmitterNode(fileNamed: "Starfield")
        starField.position = CGPoint(x: 0, y: size.height)
        
        // To advancce the fall of stars by 10 seconds
        starField.advanceSimulationTime(10)
        
        self.addChild(starField)
        
        //So that is always behind everything we set z =-1
        starField.zPosition = -1
        
        
        
        player = SKSpriteNode(imageNamed: "shuttle")
        
        player.position = CGPoint(x: 0, y: -(size.height/2) + (player.size.height + 20))
        
        self.addChild(player)
        
       // A vector that specifies the gravitational acceleration applied to physics bodies in the physics world
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        //A delegate that is called when two physics bodies come in contact with each other.
        self.physicsWorld.contactDelegate = self
        
        
        scoreLabel = SKLabelNode(text: "Score : 0")
        
        scoreLabel.position = CGPoint(x : 0,y : (size.height/2) - 100)
        scoreLabel.fontName = "AppleSDGothicNeo-Medium"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        self.addChild(scoreLabel)
        
    }
    

    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
