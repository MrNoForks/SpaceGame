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
        
        
        let userDefaults = UserDefaults.standard
        
        //Getting UserDefaults Value
        if userDefaults.bool(forKey: "Hard"){
            difficultyLabelNode.text = "Hard"
        }
        else{
            difficultyLabelNode.text = "Easy"
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //get first touch
        let touch = touches.first
        
        // get location of touch
        if let location = touch?.location(in: self){
            
            //It returns all of the nodes at the location i.e. nodes at given touch location
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "newGameButton"{
                
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                
                let gameScene = GameScene(size: self.size)
                
                gameScene.scaleMode = .aspectFill
                
                //Transitions from the current scene to a new scene.
                self.view?.presentScene(gameScene, transition: transition)
            }
            
            else if nodesArray.first?.name == "difficultyButton"{
                changeDifficulty()
            }
            
        }
    }
    
    
    func changeDifficulty(){
        
        //UserDefaults To save the game mode
        //UserDefault is thread safe and it caches the data so it doesnt have to relookup UserDefault database
        //Max size 1 MB and 1024 keys allowed if exceeded it sends a notification warning
        
        //UserDefaults.standard creates a shared instance of User Default
        let userDefaults = UserDefaults.standard
        
        if difficultyLabelNode.text == "Easy"{
            
            difficultyLabelNode.text = "Hard"
            
            //Setting userDefaults Value
            userDefaults.set(true, forKey: "Hard")
            
        }
        else{
            
            difficultyLabelNode.text = "Easy"
            
            //Setting userDefaults Value
            userDefaults.set(false, forKey: "Hard")
        }
        
        
        //Waits for any pending asynchronous updates to the defaults database and returns; this method is unnecessary and shouldn't be used.
        //true if the data was saved successfully to disk, otherwise false.
        // userDefaults.synchronize()
        
    }
    
}
