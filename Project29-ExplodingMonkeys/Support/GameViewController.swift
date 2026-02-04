//  File: GameViewController.swift
//  Project: Project29-ExplodingMonkeys
//  Created by: Noah Pope on 4/9/25.

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController
{
    var currentGame: GameScene!
    @IBOutlet var angleSlider: UISlider!
    @IBOutlet var angleLabel: UILabel!
    @IBOutlet var velocitySlider: UISlider!
    @IBOutlet var velocityLabel: UILabel!
    @IBOutlet var launchButton: UIButton!
    @IBOutlet var playerNumber: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var windLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadScene()
        setSlidersToDefault()
    }
    
    
    func loadScene()
    {
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode             = .fill
                //but maybe try resize fill for things from now on - seems to work well all around 
//                scene.scaleMode = .resizeFill

                currentGame                 = scene as? GameScene
                currentGame.viewController  = self
                /**
                 was presenting scene (which calls its didMove func) before setting the currentGame & its viewController
                 this caused my gameScene's score label didSet settings to crash my app
                 */
                view.presentScene(scene)
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
    
    //-------------------------------------//
    // MARK: SETUP
    
    func setSlidersToDefault() { angleChanged(angleSlider); velocityChanged(velocitySlider) }
    
    //-------------------------------------//
    // MARK: SLIDER & BUTTON METHODS
    /**
     sender was of type Any but had to force unwrap respective sliders when I called it or cast it as 'Any'
     so I just changed the expected sender to be UISlider b/c what else is it gonna be?
     */
    
    @IBAction func angleChanged(_ sender: UISlider) { angleLabel.text = "Angle: \(Int(angleSlider.value))°" }
    
    
    @IBAction func velocityChanged(_ sender: UISlider) { velocityLabel.text  = "Velocity: \(Int(velocitySlider.value))" }
    
    
    @IBAction func launchTapped(_ sender: Any)
    {
        toggleUI(.off)
        currentGame.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    }
    
    //-------------------------------------//
    // MARK: UI, PLAYER ACTIVATION, & SCORE METHODS
    
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
        if number == 1 { playerNumber.text = UIKeys.activatePlayer1 }
        else { playerNumber.text = UIKeys.activatePlayer2 }
        toggleUI(.on)
    }
}
