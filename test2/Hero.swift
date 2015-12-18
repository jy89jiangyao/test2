//
//  HeroSprite.swift
//  test2
//
//  Created by 江尧 on 15/12/3.
//  Copyright © 2015年 江尧. All rights reserved.
//

import SpriteKit

class Hero : Tile {
    var animates = [String : [SKTexture]]()
    
    var hrHp : Int = 0
    var hrMp : Int = 0
    
    override init(data: TileData, coord: CGPoint) {
        super.init(data: data, coord: coord)
        hrHp = 1000
        hrMp = 100
        
        animates["down"] = [SKTexture]()
        animates["left"] = [SKTexture]()
        animates["right"] = [SKTexture]()
        animates["up"] = [SKTexture]()
        let heroPic = SKTexture(imageNamed: "hero")
        
        
        for y in 0...3 {
            var textures = [SKTexture]()
            
            for x in 0...3 {
                let yPos : CGFloat = CGFloat(1.0-(Float(y)+1.0)*(0.25))
                let xPos : CGFloat = CGFloat(Float(x)*(0.25))
                let ySize : CGFloat = CGFloat(0.25)
                let xSize : CGFloat = CGFloat(0.25)
                let rect : CGRect = CGRectMake(xPos, yPos, xSize, ySize)
                let tet = SKTexture(rect: rect, inTexture: heroPic)
                textures.append(tet)
            }
            
            if(y == 0){
                animates["down"] = textures
            }else if (y == 1) {
                animates["left"] = textures
            }else if (y == 2) {
                animates["right"] = textures
            }else {
                animates["up"] = textures
            }
        }
    }
    
    
    
    func animateWithDirection (direction : String,distance : CGFloat) {
        
        //test
        self.removeAllActions()
        animates[direction]?.append(animates[direction]![0])
        let imgAction = SKAction.repeatAction(SKAction.animateWithTextures(animates[direction]!, timePerFrame: 0.05), count: 1)
        var deltaX = CGFloat(0)
        var deltaY = CGFloat(0)
        if direction == "down" {
            deltaY = CGFloat(-1)
            self.coord.y += 1
        }else if direction == "left" {
            deltaX = CGFloat(-1)
            self.coord.x -= 1
        }else if direction == "right" {
            deltaX = CGFloat(1)
            self.coord.x += 1
        }else {
            deltaY = CGFloat(1)
            self.coord.y -= 1
        }
        
        let moveAction = SKAction.moveByX(deltaX * distance, y: deltaY * distance, duration: 0.25)
        let action = SKAction.group([imgAction,moveAction])
        self.sprite.runAction(action)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
