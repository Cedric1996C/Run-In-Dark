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

    public static func newInstance(point:CGPoint) -> WallSprite {
        let wallSprite = WallSprite(imageNamed:"wall")
        let size = CGSize(width:50,height:400)
        let wallTexture = SKTexture(imageNamed: "wall")
        wallSprite.physicsBody = SKPhysicsBody(texture:wallTexture,size:size)
        wallSprite.position = CGPoint(x:25,y:200)
        wallSprite.lightingBitMask = 1
        wallSprite.shadowCastBitMask = 1
        wallSprite.shadowedBitMask = 1
        wallSprite.physicsBody?.categoryBitMask = 3
        wallSprite.physicsBody?.contactTestBitMask = 2
        wallSprite.physicsBody?.isDynamic = false
        wallSprite.physicsBody?.allowsRotation = false
        wallSprite.physicsBody?.affectedByGravity = false
        return wallSprite
    }

}
