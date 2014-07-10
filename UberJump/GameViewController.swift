//
//  GameViewController.swift
//  UberJump
//
//  Created by Catherine Jung on 10/07/2014.
//  Copyright (c) 2014 InPlayTime Ltd. All rights reserved.
//

import UIKit
import SpriteKit


class GameViewController: UIViewController {

    var scene: GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = view as SKView
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        
        skView.presentScene(scene)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {return true}
    
    
}
