//
//  PlayerSprite.swift
//  RunInDark
//
//  Created by NJUcong on 2017/6/13.
//  Copyright © 2017年 NJU. All rights reserved.
//
import SpriteKit

extension GameScene{
    
    // Determines if the player's position should be updated
    fileprivate func playerMove(currentPosition: CGPoint, touchPosition: CGPoint) -> Bool {
        return abs(currentPosition.x - touchPosition.x) > player!.frame.width / 2 ||
            abs(currentPosition.y - touchPosition.y) > player!.frame.height/2
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

}
