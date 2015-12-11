//
//  tiledMap.swift
//  test2
//
//  Created by 江尧 on 15/11/29.
//  Copyright © 2015年 江尧. All rights reserved.
//

import SpriteKit

class TileMap : SKNode {
    //mark : properties
    private var mapSize : MapSize
    private var maxMapSize : Int
    private var tileSets = [String : TileSet]()
    private var tiles = [String : [[Tile?]]]()
    private var tileLayers = [String : SKNode]()
    private var tileSize : CGFloat
    private var hero : Hero?
    private var first : Int = 1  //上楼否  对应herolayer中 first属性 同为true第一个 不同第二个
    
    var sceneDelegate : SceneDelegate?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func tilePositionForCoord(coord : CGPoint) -> CGPoint{
        let x = tileSize * coord.x
        let y = tileSize * CGFloat(mapSize.height - (1 + Int(coord.y)))
        
        return CGPoint(x: x, y: y)
    }
    
    
    init(filePath : String){
        self.maxMapSize = 32
        self.mapSize = MapSize(x: 0, y: 0)
        self.tileSize = CGFloat(0)
        
        super.init()
        self.name = name
        createMapByTMX(filePath)
    }


    func createMapByTMX(filePath : String){
        guard let file = NSBundle.mainBundle().pathForResource(filePath, ofType: "tmx") else{
           fatalError("Error: file not find")
        }
        let parser = SKATMXParser(filePath:file)
        let mapDic = parser.mapDictionary
//        print(mapDic)
        //tilesets等参数设置
        setValueByMapDic(mapDic)

    }

    func setValueByMapDic(mapDic : [String : AnyObject]){
        //getting additional user generated properties for map
        guard let _ = mapDic["properties"] as? [String : AnyObject] else {
            fatalError("Error: Map is missing properties values")
        }
        //            mapProperties = mapDic["properties"] as! [String : AnyObject]

        //getting value that determines how many tiles wide the map is
        guard let width = mapDic["width"] as? Int else {
            fatalError("Error: Map is missing width value")
        }
        //getting value that determines how many tiles tall a map is
        guard let height = mapDic["height"] as? Int else {
            fatalError("Error: Map is missing height value")
        }
        mapSize = MapSize(x: width, y: height)
//        tiles = Array(count: mapSize.width, repeatedValue: Array(count: mapSize.height, repeatedValue: nil))

        //getting value that determines the width of a tile
        guard let tileWidth = mapDic["tilewidth"] as? CGFloat else {
            fatalError("Error: Map is missing width value")
        }
        tileSize = tileWidth


        guard let tileSets = mapDic["tilesets"] as? [AnyObject] else{
            fatalError("Map is missing tile sets to generate map")
        }
        setTileSetsByDic(tileSets)
        
        guard let layers = mapDic["layers"] as? [AnyObject] else{
            fatalError("Map is missing tile sets to generate map")
        }
        setLayersByDic(layers)
    }

    func setTileSetsByDic(tileSets : [AnyObject]){
        for (_, element) in tileSets.enumerate() {
            guard let tileSet = element as? [String : AnyObject] else{
                fatalError("Error: tile sets are not properly formatted")
            }
            let ts = getSingleTileSetByElement(tileSet)
            self.tileSets[ts.name] = ts
        }
    }

    func getSingleTileSetByElement(tileSet : [String : AnyObject]) -> TileSet{
        guard let tileSetName = tileSet["name"] as? String else{
            fatalError("Error: tile width for tile set isn't set propertly")
        }

        guard let tileSize = tileSet["tileheight"] as? CGFloat else{
            fatalError("Error: tile width for tile set isn't set propertly")
        }
        
        guard let firstTileId = tileSet["firstgid"] as? Int else{
            fatalError("Error: tile width for tile set isn't set propertly")
        }
        
        guard let img = tileSet["image"] as? String else{
            fatalError("Error: tile width for tile set isn't set propertly")
        }
        let set = TileSet(name: tileSetName, tileSize: tileSize, firstTid: firstTileId,endTid: 0)
        set.addMutiData(tileSetName, imgName: img)
        return set
    }
    
    func setLayersByDic(layers : [AnyObject]){
        var zPos = 0
        for (_, element) in layers.enumerate() {
            guard let layer = element as? [String : AnyObject] else{
                fatalError("Error: layers are not properly formatted")
            }
            setSingleLayerByElement(layer, zPos: zPos)
            zPos++
        }
    }
    
    func setSingleLayerByElement(layer : [String : AnyObject],zPos : Int){
        guard let layerName = layer["name"] as? String else{
            fatalError("Error: layerName isn't set propertly")
        }
        guard let layerData = layer["data"] as? [Int] else{
            fatalError("Error: layerData isn't set propertly")
        }
        
        tiles[layerName] = Array(count: mapSize.width, repeatedValue: Array(count: mapSize.height, repeatedValue: nil))
        if layerName == "heroPoint" {
            guard let first = layer["first"] as? String else{
                fatalError("Error: heroLayerData isn't set propertly")
            }
            self.first = Int(first)!
        }
        createMapByLayerData(layerName, layerData: layerData, zPos : zPos)
        
    }
    
