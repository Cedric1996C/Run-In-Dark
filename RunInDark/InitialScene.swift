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
    let developerBtnTexture = SKTexture(imageNamed: "developer01")
    let startBtnPressedTexture = SKTexture(imageNamed: "start02")
    let optionBtnPressedTexture = SKTexture(imageNamed: "setting02")
    let developerBtnPressedTexture = SKTexture(imageNamed: "developer02")
    let titleTexture = SKTexture(imageNamed: "title01")

    var logoSprite: SKSpriteNode! = nil
    var optionBtn : SKSpriteNode! = nil
    var startBtn : SKSpriteNode! = nil
    var developerBtn: SKSpriteNode! = nil
    
    private let background = SKSpriteNode(imageNamed:"bg")
    
    var selectedBtn : SKSpriteNode?
    
    override func sceneDidLoad() {
//        self.backgroundColor = SKColor(red: 0, green:0, blue:0, alpha: 1)

        //Setup background
        background.position = CGPoint(x: size.width/2,y:size.height/2)
        background.zPosition = -1
        addChild(background)

        
        //Setup start button
        startBtn = SKSpriteNode(texture: startBtnTexture)
        startBtn.size = CGSize(width:40,height:40)
        startBtn.position = CGPoint(x: size.width / 2-100, y: size.height / 2 - 90)
        addChild(startBtn)
        
        //Setup options button
        optionBtn = SKSpriteNode(texture: optionBtnTexture)
        optionBtn.size = CGSize(width:40,height:40)
        optionBtn.position = CGPoint(x: size.width / 2+100, y: size.height / 2 - 90)
        addChild(optionBtn)

        //Setup developer info button
        developerBtn = SKSpriteNode(texture: developerBtnTexture)
        developerBtn.size = CGSize(width:30,height:30)
        developerBtn.position = CGPoint(x: size.width - 50 ,y: 50)
        addChild(developerBtn)
        
//        //Setup logo
//        logoSprite = SKSpriteNode(texture: titleTexture)
//        logoSprite.size = CGSize(width:450,height:100)
//        logoSprite.position = CGPoint(x: size.width / 2, y: size.height / 2 + 100)
//        addChild(logoSprite)
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
            } else if developerBtn.contains(touch.location(in: self)) {
                selectedBtn = developerBtn
                handledevelopBtnHover(isHovering: true)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            
            if selectedBtn == startBtn {
                handlestartBtnHover(isHovering: (startBtn.contains(touch.location(in: self))))
            } else if selectedBtn == optionBtn {
                handleoptionBtnHover(isHovering: (optionBtn.contains(touch.location(in: self))))
            } else if selectedBtn == developerBtn {
               handledevelopBtnHover(isHovering: (developerBtn.contains(touch.location(in: self))))            }
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
            } else if selectedBtn == developerBtn {
                handledevelopBtnHover(isHovering: false)
                
                if (developerBtn.contains(touch.location(in: self))) {
                    handledevelopBtnClick()
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
    
    func handledevelopBtnHover (isHovering : Bool) {
        if isHovering {
            developerBtn.texture = developerBtnPressedTexture
        } else {
            developerBtn.texture = developerBtnTexture
        }

    }
    
    func handlestartBtnClick() {
        let transition = SKTransition.reveal(with: .down, duration: 0.5)
        
        /// transitate to levelScene
        let scene = LevelScene(size: size)
        // Configure the view.
        let skView = self.view!

        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .aspectFill
        skView.presentScene(scene, transition: transition)
        
    }
    
    //open developer's GitHub by Safari
    func handledevelopBtnClick() {
        let urlString = "https://github.com/NJUcong"
        if let url = URL(string: urlString) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],completionHandler: {
                                            (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func handleoptionBtnClick() {
        if SoundManager.sharedInstance.toggleMute() {
            //Is muted
//            soundButton.texture = soundButtonTextureOff
        } else {
            //Is not muted
//            soundButton.texture = soundButtonTexture
        }
    
    }

}
