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
            
            let angle = atan2(current.y - target.y, current.x - target.x) + CGFloat(M_PI)
            let rotateAction = SKAction.rotate(toAngle: angle + CGFloat(M_PI*0.5), duration: 0.0)
            zombie.run(rotateAction)
            
            let velocotyX = zombieSpeed * cos(angle)
            let velocityY = zombieSpeed * sin(angle)
            
            let zombieVelocity = CGVector(dx: velocotyX, dy: velocityY)
            zombie.physicsBody!.velocity = zombieVelocity;
        }
    }
}
