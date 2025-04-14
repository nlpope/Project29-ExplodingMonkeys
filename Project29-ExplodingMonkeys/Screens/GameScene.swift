//  File: GameScene.swift
//  Project: Project29-ExplodingMonkeys
//  Created by: Noah Pope on 4/9/25.
//  Original Game: https://www.youtube.com/watch?v=lyBD0X81tjk

import SpriteKit
import GameplayKit

class GameScene: SKScene
{
    weak var viewController: GameViewController!
    var buildings   = [BuildingNode]()
    
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
    
    
    func launch(angle: Int, velocity: Int)
    {
        
    }
}
