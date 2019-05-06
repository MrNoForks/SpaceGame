//
//  GameScene.swift
//  SpaceGame
//
//  Created by Boppo on 06/05/19.
//  Copyright © 2019 Boppo. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var starField : SKEmitterNode!
    var player:SKSpriteNode!
    
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
    }
    

    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
