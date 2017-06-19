//
//  RoomSprite.swift
//  RunInDark
//
//  Created by NJUcong on 2017/6/19.
//  Copyright © 2017年 NJU. All rights reserved.
//

import UIKit
import  SpriteKit

class RoomSprite: SKSpriteNode {
    
    private var walls : [WallSprite] = [
        
    ]
    
    public static func newInstance(point:CGPoint) -> RoomSprite {
        let roomSprite = roomSprite(imageNamed:"wall")
        let size = CGSize(width:50,height:400)
        let wallTexture = SKTexture(imageNamed: "wall")
        roomSprite.physicsBody = SKPhysicsBody(texture:wallTexture,size:size)
        roomSprite.lightingBitMask = 1
        roomSprite.shadowCastBitMask = 1
        roomSprite.shadowedBitMask = 1
        roomSprite.physicsBody?.categoryBitMask = 3
        roomSprite.physicsBody?.contactTestBitMask = 2
        roomSprite.physicsBody?.isDynamic = false
        roomSprite.physicsBody?.allowsRotation = false
        roomSprite.physicsBody?.affectedByGravity = false
        return roomSprite
    }

}
