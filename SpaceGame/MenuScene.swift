//
//  MenuScene.swift
//  SpaceGame
//
//  Created by Boppo on 07/05/19.
//  Copyright © 2019 Boppo. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {

    var starField : SKEmitterNode!
    
    var newGameButtonNode : SKSpriteNode!
    
    var difficultyButtonNode : SKSpriteNode!
    
    var difficultyLabelNode : SKLabelNode!
    
    override func didMove(to view: SKView) {
        
        //gets the childNode from scene with specific name
        starField = self.childNode(withName: "starField") as? SKEmitterNode
        
        //advance the simulation by 10 seconds
        starField.advanceSimulationTime(10)
        
        newGameButtonNode = self.childNode(withName: "newGameButton") as? SKSpriteNode
        
        difficultyButtonNode = self.childNode(withName: "difficultyButton") as? SKSpriteNode
        
        
        //texture through code
        difficultyButtonNode.texture = SKTexture(imageNamed: "difficultyButton")
        
        difficultyLabelNode = self.childNode(withName: "difficultyLabel") as? SKLabelNode
        
         
    }
    
}
