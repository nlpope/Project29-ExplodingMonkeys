//  File: GameViewController.swift
//  Project: Project29-ExplodingMonkeys
//  Created by: Noah Pope on 4/9/25.

import UIKit
import SpriteKit
import GameplayKit

enum UIToggleModes { case on, off }

class GameViewController: UIViewController
{
    var currentGame: GameScene!
    @IBOutlet var angleSlider: UISlider!
    @IBOutlet var angleLabel: UILabel!
    @IBOutlet var velocitySlider: UISlider!
    @IBOutlet var velocityLabel: UILabel!
    @IBOutlet var launchButton: UIButton!
    @IBOutlet var playerNumber: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadScene()
        setSlidersToDefault()
    }
    
    
    func loadScene()
    {
        if let view = self.view as! SKView? {
            /** Load the SKScene from 'GameScene.sks' */
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
    
    
    func setSlidersToDefault() { angleChanged(angleSlider!); velocityChanged(velocitySlider!) }
    
    //-------------------------------------//
    // MARK: SLIDER & BUTTON METHODS
    
    @IBAction func angleChanged(_ sender: Any) { angleLabel.text = "Angle: \(Int(angleSlider.value))°" }
    
    
    @IBAction func velocityChanged(_ sender: Any) { velocityLabel.text  = "Velocity: \(Int(velocitySlider.value))" }
    
    
    @IBAction func launch(_ sender: Any)
    {
        toggleUI(.off)
        currentGame.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    }
    
    //-------------------------------------//
    // MARK: UI & PLAYER ACTIVATION METHODS
    
    func toggleUI(_ mode: UIToggleModes)
    {
        if mode == .off {
            angleSlider.isHidden    = true
            angleLabel.isHidden     = true
            
            velocitySlider.isHidden = true
            velocityLabel.isHidden  = true
            
            launchButton.isHidden   = true
        } else {
            angleSlider.isHidden    = false
            angleLabel.isHidden     = false
            
            velocitySlider.isHidden = false
            velocityLabel.isHidden  = false
            
            launchButton.isHidden   = false
        }
    }
    
    
    func activatePlayer(number: Int)
    {
        if number == 1 { playerNumber.text = "<<< PLAYER ONE" }
        else { playerNumber.text = "PLAYER TWO >>>" }
        
        toggleUI(.on)
    }
}
