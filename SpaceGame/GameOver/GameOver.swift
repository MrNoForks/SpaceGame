//
//  GameOver.swift
//  SpaceGame
//
//  Created by Boppo on 07/05/19.
//  Copyright © 2019 Boppo. All rights reserved.
//

import SpriteKit

class GameOver: SKScene {

    var newGameButton : SKSpriteNode!

    var scoreLabel : SKLabelNode!
    
    var score : Int = 0
    
    override func didMove(to view: SKView) {
        
        scoreLabel = self.childNode(withName: "scoreLabel") as? SKLabelNode
        
        scoreLabel.text = "\(score)"
        
        
        newGameButton = self.childNode(withName: "newGameButton") as? SKSpriteNode
        
        newGameButton.texture = SKTexture(imageNamed: "newGameButton")

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        
        if let location = touch?.location(in: self){            
            
            guard let node = self.nodes(at: location).first else { return}
            
            if node.name == "newGameButton"{
                
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                
                //let gameScene = GameScene(size: self.size)
                
                let gameScene = SKScene(fileNamed: "MainScene")!
                
                gameScene.scaleMode = .aspectFill
                
                self.view!.presentScene(gameScene, transition: transition)
            }
        }
    }
    
}
