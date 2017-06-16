//
//  ZombieSprite.swift
//  RunInDark
//
//  Created by NJUcong on 2017/6/13.
//  Copyright © 2017年 NJU. All rights reserved.
//

import SpriteKit

class ZombieSprite: SKSpriteNode{
    
    private var patrolInterval:CGFloat = 0.0
    
    public static func newInstance(point:CGPoint) -> ZombieSprite {
        let zombieSprite = ZombieSprite(imageNamed:"zombie")
        let zombieSize = CGSize(width:40,height:40)
        let zombieTexture = SKTexture(imageNamed: "zombie")
        zombieSprite.physicsBody = SKPhysicsBody(texture:zombieTexture,size:zombieSize)
        zombieSprite.lightingBitMask = 1
        zombieSprite.shadowCastBitMask = 1
        zombieSprite.shadowedBitMask = 1
        zombieSprite.physicsBody?.categoryBitMask = 2
        zombieSprite.physicsBody?.contactTestBitMask = 1
        zombieSprite.position = point
        zombieSprite.speed = 80.0
        zombieSprite.physicsBody?.allowsRotation = false
        zombieSprite.physicsBody?.affectedByGravity = false
        return zombieSprite
    }
    
}

extension GameScene {
    
    // Updates the position of all zombies by moving towards the player
    func updateZombies() {
        let target = player!.position
        
        for  zombie in zombies {
            let current = zombie.position
            
            //checkout the distance between player and zombie
            let deltaX = current.x - target.x
            let deltaY = current.y - target.y
            let distance = sqrt(deltaX*deltaX + deltaY*deltaY)
            
            if(distance < 300) {
                let angle = atan2(deltaY, deltaX) + CGFloat(M_PI)
                let rotateAction = SKAction.rotate(toAngle: angle + CGFloat(M_PI*0.5), duration: 0.0)
                zombie.run(rotateAction)
                
                if(distance < 160){
                    findThePlayer()
                }
                
                let velocotyX = zombie.speed * cos(angle)
                let velocityY = zombie.speed * sin(angle)
                
                let zombieVelocity = CGVector(dx: velocotyX, dy: velocityY)
                zombie.physicsBody!.velocity = zombieVelocity;
            }
            else {
                zombie.patrol()
            }
        }
    }
    
    //if zombie find player, fear_moan will br played
    func findThePlayer() {
        run(SKAction.playSoundFileNamed("fear_moan.wav", waitForCompletion: true),withKey: "action_sound_effect")
    }
    
    //if zombie touch wall, it will change a direction
    func touchWall() {
        
    }
}

extension SKSpriteNode {
    
    //    private var patrolInterval:CGFloat = 0.0
    
    //if distance from zombie to player is more than 300,zombie will be patroling
    func patrol () {
        
    }
    
}

 
