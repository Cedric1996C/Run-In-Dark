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
    
    private(set) var continueBtnPressed = false
    private var continueBtn: SKSpriteNode!
    private let continueBtnTexture = SKTexture(imageNamed:"continue01")
    private let continueBtnPressedTexture = SKTexture(imageNamed: "continue02")
    
    // add item torch
    private(set) var torchBtnPressed = false
    private(set) var torchIsUsed = false
    private var torchBtn: SKSpriteNode!
    private let torchBtnTexture = SKTexture(imageNamed:"torch01")
    private let torchBtnPressedTexture = SKTexture(imageNamed: "torch02")
    private let torchBtnIsUsedTexture = SKTexture(imageNamed: "torchUsed")
    
    // button click actions
    var pauseBtnAction: (() -> ())?
    var returnBtnAction: (() -> ())?
    var continueBtnAction: (() -> ())?
    var torchBtnAction:(() -> ())?
    
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
        
        torchBtn = SKSpriteNode(texture: torchBtnTexture)
        torchBtn.size =  CGSize(width:50,height:50)
        torchBtn.position = CGPoint(x: screenSize.height/2 - 45, y: -screenSize.width/2 + 60  )
        torchBtn.zPosition = 1000
        
        addChild(torchBtn)

    }
    
    func touchBeganAtPoint(point: CGPoint) {

        let relativePoint = CGPoint(x:-(point.y - screenSize.height/2), y:-(point.x - screenSize.width/2))
        let containsPause = pauseBtn.contains(relativePoint)
        let containsReturn = returnBtn.contains(relativePoint)
        var containsTorch = false
        var containsContinue = false
       
        //judge if buttons work
        if(continueBtn != nil){
            containsContinue = continueBtn.contains(relativePoint)
        }
        if(!torchIsUsed){
            containsTorch = torchBtn.contains(relativePoint)
        }
        
        //judge position of touchpoint
        if pauseBtnPressed
            && !containsPause
            && !containsContinue
            && !containsTorch{
            //Cancel the last click
            pauseBtnPressed = false
            pauseBtn.texture = pauseBtnTexture
        }
        else if returnBtnPressed
            && !containsReturn
            && !containsContinue
            && !containsTorch{
            //Cancel the last click
            returnBtnPressed = false
            returnBtn.texture = returnBtnTexture
        }else if continueBtnPressed
            && !containsReturn
            && !containsPause
            && !containsTorch{
            //Cancel the last click
            continueBtnPressed = false
        }
        else if torchBtnPressed
            && !containsReturn
            && !containsPause
            && !containsContinue{
            //Cancel the last click
            torchBtnPressed = false
        }
        else if containsPause {
            pauseBtn.texture = pauseBtnPressedTexture
            pauseBtnPressed = true
        }
        else if containsReturn {
            returnBtn.texture = returnBtnPressedTexture
            returnBtnPressed = true
        }
        else if containsContinue {
            continueBtn.texture = continueBtnPressedTexture
            continueBtnPressed = true
        }
        else if containsTorch {
            torchBtn.texture = torchBtnPressedTexture
            torchBtnPressed = true
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
        } else if  continueBtnPressed {
            if continueBtn.contains(relativePoint) {
                continueBtn.texture = continueBtnPressedTexture
            } else {
                continueBtn.texture = continueBtnTexture
            }
        } else if torchBtnPressed {
            if torchBtn.contains(relativePoint) {
                torchBtn.texture = torchBtnPressedTexture
            } else {
                torchBtn.texture = torchBtnTexture
            }
        }
        
    }
    
    func touchEndedAtPoint(point: CGPoint) {
        let relativePoint = CGPoint(x:-(point.y - screenSize.height/2), y:-(point.x - screenSize.width/2))
        if pauseBtn.contains(relativePoint) && pauseBtnAction != nil {
            pauseBtnAction!()
        }
        else if returnBtn.contains(relativePoint) && returnBtnAction != nil {
            returnBtnAction!()
        }
        else if(continueBtn != nil){
            if continueBtn.contains(relativePoint) && continueBtnAction != nil {
                continueBtnAction!()
            }
        }
        else if(!torchIsUsed){
            if(torchBtn.contains(relativePoint) && torchBtn != nil){
                torchIsUsed = true
                torchBtnAction!()
            }
        }
        
        
        pauseBtn.texture = pauseBtnTexture
        returnBtn.texture = returnBtnTexture
    }
    
    // show Continue Button
    func createContinueBtn(){
        if(continueBtn == nil){
            continueBtn = SKSpriteNode(texture: continueBtnTexture)
            continueBtn.size =  CGSize(width:60,height:60)
            continueBtn.position = CGPoint(x: 0, y: 0)
            continueBtn.zPosition = 1000
        
            self.addChild(continueBtn)
        }
    }
    
    // dismiss Continue Button
    func dissmissContinueBtn(){
        continueBtn.texture = continueBtnTexture
        continueBtn.removeFromParent()
        continueBtn = nil
    }
    
    //change torch state: add/decline
    func changeTorchState(){
        torchBtn.texture = torchIsUsed ? torchBtnIsUsedTexture:torchBtnTexture
    }
    
}
