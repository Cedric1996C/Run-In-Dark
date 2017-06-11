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
        touchEvents(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchEvents(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchEvents(touches)
    }
    
    fileprivate func touchEvents(_ touches: Set<UITouch>){
        for touch in touches{
            let location = touch.location(in:self)
            lastTouch = location
        }
    }
    
    // Determines if the player's position should be updated
    fileprivate func playerMove(currentPosition: CGPoint, touchPosition: CGPoint) -> Bool {
        return abs(currentPosition.x - touchPosition.x) > player!.frame.width / 2 ||
            abs(currentPosition.y - touchPosition.y) > player!.frame.height/2
    }

    
    //MARK - update
    override func didSimulatePhysics(){
        if let _ = player{
            updatePlayer()
            updateZombies()
        }
    }
    
    // Updates the player's position by moving towards the last touch made
    func updatePlayer() {
        if let touch = lastTouch {
            let currentPosition = player!.position
            if playerMove(currentPosition: currentPosition, touchPosition: touch) {
                
                let angle = atan2(currentPosition.y - touch.y, currentPosition.x - touch.x) + CGFloat(M_PI)
                let rotateAction = SKAction.rotate(toAngle: angle + CGFloat(M_PI*0.5), duration: 0)
                
                //player rotate
                player!.run(rotateAction)
                
                let velocotyX = playerSpeed * cos(angle)
                let velocityY = playerSpeed * sin(angle)
                
                let playerVelocity = CGVector(dx: velocotyX, dy: velocityY)
                player!.physicsBody!.velocity = playerVelocity;
                updateCamera()
            } else {
                // player keep static
                player!.physicsBody!.isResting = true
            }
        }
    }
    
    //Update the camera
    func updateCamera(){
        if let camera = camera {
            camera.position = CGPoint(x: player!.position.x, y: player!.position.y)
        }
    }
    
    // Updates the position of all zombies by moving towards the player
    func updateZombies() {
        let target = player!.position
        
        for zombie in zombies {
            let current = zombie.position
            
            let angle = atan2(current.y - target.y, current.x - target.x) + CGFloat(M_PI)
            let rotateAction = SKAction.rotate(toAngle: angle + CGFloat(M_PI*0.5), duration: 0.0)
            zombie.run(rotateAction)
            
            let velocotyX = zombieSpeed * cos(angle)
            let velocityY = zombieSpeed * sin(angle)
            
            let zombieVelocity = CGVector(dx: velocotyX, dy: velocityY)
            zombie.physicsBody!.velocity = zombieVelocity;
        }
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
