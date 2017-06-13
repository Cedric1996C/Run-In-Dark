//
//  MenuScene.swift
//  RunInDark
//
//  Created by NJUcong on 2017/6/13.
//  Copyright © 2017年 NJU. All rights reserved.
//

import UIKit
import SpriteKit

class InitialScene: SKScene {
    
    let startBtnTexture = SKTexture(imageNamed: "start01")
    let optionBtnTexture = SKTexture(imageNamed: "setting01")
    let startBtnPressedTexture = SKTexture(imageNamed: "start02")
    let optionBtnPressedTexture = SKTexture(imageNamed: "setting02")
    let titleTexture = SKTexture(imageNamed: "title01")


    var logoSprite: SKSpriteNode! = nil
    var optionBtn : SKSpriteNode! = nil
    var startBtn : SKSpriteNode! = nil
    var developerBtn: SKSpriteNode! = nil
    
    var selectedBtn : SKSpriteNode?
    
    override func sceneDidLoad() {
        self.backgroundColor = SKColor(red: 0, green:0, blue:0, alpha: 1)
//        self.backgroundColor = SKColor(red:160,green:160,blue:160,alpha:1)
        
        //Setup start button
        startBtn = SKSpriteNode(texture: startBtnTexture)
        startBtn.size = CGSize(width:35,height:100)
        startBtn.position = CGPoint(x: size.width / 2-50, y: size.height / 2 - 100)
        addChild(startBtn)
        
        //Setup options button
        optionBtn = SKSpriteNode(texture: optionBtnTexture)
        optionBtn.size = CGSize(width:35,height:100)
        optionBtn.position = CGPoint(x: size.width / 2+50, y: size.height / 2 - 100)
        addChild(optionBtn)

        
        //Setup logo
        logoSprite = SKSpriteNode(texture: titleTexture)
        logoSprite.size = CGSize(width:300,height:200)
        logoSprite.position = CGPoint(x: size.width / 2, y: size.height / 2 + 100)
        addChild(logoSprite)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if selectedBtn != nil {
                handlestartBtnHover(isHovering: false)
                handleoptionBtnHover(isHovering: false)
            }
            
            if startBtn.contains(touch.location(in: self)) {
                selectedBtn = startBtn
                handlestartBtnHover(isHovering: true)
            } else if optionBtn.contains(touch.location(in: self)) {
                selectedBtn = optionBtn
                handleoptionBtnHover(isHovering: true)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            
            if selectedBtn == startBtn {
                handlestartBtnHover(isHovering: (startBtn.contains(touch.location(in: self))))
            } else if selectedBtn == optionBtn {
                handleoptionBtnHover(isHovering: (optionBtn.contains(touch.location(in: self))))
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            
            if selectedBtn == startBtn {
                handlestartBtnHover(isHovering: false)
                
                if (startBtn.contains(touch.location(in: self))) {
                    handlestartBtnClick()
                }
                
            } else if selectedBtn == optionBtn {
                handleoptionBtnHover(isHovering: false)
                
                if (optionBtn.contains(touch.location(in: self))) {
                    handleoptionBtnClick()
                }
            }
        }
        
        selectedBtn = nil
    }
    
    func handlestartBtnHover(isHovering : Bool) {
        if isHovering {
            startBtn.texture = startBtnPressedTexture
        } else {
            startBtn.texture = startBtnTexture
        }
    }
    
    func handleoptionBtnHover(isHovering : Bool) {
        if isHovering {
            optionBtn.texture = optionBtnPressedTexture
        } else {
            optionBtn.texture = optionBtnTexture
        }
    }
    
    func handlestartBtnClick() {
        let transition = SKTransition.reveal(with: .down, duration: 0.75)
//        let gameScene = GameScene(size:size)
//        gameScene.scaleMode = scaleMode
//        view?.presentScene(gameScene, transition: transition)
        //import GameScene
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view!
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill        
            skView.presentScene(scene, transition: transition)
        }

    }
    
    func handleoptionBtnClick() {
//        if SoundManager.sharedInstance.toggleMute() {
//            //Is muted
//            optionBtn.texture = optionBtnTextureOff
//        } else {
//            //Is not muted
//            optionBtn.texture = optionBtnTexture
//        }
    }

}
