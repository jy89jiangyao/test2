//
//  globalConst.swift
//  test
//
//  Created by 江尧 on 15/11/27.
//  Copyright © 2015年 江尧. All rights reserved.
//

import SpriteKit

class globalConst {
    static var scale : Float = 1
    static let tileSize = CGFloat(32)
    static var shiftLength = CGFloat(100)
    static let heroLayerName = "hero"
    static var sceneInstance : Scene? = nil
    static var gsceneInstance : GameScene? = nil
    static var currentScene : SKScene? = nil
    
    static var defaultData = NSUserDefaults.standardUserDefaults()
    
    static var stage1 = Stages(data: ["floor8", "floor1","floor6"])
    static var stage2 = Stages(data: ["floor13", "floor2"])
}

class MapSize {
    var width : Int
    var height : Int
    
    init(x : Int, y : Int){
        self.width = x
        self.height = y
    }
}

class Stages {
//    static var stage1 = ["floor8", "floor1","floor6"]
//    static var stage2 = ["floor13", "floor2"]
    var arr = []
    init (data : [String]) {
        arr = data
    }
    
    func findIndex(str : String) -> Int {
        for x in 0...arr.count - 1 {
            if arr[x] as! String == str {
                return x
            }
        }
        return -1
    }
    
    func findNext (upOrDown : Bool, str : String) -> String? {
        let now = findIndex(str)
        if upOrDown {
            if now + 1 < arr.count {
                return arr[now + 1] as? String
            }else {
                return nil
            }
        }else {
            if now - 1 >= 0 {
                return arr[now - 1] as? String
            }else {
                return nil
            }
        }
        
    }
}

extension SKLabelNode {
    func fillTheLabel(text : String, size : CGFloat, fontName : String,pos : CGPoint) {
        self.text = text
        self.fontSize = size
        self.fontName = fontName
        self.position = pos
    }
}