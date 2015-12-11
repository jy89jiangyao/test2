//
//  Tile.swift
//  test2
//
//  Created by 江尧 on 15/12/1.
//  Copyright © 2015年 江尧. All rights reserved.
//

import SpriteKit

//Tile
class Tile : SKNode {
    //mark : properties
    let sprite : SKSpriteNode
    let data : TileData
    var coord : CGPoint
    
    //mark : inistialization
    init(data : TileData, coord : CGPoint){
        self.coord = coord
        self.data = data
        self.sprite =  SKSpriteNode(texture: data.texture)
        super.init()
        addChild(sprite)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class TileData {
    //mark : properties
    let name : String
    let texture : SKTexture
    let index : Int
    //    let tileSet : TileSet
    
    //mark : inistialization
    init(name : String, texture : String, index : Int){
        self.name = name
        self.texture = SKTexture(imageNamed: texture)
        self.index = index
        //        self.tileSet = tileSet
    }
    
    init(name : String, texture : SKTexture, index : Int) {
        self.name = name
        self.texture = texture
        self.index = index
    }
}