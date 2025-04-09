//  File: BuildingNode.swift
//  Project: Project29-ExplodingMonkeys
//  Created by: Noah Pope on 4/9/25.

import SpriteKit
import UIKit

class BuildingNode: SKSpriteNode
{
    var currentImage: UIImage!
    
    func setup()
    {
        // set name, texture and physics
        name            = "building"
        currentImage    = drawBuilding(size: size)
        texture         = SKTexture(image: currentImage)
        
        configurePhysics()
    }
    
    
    func drawBuilding(size: CGSize) -> UIImage
    {
        // do the core graphics rendering of a bldg
        // ... and return it as a UIImage
        let renderer    = UIGraphicsImageRenderer(size: size)
        let img         = renderer.image { ctx in
            let rectangle   = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            let color: UIColor
            
            switch Int.random(in: 0...2) {
            case 0:
                color   = UIColor(hue: 0.502, saturation: 0.98, brightness: 0.67, alpha: 1)
            case 1:
                color   = UIColor(hue: 0.999, saturation: 0.99, brightness: 0.67, alpha: 1)
            default:
                color   = UIColor(hue: 0, saturation: 0, brightness: 0.67, alpha: 1)
            }
            color.setFill()
        }
        return UIImage()
    }
    
    
    func configurePhysics()
    {
        // set up per-pixel physics for sprite's current texture
        physicsBody                     = SKPhysicsBody(texture: texture!, size: size)
        physicsBody?.isDynamic          = false
        physicsBody?.categoryBitMask    = CollisionTypes.building.rawValue // 2
        physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue // 1
    }
}
