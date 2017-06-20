//
//  ZombieSprite.swift
//  RunInDark
//
//  Created by NJUcong on 2017/6/13.
//  Copyright © 2017年 NJU. All rights reserved.
//

import SpriteKit

class ZombieSprite: SKSpriteNode{
    
    private var patrolInterval:CGFloat = 3.0
    private let patrolEnd:CGFloat = 2.0
    
    private var angle:CGFloat!
    private var rotateAction:SKAction!
    
    private var timer:Timer?
    private var timer2:Timer?
    private var findInterval:CGFloat = 3.0
    private let findEnd:CGFloat = 2.0
    
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
    
    public func update(target:CGPoint){
        let current = self.position
        
        //checkout the distance between player and zombie
        let deltaX = current.x - target.x
        let deltaY = current.y - target.y
        let distance = sqrt(deltaX*deltaX + deltaY*deltaY)
        
        if(distance < 300) {
            angle = atan2(deltaY, deltaX) + CGFloat(M_PI)
            rotateAction = SKAction.rotate(toAngle: angle + CGFloat(M_PI*0.5), duration: 0.0)
            self.run(rotateAction)
        }
        else if patrolInterval > patrolEnd{
//            print("patrol")
            patrolInterval = 0.0
            angle = CGFloat(arc4random_uniform(360))
            rotateAction = SKAction.rotate(toAngle: angle + CGFloat(M_PI*0.5), duration: 0.0)
            
            // Setup timer to control the timeInterval of patroling
            timer = Timer.scheduledTimer(timeInterval:0.1,target:self,selector:#selector(patrol),userInfo:nil,repeats:true)
            
            self.run(rotateAction)
        }
        
        if(distance < 160 && findInterval>findEnd){
            findThePlayer()
        }
        
        let velocotyX = self.speed * cos(angle)
        let velocityY = self.speed * sin(angle)
        
        let zombieVelocity = CGVector(dx: velocotyX, dy: velocityY)
        self.physicsBody!.velocity = zombieVelocity;
    }
    
    //if zombie find player, fear_moan will br played
    private func findThePlayer() {
        run(SKAction.playSoundFileNamed("fear_moan.wav", waitForCompletion: true),withKey: "action_sound_effect")
        findInterval = 0
        timer2 = Timer.scheduledTimer(timeInterval:1,target:self,selector:#selector(findPlaying),userInfo:nil,repeats:true)
    }
    
    //if zombie touch wall, it will change a direction
    func touchWall() {
        angle = CGFloat(arc4random_uniform(180))/180.0 * CGFloat(M_PI)
        rotateAction = SKAction.rotate(toAngle: angle + CGFloat(M_PI*0.5), duration: 0.0)
        self.run(rotateAction)
        patrolInterval -= 1.0
    }

    //if distance from zombie to player is more than 300,zombie will be patroling
    func patrol () {
        patrolInterval += 0.1
        if( patrolInterval > patrolEnd){
            timer?.invalidate()
        }
    }
    
    func findPlaying() {
        findInterval += 1.0
        if( findInterval > findEnd ){
            timer2?.invalidate()
        }
    }
    
}

extension GameScene {
    
    // Updates the position of all zombies by moving towards the player
    func updateZombies() {
        let target = player!.position
        
        for  zombie in zombies {
            zombie.update(target: target)
        }
    }
    
}

 
