//
//  pauseButton.swift
//  RunInDark
//
//  Created by NJUcong on 2017/6/14.
//  Copyright © 2017年 NJU. All rights reserved.
//

import UIKit
import SpriteKit

class GameSceneHudNode: SKNode {

    //pause\return相关参数
    private(set) var pauseBtnPressed = false
    private var pauseBtn: SKSpriteNode!
    private let pauseBtnTexture = SKTexture(imageNamed:"pause01")
    private let pauseBtnPressedTexture = SKTexture(imageNamed: "pause02")
    
    private(set) var returnBtnPressed = false
    private var returnBtn: SKSpriteNode!
    private let returnBtnTexture = SKTexture(imageNamed: "return01")
    private let returnBtnPressedTexture = SKTexture(imageNamed:"return02")
    
    private var continueBtn: SKSpriteNode!
    private let continueBtnTexture = SKTexture(imageNamed:"pause01")
    private let continueBtnPressedTexture = SKTexture(imageNamed: "pause02")

    
    var pauseBtnAction: (() -> ())?
    var returnBtnAction: (() -> ())?
    
    var selectedBtn: SKSpriteNode?
    
    private let screenSize = UIScreen.main.bounds
    
    //Setup hud here
    public func setup(size: CGSize) {
        
        
        pauseBtn = SKSpriteNode(texture: pauseBtnTexture)
        pauseBtn.size =  CGSize(width:35,height:35)
        pauseBtn.position = CGPoint(x: screenSize.height/2 - 40, y: screenSize.width/2 - 120 )
        pauseBtn.zPosition = 1000
        
        addChild(pauseBtn)
        
        returnBtn = SKSpriteNode(texture: returnBtnTexture)
        returnBtn.size =  CGSize(width:35,height:35)
        returnBtn.position = CGPoint(x: screenSize.height/2 - 40, y: screenSize.width/2 - 40  )
        returnBtn.zPosition = 1000
        
        addChild(returnBtn)
        
    }
    
    func touchBeganAtPoint(point: CGPoint) {

        let relativePoint = CGPoint(x:-(point.y - screenSize.height/2), y:-(point.x - screenSize.width/2))
        let containsPause = pauseBtn.contains(relativePoint)
        let containsReturn = returnBtn.contains(relativePoint)
        
        if pauseBtnPressed && !containsPause {
            //Cancel the last click
            pauseBtnPressed = false
            pauseBtn.texture = pauseBtnTexture
        }
        else if returnBtnPressed && !containsReturn {
            //Cancel the last click
            returnBtnPressed = false
            returnBtn.texture = returnBtnTexture
        }
        else if containsPause {
            pauseBtn.texture = pauseBtnPressedTexture
            pauseBtnPressed = true
        }
        else if containsReturn {
            returnBtn.texture = returnBtnPressedTexture
            returnBtnPressed = true
        }
    }
    
    func touchMovedToPoint(point: CGPoint) {
        
        let relativePoint = CGPoint(x:-(point.y - screenSize.height/2), y:-(point.x - screenSize.width/2))
        if pauseBtnPressed {
            if pauseBtn.contains(relativePoint) {
                pauseBtn.texture = pauseBtnPressedTexture
            } else {
                pauseBtn.texture = pauseBtnTexture
            }
        } else if  returnBtnPressed {
            if returnBtn.contains(relativePoint) {
                returnBtn.texture = returnBtnPressedTexture
            } else {
                returnBtn.texture = returnBtnTexture
            }
        }
    }
    
    func touchEndedAtPoint(point: CGPoint) {
        let relativePoint = CGPoint(x:-(point.y - screenSize.height/2), y:-(point.x - screenSize.width/2))
        if pauseBtn.contains(relativePoint) && pauseBtnAction != nil {
            pauseBtnAction!()
        } else if returnBtn.contains(relativePoint) && returnBtnAction != nil {
            returnBtnAction!()
        }
        
        pauseBtn.texture = pauseBtnTexture
        returnBtn.texture = returnBtnTexture
    }
    
    func createContinueBtn(){
        continueBtn = SKSpriteNode(texture: continueBtnTexture)
        continueBtn.size =  CGSize(width:60,height:60)
        continueBtn.position = CGPoint(x: 0, y: 0)
        continueBtn.zPosition = 1000
        
        addChild(continueBtn)
    }

    
}
