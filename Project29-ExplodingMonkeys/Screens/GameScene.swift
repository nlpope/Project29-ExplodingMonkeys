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
    var currentLevel    = 1
    var banana: SKSpriteNode!
    var windValue: CGFloat!
    var player1Score: Int! {
        didSet { self.viewController.scoreLabel.text = "\(player1Score ?? 0)  > Score <  \(player2Score ?? 0)" }
    }
    var player2Score: Int! {
        didSet { self.viewController.scoreLabel.text = "\(player1Score ?? 0)  > Score <  \(player2Score ?? 0)" }
    }
    
    /** called when scene is presented  */
    override func didMove(to view: SKView)
    {
        colorNightSky()
        createBuildings()
        setContactDelegate()
        setPlayerNodes()
        setWind()
        if currentLevel == 1 { setScoresToDefault() }
    }
    
    //-------------------------------------//
    // MARK: SETUP
    
    func setContactDelegate() { physicsWorld.contactDelegate = self }
    
    
    func setPlayerNodes()
    {
        player1 = createPlayer(NameKeys.player1, onBuilding: buildings[1])
        player2 = createPlayer(NameKeys.player2, onBuilding: buildings[buildings.count - 2])
    }
    
    
    func setWind()
    {
        let randomFloat         = CGFloat.random(in: -15...15)
        physicsWorld.gravity    = CGVectorMake(randomFloat, -9.8)
        windValue               = randomFloat.rounded()
        if randomFloat == 0 { viewController.windLabel.text = "WIND: 0mph" }
        else {
            viewController
                .windLabel
                .text = randomFloat < 0 ? "<<< WIND: \(windValue!)mph" : "WIND: \(windValue!)mph >>>"
        }
        
    }
    
    
    func setScoresToDefault() { player1Score = 0; player2Score = 0 }
    
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
        let adjustedHeight                      = ((playerBuilding.size.height + player.size.height) / 2)
        
        player.name                             = name
        player.physicsBody                      = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.categoryBitMask     = CollisionTypes.player.rawValue
        player.physicsBody?.collisionBitMask    = CollisionTypes.banana.rawValue
        player.physicsBody?.contactTestBitMask  = CollisionTypes.banana.rawValue
        player.physicsBody?.isDynamic           = false
        
        player.position                         = CGPoint(x: playerBuilding.position.x,
                                                          y: playerBuilding.position.y + adjustedHeight)
        addChild(player)
        return player
    }
    

    func createBanana()
    {
        banana                                  = SKSpriteNode(imageNamed: ImageKeys.banana)
        banana.name                             = NameKeys.banana
        banana.physicsBody                      = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
        banana.physicsBody?.categoryBitMask     = CollisionTypes.banana.rawValue
        
        /**
         the vertical pipe is a bitwise OR operator
         it combines the bits that make up the building and the player ( in this case the bits that make up 2 and 4)
         ...then combines those bits into one new bit mask representative of the meshed together 2 and 4
         ...combining just means comparing between the two to see if 1 is present in either then setting tha point to 1 in the result if so
         ...so whenever it hits either, the new frankenstein's bit mask will sense it matches one of them and collide/handle the collision
         
         00000010 = 2
         00000100 = 4
         00000110 = 2 | 4
         */
        
        banana.physicsBody?.collisionBitMask    = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.contactTestBitMask  = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(banana)
    }
    
    //-------------------------------------//
    // MARK: ASSET CONTACT & DESTRUCTION
    
    func destroy(player: SKSpriteNode)
    {
        if let explosion    = SKEmitterNode(fileNamed: EmitterKeys.hitPlayer) {
            explosion.position  = player.position
            addChild(explosion)
        }
        
        player.removeFromParent()
        destroyBanana()
        addOnePoint(toPlayer: player == player1 ? 2 : 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.player1Score == 3 || self.player2Score == 3 { self.endGame() }
            else { self.startNewGame() }
        }
    }
    
    
    func destroyBanana()
    {
        banana.name             = ""
        banana.removeFromParent()
        banana                  = nil
    }

    
    /** the banana hit the bldg w respect to its parent's (GameScene's) coordinate sys. */
    func bananaHit(building: SKNode, atPoint contactPoint: CGPoint)
    {
        guard let building      = building as? BuildingNode else { return }
        let buildingLocation    = convert(contactPoint, to: building)
        
        /**
         this bldg needs to know exactly where in its own coordinate system it was hit
         ...in order to make the crumble edit at that point (it has its own origin at the bldg's (node's) center)
         ...so the Gamescene detects the contactPoint w respect to its own coord. sys. then this conversion
         ...allows the bldg to "damage" itself by converting the GameScene's hit zone to the bldg's hit zone
         */
        
        building.hit(at: buildingLocation)
        if let explosion        = SKEmitterNode(fileNamed: EmitterKeys.hitBuilding) {
            explosion.position = contactPoint
            addChild(explosion)
        }
        
        destroyBanana()
        changePlayer()
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
        
        guard let firstNode     = firstBody.node else { return }
        guard let secondNode    = secondBody.node else { return }
        
        if firstNode.name == NameKeys.banana && secondNode.name == NameKeys.building {
            bananaHit(building: secondNode, atPoint: contact.contactPoint)
        }
        
        if firstNode.name == NameKeys.banana && secondNode.name == NameKeys.player1 {
            destroy(player: player1)
        }
        
        if firstNode.name == NameKeys.banana && secondNode.name == NameKeys.player2 {
            destroy(player: player2)
        }
    }
    
    //-------------------------------------//
    // MARK: SCORE TRACKING
    
    func addOnePoint(toPlayer player: Int )
    {
        if player == 1 { player1Score += 1 }
        else { player2Score += 1 }
    }
    
    //-------------------------------------//
    // MARK: CONTROL TRANSFER
    
    func changePlayer()
    {
        if currentPlayer == 1 { currentPlayer = 2 }
        else { currentPlayer = 1 }
        viewController.activatePlayer(number: currentPlayer)
    }
    
    //-------------------------------------//
    // MARK: LAUNCH ANIMATIONS
    
    func launch(angle: Int, velocity: Int)
    {
        let speed   = Double(velocity) / 10.0
        let radians = Algorithms.ConversionHelper.deg2rad(degrees: angle)
        if banana != nil { destroyBanana() }
        createBanana()
        if currentPlayer == 1 { runThrowAnimation(for: player1, speed: speed, radians: radians) }
        else { runThrowAnimation(for: player2, speed: speed, radians: radians) }
    }
    
    
    func runThrowAnimation(for player: SKSpriteNode, speed: Double, radians: Double)
    {
        let playerXPosition                 = player == player1 ? player.position.x - 30 : player.position.x + 30
        let angularVelocity: CGFloat        = player == player1 ? -20 : 20
        let playerDxSpeed                   = player == player1 ? speed : -speed
        let throwImg                        = player == player1 ? ImageKeys.player1Throw : ImageKeys.player2Throw
        
        banana.position                     = CGPoint(x: playerXPosition, y: player.position.y + 40)
        banana.physicsBody?.angularVelocity = angularVelocity
        
        let raiseArm                        = SKAction.setTexture(SKTexture(imageNamed: throwImg))
        let lowerArm                        = SKAction.setTexture(SKTexture(imageNamed: ImageKeys.player))
        let pause                           = SKAction.wait(forDuration: 0.15)
        let sequence                        = SKAction.sequence([raiseArm, pause, lowerArm])
        player.run(sequence)
        
        let impulse                         = CGVector(dx: cos(radians) * playerDxSpeed, dy: sin(radians) * speed)
        banana.physicsBody?.applyImpulse(impulse)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        guard banana != nil else { return }
        if abs(banana.position.y) > 1000 { destroyBanana(); changePlayer() }
    }
    
    //-------------------------------------//
    // MARK: GAME START & END
    
    func wipeAssetsForEndGame()
    {
        viewController.toggleUI(.off)

        for building in buildings {
            building.name             = ""
            building.removeFromParent()
        }
        
        player1.name = ""
        player1.removeFromParent()
        player2.name = ""
        player2.removeFromParent()
        viewController.playerNumber.isHidden    = true
        viewController.scoreLabel.isHidden      = true
    }
    
    
    func startNewGame()
    {
        let newGame                     = GameScene(size: self.size)
        newGame.viewController          = self.viewController
        self.viewController.currentGame = newGame
        
        newGame.player1Score            = self.player1Score
        newGame.player2Score            = self.player2Score
        newGame.currentLevel += 1
        self.changePlayer()
        newGame.currentPlayer           = self.currentPlayer
        
        self.setWind()
        
        let transition                  = SKTransition.doorway(withDuration: 1.5)
        self.view?.presentScene(newGame, transition: transition)
    }
    
    
    func endGame()
    {
        wipeAssetsForEndGame()
        
        let gameOver                = SKSpriteNode(imageNamed: ImageKeys.gameOver)
        gameOver.position           = CGPoint(x: 512, y: 450)
        gameOver.zPosition          = 1
        addChild(gameOver)
        
        let finalScore              = SKLabelNode(fontNamed: FontKeys.chalkDuster)
        finalScore.text             = "Final Scores \n Player 1: \(player1Score!) \n Player 2: \(player2Score!)"
        finalScore.position         = CGPoint(x: 512, y: 250)
        finalScore.zPosition        = 1
        finalScore.fontSize         = 35
        finalScore.numberOfLines    = 0
        addChild(finalScore)
        
        return
    }
}
