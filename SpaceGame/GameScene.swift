//
//  GameScene.swift
//  SpaceGame
//
//  Created by Boppo on 06/05/19.
//  Copyright © 2019 Boppo. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

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
    
    let motionManager = CMMotionManager()
    var xAcceleration : CGFloat = 0
    
    override func didMove(to view: SKView) {
        
        starField = SKEmitterNode(fileNamed: "Starfield")
        starField.position = CGPoint(x: 0, y: size.height)
        
        // To advancce the fall of stars by 10 seconds
        starField.advanceSimulationTime(10)
        
        self.addChild(starField)
        
        //So that is always behind everything we set z =-1
        starField.zPosition = -1
        
        
        
        player = SKSpriteNode(imageNamed: "shuttle")
        
        player.setScale(2)
        
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
        
        
        motionManager.accelerometerUpdateInterval = 0.2
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            if let accelerometerData = data {
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0.25
            }
        }
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
        
        alien.setScale(2)
        
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

    
    func fireTorpedo(){
        
        //add sound to torpedo
        self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        
        let torpedoNode = SKSpriteNode(imageNamed: "torpedo")
        
        torpedoNode.setScale(2)
        
        torpedoNode.position = CGPoint(x: player.position.x, y: player.position.y + 50)
        
        torpedoNode.physicsBody = SKPhysicsBody(circleOfRadius: torpedoNode.size.width / 2 )
        torpedoNode.physicsBody?.isDynamic = true
        
        torpedoNode.physicsBody?.categoryBitMask = photonTorpedoCategory
        torpedoNode.physicsBody?.contactTestBitMask = alienCategory
        torpedoNode.physicsBody?.collisionBitMask = 0
        
        torpedoNode.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(torpedoNode)
        
        
        let animationDuration : TimeInterval = 1
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x, y: +(self.frame.height/2)), duration: animationDuration))
        
        actionArray.append(SKAction.removeFromParent())
        
        torpedoNode.run(SKAction.sequence(actionArray))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireTorpedo()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody : SKPhysicsBody
        var secondBody : SKPhysicsBody
        
        //alienCategory = 2  and torpedo = 1
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            firstBody = contact.bodyA      // torpedo
            secondBody = contact.bodyB     // alien
        }
        else{
            firstBody = contact.bodyB       // torpedo
            secondBody = contact.bodyA      // alien
        }
        // 1 & 1 = 1   , 2 & 2 = 1 , 1 & 2 = 0
        if (firstBody.categoryBitMask & photonTorpedoCategory) != 0 && (secondBody.categoryBitMask & alienCategory) != 0{
            torpedoDidCollideWithAlien(torpedoNode: firstBody.node as! SKSpriteNode, alienNode: secondBody.node as! SKSpriteNode)
        }
    }
    
    
    func torpedoDidCollideWithAlien(torpedoNode : SKSpriteNode , alienNode : SKSpriteNode){
        
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        
        explosion.position = alienNode.position
        
        self.addChild(explosion)
        
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        torpedoNode.removeFromParent()
        
        alienNode.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 2)){explosion.removeFromParent()}
        
        score += 5
        
    }
    
    override func didSimulatePhysics() {
        player.position.x += xAcceleration * 50
        if player.position.x < -20 {
            player.position = CGPoint(x: self.size.width + 20, y: player.position.y)
        }
        else if player.position.x > self.size.width * 20 {
            player.position = CGPoint(x: -20,y: player.position.y)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
