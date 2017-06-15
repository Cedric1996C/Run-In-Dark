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
    let zombieSpeed: CGFloat = 80.0
    
    var goal: SKSpriteNode?
    var player: SKSpriteNode?
    var zombies: [SKSpriteNode] = []
    
    var lastTouch: CGPoint? = nil
    
    private let hud = GameSceneHudNode()
    private let screenSize = UIScreen.main.bounds
    

    override func sceneDidLoad() {
        camera?.scene?.anchorPoint = CGPoint(x:0.5,y:0.5)
        hud.setup(size: screenSize.size)
        addChild(hud)
        
        hud.returnBtnAction = {
            let transition = SKTransition.reveal(with: .left, duration: 0.75)
            let newSize = CGSize(width:self.screenSize.width,height:self.screenSize.height)
            let initialScene = InitialScene(size:newSize)
            initialScene.scaleMode = .aspectFit
            self.view?.presentScene(initialScene, transition: transition)
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

    }
    
    override func didMove(to view: SKView) {
        // Setup physics world's contact delegate
        physicsWorld.contactDelegate = self 
        
        // Setup player
        player = self.childNode(withName: "player") as? SKSpriteNode
        
        // Setup listener
        self.listener = player
        
        // Setup zombies
        for child in self.children {
            if child.name == "zombie" {
                if let child = child as? SKSpriteNode {
                    // Add SKAudioNode to zombie
                    let audioNode: SKAudioNode = SKAudioNode(fileNamed: "fear_moan.wav")
                    child.addChild(audioNode)
                    zombies.append(child)
                }
            }
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
//        touchEvents(touches)
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
        if firstBody.categoryBitMask == player?.physicsBody?.categoryBitMask &&
            secondBody.categoryBitMask == zombies[0].physicsBody?.categoryBitMask {
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
        let menuScene = MenuScene(size: self.size)
        menuScene.soundToPlay = didWin ? "fear_win.mp3" : "fear_lose.mp3"
        let transition = SKTransition.flipVertical(withDuration: 1.0)
        menuScene.scaleMode = SKSceneScaleMode.aspectFill
        self.scene!.view?.presentScene(menuScene, transition: transition)
    }
    
}
