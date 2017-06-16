//
//  ZombieSprite.swift
//  RunInDark
//
//  Created by NJUcong on 2017/6/13.
//  Copyright © 2017年 NJU. All rights reserved.
//

import SpriteKit

extension GameScene {
    
    // Updates the position of all zombies by moving towards the player
    func updateZombies() {
        let target = player!.position
        
        for zombie in zombies {
            let current = zombie.position
            
            //checkout the distance between player and zombie
            let deltaX = current.x - target.x
            let deltaY = current.y - target.y
            let distance = sqrt(deltaX*deltaX + deltaY*deltaY)
            
            let angle = atan2(deltaY, deltaX) + CGFloat(M_PI)
            let rotateAction = SKAction.rotate(toAngle: angle + CGFloat(M_PI*0.5), duration: 0.0)
            zombie.run(rotateAction)

            if(distance < 160){
                findThePlayer()
            }
            
            let velocotyX = zombieSpeed * cos(angle)
            let velocityY = zombieSpeed * sin(angle)
            
            let zombieVelocity = CGVector(dx: velocotyX, dy: velocityY)
            zombie.physicsBody!.velocity = zombieVelocity;
        }
    }
    
    func findThePlayer() {
        run(SKAction.playSoundFileNamed("fear_moan.wav", waitForCompletion: true),withKey: "action_sound_effect")
    }
}
