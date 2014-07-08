//
//  Scene04.swift
//  TheSeasons
//
//  Created by ZhouHao on 8/7/14.
//  Copyright (c) 2014 Zeus Software. All rights reserved.
//

import SpriteKit
import AVFoundation

class Scene04: SKScene {
    
    var _btnLeft : SKSpriteNode?
    var _soundOff : Bool
    var _btnSound : SKSpriteNode?
    var _backgroundMusicPlayer : AVAudioPlayer?
    
    init(size: CGSize)  {
        
        /* set up your scene here */
        
        /* set up Sound */
        
        _soundOff = NSUserDefaults.standardUserDefaults().boolForKey("pref_sound")
        
        super.init(size: size)
        
        playBackgroundMusic("title_bgMusic.mp3")
        
        /* add background image */
        
        let background = SKSpriteNode(imageNamed: "to_be_continued")
        background.anchorPoint = CGPointZero
        background.position = CGPointZero
        
        addChild(background)
        
        /* additional setup */
        setUpFooter()
    }
    
    // make it a common function (The audio part should be common to all pages)
    func playBackgroundMusic(file : String) {
        
        var error : NSError? = nil
        let backgroundMusicURL = NSBundle.mainBundle().URLForResource(file , withExtension:nil)
        self._backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: backgroundMusicURL, error: &error)
        
        self._backgroundMusicPlayer!.numberOfLoops = -1
        self._backgroundMusicPlayer!.volume = 1.0
        self._backgroundMusicPlayer!.prepareToPlay()
    }
    
    func setUpFooter() {
        /* add the footer */
        
        let footer = SKSpriteNode(imageNamed: "footer")
        footer.position = CGPointMake(self.size.width/2, 38)
        
        addChild(footer)
        
        /* add the left button */
        
        _btnLeft = SKSpriteNode(imageNamed: "button_left")
        _btnLeft!.position = CGPointMake(self.size.width/2 + 400, 38)
        
        addChild(_btnLeft)
        
        /* add the sound button */
        if _btnSound != nil {
            _btnSound!.removeFromParent()
        }
        
        if (_soundOff)
        {
            _btnSound = SKSpriteNode(imageNamed: "button_sound_off")
            _btnSound!.position = CGPointMake(self.size.width/2 + 330, 38)
            
            addChild(_btnSound)
            _backgroundMusicPlayer!.stop()
        }
        else
        {
            _btnSound = SKSpriteNode(imageNamed: "button_sound_on")
            _btnSound!.position = CGPointMake(self.size.width/2 + 330, 38)
            
            addChild(_btnSound)
            
            _backgroundMusicPlayer!.play()
        }
    }
    
    func showSoundButtonForTogglePosition(togglePosition : Bool) {
        
        if (togglePosition)
        {
            _btnSound!.texture = SKTexture(imageNamed: "button_sound_on")
            
            _soundOff = false
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "pref_sound")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            _backgroundMusicPlayer!.play()
        }
        else
        {
            _btnSound!.texture = SKTexture(imageNamed: "button_sound_off")
            
            _soundOff = true
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "pref_sound")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            _backgroundMusicPlayer!.stop()
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        for touch : AnyObject in touches {
            
            let location = touch.locationInNode(self)
            
            if self._btnSound!.containsPoint(location)  {
                showSoundButtonForTogglePosition(_soundOff)
            }
            else if (_btnLeft!.containsPoint(location))
            {
                // NSLog(@"<<<<<<<<<<<<<<<<<< page backward");
                
                if (!actionForKey("readText")) // do not turn page if reading
                {
                    _backgroundMusicPlayer!.stop()
                    
                    let scene = Scene01(size: self.size)
                    let sceneTransition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration:1)
                    self.view.presentScene(scene, transition:sceneTransition)
                }
            }
            else if ( location.x >= 29 && location.x <= 285 && location.y >= 6 && location.y <= 68 )
            {
                // NSLog(@">>>>>>>>>>>>>>>>> page title");
                
                if (!actionForKey("readText")) // do not turn page if reading
                {
                    _backgroundMusicPlayer!.stop()
                    
                    let scene = Scene00(size: self.size)
                    let sceneTransition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration:1)
                    self.view.presentScene(scene, transition:sceneTransition)
                }
            }
            
        }
    }
    
}