//
//  GameViewController.swift
//  RunInDark
//
//  Created by NJUcong on 2017/6/4.
//  Copyright © 2017年 NJU. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

extension SKNode {
    
    class func unarchiveFromFile(_ file : String) -> SKNode? {
        if let path = Bundle.main.path(forResource: file, ofType: "sks") {
            let sceneData = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWith: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
    
}

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let size = CGSize(width:667.0,height:375.0)
//        let sceneNode = InitialScene(size: view.frame.size)
        let sceneNode = InitialScene(size: size)
        sceneNode.scaleMode = .aspectFill
        
        if let view = self.view as! SKView? {
            view.presentScene(sceneNode)
            view.ignoresSiblingOrder = true            
            //            view.showsPhysics = true
            //            view.showsFPS = true
            //            view.showsNodeCount = true
        }
        
        //start playing BGM
        SoundManager.sharedInstance.StartPlaying(sceneName: "menu")

    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return UIInterfaceOrientationMask.landscapeRight
        } else {
            return UIInterfaceOrientationMask.all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
}
