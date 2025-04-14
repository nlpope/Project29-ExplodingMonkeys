//  File: GameViewController.swift
//  Project: Project29-ExplodingMonkeys
//  Created by: Noah Pope on 4/9/25.

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController
{
    var currentGame: GameScene!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode             = .fill
                view.presentScene(scene)
                currentGame                 = scene as? GameScene
                currentGame.viewController  = self
            }
            
            view.ignoresSiblingOrder    = true
            
            view.showsFPS               = true
            view.showsNodeCount         = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        if UIDevice.current.userInterfaceIdiom == .phone { return .allButUpsideDown }
        else { return .all }
    }

    override var prefersStatusBarHidden: Bool { return true }
}
