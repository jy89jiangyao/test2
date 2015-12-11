//
//  TileSet.swift
//  test2
//
//  Created by 江尧 on 15/12/1.
//  Copyright © 2015年 江尧. All rights reserved.
//

import SpriteKit

class TileSet {
    //mark : properties
    let name : String
    let tileSize : CGFloat
    let firstTileId : Int
    var endTileId : Int
    var tileData = [String : TileData]()
    
    //mark : inistialization
    init(name : String, tileSize : CGFloat, firstTid : Int, endTid : Int){
        self.name  = name
        self.tileSize = tileSize
        self.firstTileId = firstTid
        self.endTileId = endTid
    }
    
    func addData(name : String){
        let data = TileData(name: name, texture: name,index: 0)
        tileData[name] = data
    }
    
    func addMutiData(name : String, imgName : String){
        let texture = SKTexture(imageNamed: imgName)
        let row = Float(texture.size().height/tileSize)
        let col = Float(texture.size().width/tileSize)
        
        var count = 0
        for y in 0...Int(row-1) {
            for x in 0...Int(col-1) {
                let yPos : CGFloat = CGFloat(1.0-(Float(y)+1.0)*(1.0/row))
                let xPos : CGFloat = CGFloat(Float(x)*(1.0/col))
                let ySize : CGFloat = CGFloat(1.0/row)
                let xSize : CGFloat = CGFloat(1.0/col)
                let data = getTileByRectInfo(count, xPos: xPos, yPos: yPos, xSize: xSize,ySize: ySize, texture: texture)
                let name : String = String(count + firstTileId)
                tileData[name] = data
                count++
            }
        }
        endTileId = firstTileId + count - 1
    }
    
    func getTileByRectInfo (count : Int, xPos : CGFloat,yPos : CGFloat, xSize : CGFloat,ySize : CGFloat, texture : SKTexture) -> TileData {
        let rect = CGRectMake(xPos, yPos, xSize, ySize)
        let tet = SKTexture(rect: rect, inTexture: texture)
        let name = count + firstTileId
        let data = TileData(name: String(name), texture: tet, index: count)
        return data
    }
    
}