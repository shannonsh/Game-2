//
//  GameScene.swift
//  Game-2
//
//  Created by Elena Ariza on 3/11/16.
//  Copyright (c) 2016 Elena Ariza and Shannon Shih. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var world: World!
    var gridCoord = [[CGPointMake(0,0)]]
    
    let margin: CGFloat = 20    // distance between left and right edges of grid and screen edges
    let upperSpace: CGFloat = 50
    let spaceBetwCells: CGFloat = 1.4
    var cellSize: CGFloat = 0
    
    var screenMidX: CGFloat!
    var screenMidY: CGFloat!
    
    let cellLayer = SKNode()
    var previousScale = CGFloat(1.0)
    var sceneCam: SKCameraNode!
    
    // status screen at bottom, shows unit stats when unit selected or training queue when city is selected
    var statusBar = SKSpriteNode() // <- when graphics finished make this SKSpriteNode
    var statusBarHeight = CGFloat(100)
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize)
    {
        super.init(size: size)
        
        screenMidX = CGRectGetMidX(frame)
        screenMidY = CGRectGetMidY(frame)
        
        anchorPoint = CGPoint(x: 0, y: 1.0)
        statusBar = SKSpriteNode(color: SKColor.lightGrayColor(), size: CGSize(width: UIScreen.mainScreen().bounds.size.width, height: statusBarHeight))
//        statusBar = SKShapeNode(path: CGPathCreateWithRect(
//            CGRectMake(screenMidX, 0, UIScreen.mainScreen().bounds.size.width, 140), nil), centered: true)
        
    }
    
        
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        let numRows = 30
        let numCols = 20
        
        sceneCam = SKCameraNode()
        sceneCam.setScale(1)
        sceneCam.position = CGPoint(x: frame.midX, y: frame.midY)
        camera = sceneCam
        
        addChild(sceneCam)

        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 0, y: 0)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        sceneCam.addChild(background)
        
        addSpritesForCells(numRows, numCols: numCols)
        addChild(cellLayer)
        
        drawStatusBar(Warrior(owner: 1, row: 1, column: 1))

        sceneCam.addChild(statusBar)
        
        addConstraints()
    }
    
        
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {

//            let location = touch.locationInNode(self)
            
            
            let pinch:UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(GameScene.pinched(_:)))
            view!.addGestureRecognizer(pinch)
            
            // figures out whether cell is touched
            let location = touch.locationInNode(self)
            let gridX = (location.x - margin) / (cellSize + spaceBetwCells)
            let gridY = (abs(location.y) - upperSpace) / (cellSize + spaceBetwCells)
            
            //attempt to make cells turn dark grey when tapped by user (to let user know which cell they're selecting)
//            let tappedCell = world.gridTouched(gridX, gridY: gridY)
//            world.board[tappedCell.0][tappedCell.1].updateState(SELECTED)
            
            
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {

        let touch = touches.first! as UITouch
        let positionInScene = touch.locationInNode(self)
        let previousPosition = touch.previousLocationInNode(self)
        let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)

        if camera?.xScale <= 1 {
            
            camera!.position = CGPoint(x: camera!.position.x - translation.x, y: camera!.position.y - translation.y)
        }
        print(camera!.position)
    }
    
    func pinched(sender: UIPinchGestureRecognizer) {
        
        if sender.numberOfTouches() == 2 {
            if sender.state == .Changed {
            
                zoom(sender)
            }
        }
    }
    
       
    override func update(currentTime: CFTimeInterval)
    {
        
    }
}
