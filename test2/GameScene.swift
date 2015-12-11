//
//  GameScene.swift
//  test2
//
//  Created by 江尧 on 15/11/27.
//  Copyright (c) 2015年 江尧. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = UIColor.whiteColor()
        self.size = view.bounds.size

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
//        globalConst.currentScene = globalConst.sceneInstance
//        self.view?.presentScene(globalConst.sceneInstance, transition: SKTransition.doorsCloseHorizontalWithDuration(1) )
//        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"dirt")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.zPosition = 200
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
