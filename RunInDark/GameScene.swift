//
//  GameScene.swift
//  RunInDark
//
//  Created by NJUcong on 2017/6/4.
//  Copyright © 2017年 NJU. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate{
    
    // MARK: - Instance Variables
    
    let playerSpeed: CGFloat = 160.0
    
    var goal: SKSpriteNode?
    var player: SKSpriteNode?
    var light:SKLightNode?
    
    var zombies: [ZombieSprite] = []
    private let zombiePosition: [CGPoint] = [
        CGPoint(x:900,y:1800),
        CGPoint(x:900,y:900),
        CGPoint(x:950,y:200),
        CGPoint(x:150,y:150)
    ]
    
    var lastTouch: CGPoint? = nil
    
    private let hud = GameSceneHudNode()
    private let screenSize = UIScreen.main.bounds
    
    private var timer:Timer?
    let lightEnd:CGFloat = 2.0

    override func sceneDidLoad() {
        camera?.scene?.anchorPoint = CGPoint(x:0.5,y:0.5)
        hud.setup(size: screenSize.size)
        addChild(hud)
        SoundManager.sharedInstance.StartPlaying(sceneName: "game")
        
        hud.returnBtnAction = {
            let transition = SKTransition.reveal(with: .left, duration: 0.5)
            let newSize = CGSize(width:self.screenSize.width,height:self.screenSize.height)
            let levelScene = LevelScene(size:newSize)
            levelScene.scaleMode = .aspectFit
            self.view?.presentScene(levelScene, transition: transition)
            SoundManager.sharedInstance.StartPlaying(sceneName: "menu")
            self.hud.returnBtnAction = nil
        }
        
        hud.pauseBtnAction = {
            self.isPaused = true
            self.hud.createContinueBtn()
        }
        
        hud.continueBtnAction = {
            self.isPaused = false
            self.hud.dissmissContinueBtn()
        }
        
        hud.torchBtnAction = {
            self.lightenScene()
            self.hud.changeTorchState()
        }
        
    }
    
    override func didMove(to view: SKView) {
        // Setup physics world's contact delegate
        physicsWorld.contactDelegate = self 
        
        // Setup player
        player = self.childNode(withName: "player") as? SKSpriteNode
        /*
         for child in self.children {
            if child.name == "zombie" {
                if let child = child as? ZombieSprite {
                    // Add zombie
                    zombies.append(child)
                    print("add a zombie")
                }
            }
        }
         */
        // Setup zombies
        for zombiePosition in zombiePosition {
            let zombie = ZombieSprite.newInstance(point: zombiePosition)
            zombies.append(zombie)
            self.addChild(zombie)
            print("add a zombie")
        }
        
        // Setup goal
        goal = self.childNode(withName: "goal") as? SKSpriteNode
        
        // Setup initial camera position
        updateCamera()
        
    }
    
    //MARK: Touch Event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: UIScreen.main.focusedView)

        if let point = touchPoint {
            hud.touchBeganAtPoint(point: point)
            if !hud.pauseBtnPressed && !hud.returnBtnPressed {
                 touchEvents(touches)
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: UIScreen.main.focusedView)
        
        if let point = touchPoint {
            hud.touchMovedToPoint(point: point)
            if !hud.pauseBtnPressed && !hud.returnBtnPressed && !hud.continueBtnPressed {
                touchEvents(touches)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in:  UIScreen.main.focusedView)
        
        if let point = touchPoint {
            hud.touchEndedAtPoint(point: point)
            if !hud.pauseBtnPressed && !hud.returnBtnPressed {
                touchEvents(touches)
            }
        }
    }
    
    fileprivate func touchEvents(_ touches: Set<UITouch>){
        for touch in touches{
            let location = touch.location(in:self)
            lastTouch = location
        }
    }
    
    //MARK - update
    override func didSimulatePhysics(){
        if let _ = player{
            updatePlayer()
            updateZombies()
        }
    }
        
    //Update the camera
    func updateCamera(){
        if let camera = camera {
            camera.position = CGPoint(x: player!.position.x, y: player!.position.y)
        }
        hud.position = CGPoint(x: player!.position.x, y: player!.position.y)
        
    }

    // MARK: - SKPhysicsContactDelegate
    
    func didBegin(_ contact: SKPhysicsContact) {
        // 1. Create local variables for two physics bodies
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        // 2. Assign the two physics bodies so that the one with the lower category is always stored in firstBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 3. react to the contact between the two nodes
        if firstBody.categoryBitMask == player?.physicsBody?.categoryBitMask && secondBody.categoryBitMask == zombies[0].physicsBody?.categoryBitMask {
            // Player & Zombie
            gameOver(false)
        } else if firstBody.categoryBitMask == player?.physicsBody?.categoryBitMask &&
            secondBody.categoryBitMask == goal?.physicsBody?.categoryBitMask {
            // Player & Goal
            gameOver(true)
        }
    }
    
    
    // MARK: Helper Functions
    
    fileprivate func gameOver(_ didWin: Bool) {
        print("- - - Game Ended - - -")
        let gameOverScene = GameOverScene(size: self.size)
        gameOverScene.soundToPlay = didWin ? "fear_win.mp3" : "fear_lose.mp3"
        let transition = SKTransition.flipVertical(withDuration: 1.0)
        gameOverScene.scaleMode = SKSceneScaleMode.aspectFill
        SoundManager.sharedInstance.audioPlayer?.stop()
        self.scene!.view?.presentScene(gameOverScene, transition: transition)
    }
    
    // using torch: lighten Scene
    func lightenScene(){
        // Setup light
        light = self.player?.childNode(withName: "light") as? SKLightNode
        light?.falloff = 0.5
        
        Timer.scheduledTimer(timeInterval:3,target:self,selector:#selector(GameScene.lightStart),userInfo:nil,repeats:false)
    }
    
    //light start
    func lightStart(){
        // Setup timer to control animation of lightening
        timer = Timer.scheduledTimer(timeInterval:0.1,target:self,selector:#selector(GameScene.falloff),userInfo:nil,repeats:true)
    }
    
    // light falloff
    func falloff(){
        light?.falloff += 0.1
        if( (light?.falloff)! > lightEnd){
            timer?.invalidate()
        }
    }
}
