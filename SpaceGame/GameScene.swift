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
    
    private weak var gameTimer : Timer!
    
    private var possibleAliens = ["alien","alien2","alien3"]
    
    //bitwise left shift modifier to give each category a unique identifier to detect collision
    let alienCategory : UInt32 = 0x1 << 1
    //let alienCategory : UInt32 = 2
    
    let photonTorpedoCategory : UInt32 = 0x1 << 0
    //let photonTorpedoCategory : UInt32 = 1
    
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
        
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
        
    }
    
    
    @objc func addAlien(){
        
        //possibleAliens.shuffle()
        
       // Now when we add a new alien whole of array gets shuffled using GameplayKit
        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]

        let alien = SKSpriteNode(imageNamed: possibleAliens[0])
        
        
      //  let position =  arc4random_uniform(UInt32(size.height/2))
        
        // Now when we select a random position for aliens using GameplayKit
        let randomAlienPosition = GKRandomDistribution(lowestValue: -(Int(size.height/2)), highestValue: Int(size.height/2))
        
        let position = CGFloat(randomAlienPosition.nextInt())
        
        alien.position = CGPoint(x: position, y: (size.height/2) - alien.size.height)
        
        
        // To add a physicsbody to alien
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        
        alien.physicsBody?.isDynamic = true
        
        //Now we need Category bitmask,Contact test bitmask and a collision bitmask
        //Those are needed to actually calculate when are we hitting alien with an torpedo
        
        alien.physicsBody?.categoryBitMask = alienCategory
        alien.physicsBody?.contactTestBitMask = photonTorpedoCategory
        alien.physicsBody?.collisionBitMask = 0
        
        self.addChild(alien)
        
            //Moving aliens
        let animationDuration = TimeInterval(Int.random(in: 5...8))
        
        //Moving alien from top to the bottom of the screen
        //Then we will remove that alien from the screen  so it doesn't too much memory
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -(self.frame.height/2)), duration: animationDuration))
        
        actionArray.append(SKAction.removeFromParent())
        
        alien.run(SKAction.sequence(actionArray))
    }

    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
