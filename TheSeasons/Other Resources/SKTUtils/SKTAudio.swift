//
//  SKTAudio.swift
//  TheSeasons
//
//  Created by ZhouHao on 8/7/14.
//  Copyright (c) 2014 Zeus Software. All rights reserved.
//

import AVFoundation

class SKTAudio {
    
    var backgroundMusicPlayer : AVAudioPlayer?
    var soundEffectPlayer : AVAudioPlayer?

    class var sharedInstance : SKTAudio {
    struct Static {
        static let instance : SKTAudio = SKTAudio()
        }
        return Static.instance
    }
 
    func playBackgroundMusic(filename : String) {

        var error : NSError? = nil
        let backgroundMusicURL : NSURL = NSBundle.mainBundle().URLForResource(filename, withExtension: nil)
        
        self.backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: backgroundMusicURL, error: &error)
        self.backgroundMusicPlayer!.numberOfLoops = -1;
        self.backgroundMusicPlayer!.prepareToPlay()
        self.backgroundMusicPlayer!.play()
    }
    
    func pauseBackgroundMusic() {
    
        self.backgroundMusicPlayer!.pause()
    }
    
    func playSoundEffect(filename : String) {

        let soundEffectURL : NSURL = NSBundle.mainBundle().URLForResource(filename, withExtension:nil)

        self.soundEffectPlayer!.numberOfLoops = 0;
        self.soundEffectPlayer!.prepareToPlay()
        self.soundEffectPlayer!.play()
    }
    
}
