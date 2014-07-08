//
//  Scene02.swift
//  TheSeasons
//
//  Created by ZhouHao on 8/7/14.
//  Copyright (c) 2014 Zeus Software. All rights reserved.
//

import SpriteKit
import AVFoundation

class Scene02: SKScene {
    
    var _footer : SKSpriteNode?
    var _btnLeft : SKSpriteNode?
    var _btnRight : SKSpriteNode?
    var _soundOff : Bool
    var _btnSound : SKSpriteNode?
    var _backgroundMusicPlayer : AVAudioPlayer?
    
    var _cat : SKSpriteNode?
    var _catSound : SKAction
    
    init(size: CGSize)  {
        
        /* set up your scene here */
        
        /* set up Sound */
        
        _soundOff = NSUserDefaults.standardUserDefaults().boolForKey("pref_sound")
        _catSound = SKAction.playSoundFileNamed("cameronmusic_meow.wav", waitForCompletion:false)
        
        super.init(size: size)
        
        playBackgroundMusic("pg02_bgMusic.mp3")
        
        /* add background image */
        
        let background = SKSpriteNode(imageNamed: "bg_pg02")
        background.anchorPoint = CGPointZero
        background.position = CGPointZero
        
        addChild(background)
        
        /* additional setup */
        setUpText()
        setUpFooter()
        
        /* add the cat (you don't always need a seperate method) */
        
        _cat = SKSpriteNode(imageNamed: "pg02_cat")
        _cat!.anchorPoint = CGPointZero;
        _cat!.position = CGPointMake(240, 84)
        
        addChild(_cat)
        
        /* make 'em meow! */
        
        let wait = SKAction.waitForDuration(0.86)
        let catSoundInitial = SKAction.playSoundFileNamed("thegertz_meow.wav", waitForCompletion:false)
        
        _cat!.runAction(SKAction.sequence([wait, catSoundInitial]))
        
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
    
    func setUpText() {
        let text = SKSpriteNode(imageNamed: "pg02_text")
        text.position = CGPointMake(680 , 530)
        
        addChild(text)
        readText()
    }
    
    func readText() {
        if (!self.actionForKey("readText"))
        {
            let readPause = SKAction.waitForDuration(0.25)
            let readText = SKAction.playSoundFileNamed("pg02.wav", waitForCompletion:true)
            
            let readSequence = SKAction.sequence([readPause, readText])
            
            runAction(readSequence, withKey:"readText")
        }
        else
        {
            removeActionForKey("readText")
        }
    }
    
    func setUpFooter() {
        /* add the footer */
        
        self._footer = SKSpriteNode(imageNamed: "footer")
        self._footer!.position = CGPointMake(self.size.width/2, 38)
        
        addChild(self._footer)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: _footer!.frame)
        
        /* add the right button */
        
        _btnRight = SKSpriteNode(imageNamed: "button_right")
        _btnRight!.position = CGPointMake(self.size.width/2 + 470, 38)
        
        addChild(_btnRight)
        
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
    
    func playCatSound()
    {
        _cat!.runAction(_catSound)
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
            
            if(location.x >= 300 && location.x < 480 && location.y >= 100 && location.y <= 350)
            {
                playCatSound()
            }
            else if self._btnSound!.containsPoint(location)  {
                showSoundButtonForTogglePosition(_soundOff)
            }
            else if (_btnRight!.containsPoint(location))
            {
                // NSLog(@">>>>>>>>>>>>>>>>> page forward");
                
                if (!actionForKey("readText")) // do not turn page if reading
                {
                    _backgroundMusicPlayer!.stop()
                    
                    let scene = Scene03(size: self.size)
                    let sceneTransition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration:1)
                    self.view.presentScene(scene, transition:sceneTransition)
                }
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