    //填充所有map
    func createMapByLayerData(layerName : String, layerData : [Int],zPos  : Int){
        
        let tileLayer = SKNode()
        tileLayer.position = CGPoint(x: tileSize/2, y: tileSize/2)
        tileLayer.zPosition = CGFloat(zPos)
        
        var count = 0
        for y in 0...(mapSize.height - 1){
            for x in 0...Int(mapSize.width - 1){
                
                guard let data = getTileDataByLayerData(layerData[count]) else {
                    count++
                    continue
                }
//                print("\(data.texture),\(layerData[count])")
                let coord =  CGPoint(x: x, y: y)
                let tile = Tile(data: data, coord: coord)
                tile.position = tilePositionForCoord(coord)
                tile.name = "tile_\(x)_\(y)"
                if layerName != "heroPoint" {
                    tileLayer.addChild(tile)
                }
                tiles[layerName]![x][y] = tile
                count++
            }
        }
        if layerName != "heroPoint" {
            addChild(tileLayer)
        }
        tileLayers[layerName] = tileLayer
    }
    
    func getTileDataByLayerData(tileId : Int) -> TileData?{
        if tileId == 0 {
            return nil
        }
        for tileSet : TileSet in tileSets.values {
            if tileId >= tileSet.firstTileId && tileId <= tileSet.endTileId {
                return tileSet.tileData[String(tileId)]!
            }
        }
        return nil
    }
    
    func retTileOfPos(pos : CGPoint) -> Tile? {
        
        let x : Int = Int(pos.x/CGFloat(globalConst.scale)/tileSize)
        let y : Int = mapSize.height - 1 - Int(pos.y/CGFloat(globalConst.scale)/tileSize)
        if x > self.mapSize.width - 1 || y < 0 {
            return nil
        }else{
            //            tileLayer.removeChildrenInArray([tiles[x][y]!])
            return self.tiles["road"]![x][y]
        }
    }
    
    func isUp (b : Bool) {
        //设置 hero 位置
        removeChildrenInArray([tileLayers["heroPoint"]!])
        tileLayers["heroPoint"]?.removeAllChildren()
        let heroTiles = getTwoHeroPos()
        if (b && first == 1) || (!b && first != 1) {
            self.hero = Hero(data: heroTiles[0].data, coord: heroTiles[0].coord)
            self.hero?.position = tilePositionForCoord(heroTiles[0].coord)
            tileLayers["heroPoint"]?.addChild(self.hero!)
        }else{
            self.hero = Hero(data: heroTiles[1].data, coord: heroTiles[1].coord)
            self.hero?.position = tilePositionForCoord(heroTiles[1].coord)
            tileLayers["heroPoint"]?.addChild(self.hero!)
        }
        addChild(tileLayers["heroPoint"]!)
    }
    
    func getTwoHeroPos () -> [Tile] {
        var heroTiles = [Tile]()
        for y in 0...(mapSize.height - 1){
            for x in 0...Int(mapSize.width - 1){
                
                guard let tile = tiles["heroPoint"]![x][y] else {
                    continue
                }
                heroTiles.append(tile)
            }
        }
        
        return heroTiles
    }
    
    func animateHero (direction : String) {
        var coord = self.hero?.coord

        if direction == "down" {
            coord!.y += 1
        }else if direction == "left" {
            coord!.x -= 1
        }else if direction == "right" {
            coord!.x += 1
        }else {
            coord!.y -= 1
        }
        if Int(coord!.x) >= mapSize.width || Int(coord!.x) < 0 || Int(coord!.y) >= mapSize.height || Int(coord!.y) < 0 {
            print("can't go")
            return
        }
        
        guard let road = tiles["road"]![Int(coord!.x)][Int(coord!.y)] else {
            print("can't go")
            return
        }
        print("can go roadCoord : \(road.coord)")
        
        if let enemy = tiles["enemy"]![Int(coord!.x)][Int(coord!.y)] {
            print("enemy : \(enemy.data.index)")
            tiles["enemy"]![Int(coord!.x)][Int(coord!.y)] = nil
            tileLayers["enemy"]?.removeChildrenInArray([enemy])
        }
        
        print(self.hero?.coord)
        self.hero?.animateWithDirection(direction, distance: CGFloat(self.tileSize))
        print(self.hero?.coord)
        
        if let upfloor = tiles["upfloor"]![Int(coord!.x)][Int(coord!.y)] {
            print("upfloor : \(upfloor.data.index)")
            self.sceneDelegate?.changeFloor(true)
            
        }else if let downfloor = tiles["downfloor"]![Int(coord!.x)][Int(coord!.y)]{
            print("downfloor : \(downfloor.data.index)")
            self.sceneDelegate?.changeFloor(false)
        }
    }
}






