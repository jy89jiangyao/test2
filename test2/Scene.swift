//
//  File.swift
//  test2
//
//  Created by 江尧 on 15/11/29.
//  Copyright © 2015年 江尧. All rights reserved.
//

import SpriteKit

class Scene : SKScene , SceneDelegate {
    
//    var tilemap2 : TileMap? = nil
    var tileSets = [String : TileSet]()
    
    var tileMaps = [String : TileMap]()
    
    var currentMap : TileMap? = nil
    
    var currentMapName : String = globalConst.defaultData.valueForKey("currentMap") as! String
    
    override init() {
        super.init()
    }
    
    override init(size: CGSize) {
        super.init(size: size)
//        if let tilemap = globalConst.defaultData.valueForKey("currentmap") {
//           tilemap2 = tilemap as? TileMap
//        }else {
        
        
        loadTileMaps(&tileMaps)
        
//        if currentMapName != nil {
//            currentMap = tileMaps[currentMapName as! String]!
//        }else {
        
            currentMapName = globalConst.stage1.arr[1] as! String
            globalConst.defaultData.setObject(currentMapName, forKey: "currentMap")
            globalConst.defaultData.synchronize()
            currentMap = tileMaps[currentMapName]
            
//        }
        addChild(currentMap!)
//            globalConst.defaultData.setObject(tilemap2, forKey: "currentmap")
        
//        }

    }
    
    func loadTileMaps(inout tileMaps : [String : TileMap]) {
        for stage in globalConst.stage1.arr as! [String] {
            tileMaps[stage] = TileMap(filePath: stage)
        }
        let values = Array(tileMaps.values)
        
        for value in values {
            print(value.name)
            value.isUp(true)
            value.sceneDelegate = self
            value.position = CGPoint(x: 0.0, y: globalConst.shiftLength)
            value.setScale(CGFloat(globalConst.scale))
        }
    }
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.grayColor()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer){
        if (sender.direction == .Left) {
            print("Swipe left")
            currentMap?.animateHero("left")
        }
        
        if (sender.direction == .Right) {
            print("Swipe right")
            currentMap?.animateHero("right")
        }
        
        if (sender.direction == .Up) {
            print("Swipe up")
            currentMap?.animateHero("up")
        }
        
        if (sender.direction == .Down) {
            print("Swipe down")
            currentMap?.animateHero("down")
        }
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
//            globalConst.currentScene = globalConst.gsceneInstance
//            self.view?.presentScene(globalConst.gsceneInstance, transition: SKTransition.doorsCloseHorizontalWithDuration(1) )
//            
            var location = touch.locationInNode(self)
            print("x : \(location.x)  y : \(location.y)")
            location.y = location.y - globalConst.shiftLength
            guard let tile = currentMap?.retTileOfPos(location) else {
                print("out of range")
//                tilemap2?.isUp(true)
                return
            }
            print(tile.name)
            

        }
    }
    
    //SceneDelegate Function
    func changeFloor(upOrDown: Bool) {
        guard let mapName = globalConst.stage1.findNext(upOrDown, str: currentMapName) as String? else {
            print("this is the last floor in the stage")
            return
        }
        
        currentMapName = mapName
        self.removeChildrenInArray([currentMap!])
        globalConst.defaultData.setObject(currentMapName, forKey: "currentMap")
        globalConst.defaultData.synchronize()
        currentMap = tileMaps[currentMapName]
        currentMap?.isUp(upOrDown)
        self.addChild(currentMap!)
        print("floor changed")
        
    }
}