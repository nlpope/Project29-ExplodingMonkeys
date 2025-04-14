//  File: GameScene.swift
//  Project: Project29-ExplodingMonkeys
//  Created by: Noah Pope on 4/9/25.
//  Original Game: https://www.youtube.com/watch?v=lyBD0X81tjk

import SpriteKit
import GameplayKit

class GameScene: SKScene
{
    weak var viewController: GameViewController!
    var buildings       = [BuildingNode]()
    
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    var banana: SKSpriteNode!
    var currentPlayer   = 1
    
    override func didMove(to view: SKView)
    {
        colorNightSky()
        createBuildings()
    }
    
    
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
    
    #warning("working on making this reusable for DRY policy")
    func createPlayer(named: String, at: CGPoint)
    {
        // 1. create a player sprite & name it "player1"
        // 2. create a physics body for the player that collides w bananas & set it to not be dynamic
        // 3. position player at top of second bldg in the array
        // 4. add player to the scene
        
        // 5. repeat all of the above for player 2 except put em on the second to last bldg
        
        player1                                 = SKSpriteNode(imageNamed: ImageKeys.player)
        player1.name                            = "player1"
        player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)
        player1.physicsBody?.categoryBitMask    = CollisionTypes.player.rawValue
        player1.physicsBody?.collisionBitMask   = CollisionTypes.banana.rawValue
        player1.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.isDynamic          = false
        
        let player1Building  = buildings[1]
        player1.position    = CGPoint(x: player1Building.position.x,
                                      y: player1Building.position.y + ((player1Building.size.height + player1.size.height) / 2))
        addChild(player1)
    }
    
    
    func launch(angle: Int, velocity: Int)
    {
        
    }
}
