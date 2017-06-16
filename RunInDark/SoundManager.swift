//
//  SoundManager.swift
//  RunInDark
//
//  Created by NJUcong on 2017/6/16.
//  Copyright © 2017年 NJU. All rights reserved.
//

import UIKit
import AVFoundation

class SoundManager: NSObject, AVAudioPlayerDelegate{
    static let sharedInstance = SoundManager()
    
    var audioPlayer : AVAudioPlayer?
    private(set) var isMuted = false
    
    static private let menu = "fear_bg"
    static private let game = "offer_your_heart"
    
    private override init() {
        
        //This is private so you can only have one Sound Manager ever.
        let defaults = UserDefaults.standard
        
        isMuted = defaults.bool(forKey: MuteKey)
    }
    
    public func StartPlaying(sceneName:String) {
        if !isMuted {
            var soundURL:URL!
            switch sceneName {
            case "menu":
                 soundURL = Bundle.main.url(forResource: SoundManager.menu, withExtension: "mp3")
            case "game":
                 soundURL = Bundle.main.url(forResource: SoundManager.game, withExtension: "mp3")
            default:
                print("Fail to set a correct music")
            }
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
                audioPlayer?.delegate = self
            } catch {
                print("audio player failed to load")
    
            }
            
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } else {
            print("Audio player is already playing!")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        //Just restart playing BGM
        StartPlaying(sceneName: "menu")
    }
    
    func toggleMute() -> Bool {
        isMuted = !isMuted
        
        let defaults = UserDefaults.standard
        defaults.set(isMuted, forKey: MuteKey)
        defaults.synchronize()
        
        if isMuted {
            audioPlayer?.stop()
        } else {
//            StartPlaying(sceneName: "menu")
            audioPlayer?.play()

        }
        
        return isMuted
    }
}
