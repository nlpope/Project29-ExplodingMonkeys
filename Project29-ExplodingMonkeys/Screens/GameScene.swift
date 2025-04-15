//  File: GameScene.swift
//  Project: Project29-ExplodingMonkeys
//  Created by: Noah Pope on 4/9/25.
//  Original Game: https://www.youtube.com/watch?v=lyBD0X81tjk

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    weak var viewController: GameViewController!
    var buildings       = [BuildingNode]()
    
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    var currentPlayer   = 1
    var banana: SKSpriteNode!
    
    override func didMove(to view: SKView)
    {
        colorNightSky()
        createBuildings()
        setContactDelegate()
        setPlayerNodes()
    }
    
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody   = contact.bodyA
            secondBody  = contact.bodyB
        } else {
            firstBody   = contact.bodyB
            secondBody  = contact.bodyA
        }
    }
    
    
    func setContactDelegate() { physicsWorld.contactDelegate = self }
    
    
    func setPlayerNodes()
    {
        player1                         = createPlayer("player1", onBuilding: buildings[1])
        player2                         = createPlayer("player2", onBuilding: buildings[buildings.count - 2])
    }
    
    //-------------------------------------//
    // MARK: ASSET CREATION
    
    func colorNightSky() { backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1) }
    
    
    func createBuildings()
    {
        let gap: CGFloat        = 2
        var currentX: CGFloat   = -15
        while currentX < 1024 {
            let size        = CGSize(width: Int.random(in: 2...4) * 40, height: Int.random(in: 300...600))
            currentX += size.width + gap
            
            let building        = BuildingNode(color: UIColor.red, size: size)
            building.position   = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            building.setup()
            addChild(building)
            
            buildings.append(building)
        }
    }

    
    func createPlayer(_ name: String, onBuilding playerBuilding: BuildingNode) -> SKSpriteNode
    {
        let player                              = SKSpriteNode(imageNamed: ImageKeys.player)
        player.name                             = name
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.categoryBitMask    = CollisionTypes.player.rawValue
        player.physicsBody?.collisionBitMask   = CollisionTypes.banana.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player.physicsBody?.isDynamic          = false
        
        player.position    = CGPoint(x: playerBuilding.position.x,
                                      y: playerBuilding.position.y + ((playerBuilding.size.height + player.size.height) / 2))
        addChild(player)
        return player
    }
    
    #warning("what are the pipes '|' accomplishing?")
    func createBanana()
    {
        banana                                  = SKSpriteNode(imageNamed: ImageKeys.banana)
        banana.name                             = "banana"
        banana.physicsBody                      = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
        banana.physicsBody?.categoryBitMask     = CollisionTypes.banana.rawValue
        banana.physicsBody?.collisionBitMask    = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.contactTestBitMask  = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(banana)
    }
    
    //-------------------------------------//
    // MARK: ASSET DESTRUCTION
    
    func destroy(player: SKSpriteNode)
    {
        
    }
    
    
    func bananaHit(building: BuildingNode)
    {
        
    }
    
    //-------------------------------------//
    // MARK: LAUNCH ANIMATIONS
    
    func launch(angle: Int, velocity: Int)
    {
        let speed   = Double(velocity) / 10.0
        let radians = deg2rad(degrees: angle)
        if banana != nil { banana.removeFromParent(); banana = nil }
        createBanana()
        if currentPlayer == 1 { runThrowAnimation(for: player1, speed: speed, radians: radians) }
        else { runThrowAnimation(for: player2, speed: speed, radians: radians) }
    }
    
    /**
     if player 2 was throwing the banana, position it up and to the right ,
     ...apply the opposite spin,
     ...then make it move in the correct direction
     */
    
    func runThrowAnimation(for player: SKSpriteNode, speed: Double, radians: Double)
    {
        let playerXPosition                 = player == player1 ? player.position.x - 30 : player.position.x + 30
        let angularVelocity:CGFloat         = player == player1 ? -20 : 20
        let throwImg                        = player == player1 ? ImageKeys.player1Throw : ImageKeys.player2Throw
        
        banana.position                     = CGPoint(x: playerXPosition, y: player.position.y + 40)
        banana.physicsBody?.angularVelocity = angularVelocity
        
        let raiseArm                        = SKAction.setTexture(SKTexture(imageNamed: throwImg))
        let lowerArm                        = SKAction.setTexture(SKTexture(imageNamed: ImageKeys.player))
        let pause                           = SKAction.wait(forDuration: 0.15)
        let sequence                        = SKAction.sequence([raiseArm, pause, lowerArm])
        player.run(sequence)
        
        let impulse                         = CGVector(dx: cos(radians) * speed, dy: sin(radians) * speed)
        banana.physicsBody?.applyImpulse(impulse)
    }
    
    //-------------------------------------//
    // MARK: DEGREES TO RADIANS
    
    func deg2rad(degrees: Int) -> Double { return Double(degrees) * Double.pi / 180 }
}
