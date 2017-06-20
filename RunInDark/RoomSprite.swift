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
    
    private static let positions : [CGPoint] = [
        CGPoint(x:25,y:175),
        CGPoint(x:225,y:25),
        CGPoint(x:375,y:225)
    ]
    private static let rotation : [CGFloat] = [
        0,
        CGFloat(M_PI*0.5),
        0
    ]
    
    public static func newInstance(point:CGPoint) -> RoomSprite {
        let roomSprite = RoomSprite()
        var wallPhysicsBodies = [SKPhysicsBody]()
        let size = CGSize(width:400,height:400)
        roomSprite.size = size
        for i in 0..<positions.count {
            let wall = WallSprite.newInstance(point: positions[i], rotation: rotation[i])
            roomSprite.addChild(wall)
            wallPhysicsBodies.append(wall.physicsBody!)
        }
        
        roomSprite.anchorPoint = CGPoint(x:0,y:0)
//        roomSprite.color = .red

        roomSprite.lightingBitMask = 1
        roomSprite.shadowCastBitMask = 0
        roomSprite.shadowedBitMask = 0
        
//        roomSprite.physicsBody = SKPhysicsBody.init(bodies: wallPhysicsBodies)
        
        roomSprite.physicsBody?.categoryBitMask = 3
        roomSprite.physicsBody?.contactTestBitMask = 2
        roomSprite.physicsBody?.isDynamic = false
        roomSprite.physicsBody?.allowsRotation = false
        roomSprite.physicsBody?.affectedByGravity = false
//        roomSprite.physicsBody?.pinned = true
        roomSprite.position = point
        return roomSprite
    }

}
