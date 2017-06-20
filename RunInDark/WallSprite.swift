//
//  WallSprite.swift
//  RunInDark
//
//  Created by NJUcong on 2017/6/19.
//  Copyright © 2017年 NJU. All rights reserved.
//

import UIKit
import SpriteKit

class WallSprite: SKSpriteNode {

    public static func newInstance(point:CGPoint,rotation:CGFloat) -> WallSprite {
        let wallSprite = WallSprite(imageNamed:"wall_50x350")
        let size = CGSize(width:50,height:350)
        let wallTexture = SKTexture(imageNamed: "wall_50x350")
        
        wallSprite.anchorPoint = CGPoint(x:0.5,y:0.5)
        wallSprite.position = point
        wallSprite.zRotation = rotation
        
        wallSprite.lightingBitMask = 1
        wallSprite.shadowCastBitMask = 1
        wallSprite.shadowedBitMask = 1
       
        wallSprite.physicsBody = SKPhysicsBody(texture:wallTexture,size:size)
        wallSprite.physicsBody?.categoryBitMask = 3
        wallSprite.physicsBody?.contactTestBitMask = 2
        wallSprite.physicsBody?.isDynamic = false
        wallSprite.physicsBody?.allowsRotation = false
        wallSprite.physicsBody?.affectedByGravity = false
        wallSprite.physicsBody?.pinned = true
        
        return wallSprite
    }

}
