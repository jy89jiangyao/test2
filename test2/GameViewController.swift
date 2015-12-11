//
//  GameViewController.swift
//  test2
//
//  Created by 江尧 on 15/11/27.
//  Copyright (c) 2015年 江尧. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let upSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        upSwipe.direction = .Up
        downSwipe.direction = .Down
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(upSwipe)
        view.addGestureRecognizer(downSwipe)
        
        globalConst.scale = Float(view.bounds.size.width)/Float(352)
        globalConst.sceneInstance = Scene(size: view.bounds.size)
        globalConst.gsceneInstance = GameScene()
        
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        globalConst.sceneInstance?.scaleMode = .AspectFit
        print(globalConst.sceneInstance?.size)
//        print(globalConst.scale)
        skView.presentScene(globalConst.sceneInstance)
        globalConst.currentScene = globalConst.sceneInstance!
    }


    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer){
        if globalConst.currentScene === globalConst.sceneInstance {
            globalConst.sceneInstance?.handleSwipes(sender)
        }
    }
}
