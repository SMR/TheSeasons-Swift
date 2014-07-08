//
//  Scene00.swift
//  TheSeasons
//
//  Created by ZhouHao on 8/7/14.
//  Copyright (c) 2014 Zeus Software. All rights reserved.
//

import SpriteKit
import AVFoundation

class Scene00: SKScene {

    var _backgroundMusicPlayer : AVAudioPlayer?
    var _btnSound : SKSpriteNode?
    var _soundOff : Bool
    
    init(size: CGSize) {
        
        self._soundOff = NSUserDefaults.standardUserDefaults().boolForKey("pref_sound")

        super.init(size: size)
        
        playBackgroundMusic("title_bgMusic.mp3")
        
        let background = SKSpriteNode(imageNamed:"bg_title_page")
        background.anchorPoint = CGPointZero;
        background.position = CGPointZero;
        
        self.addChild(background)
        
        setUpBookTitle()
        setUpSoundButton()
    }
    
    func setUpBookTitle() {
        
        let bookTitle = SKSpriteNode(imageNamed: "title_text")
        bookTitle.name = "bookTitle"
        bookTitle.position = CGPointMake(425,900)
        addChild(bookTitle)
        
        let actionMoveDown = SKAction.moveToY(600, duration:2.0)
        let actionMoveUp = SKAction.moveToY(603, duration:0.25)
        let actionMoveDownFast = SKAction.moveToY(600, duration:0.25)
        
        let wait = SKAction.waitForDuration(0.75)
        let showButton = SKAction.runBlock({

            let buttonStart = SKSpriteNode(imageNamed:"button_read")
            buttonStart.name = "buttonStart"
            buttonStart.position = CGPointMake(425,460)
            self.addChild(buttonStart)
            
            buttonStart.runAction(SKAction.playSoundFileNamed("thompsonman_pop.wav", waitForCompletion: false))
        })
        
        bookTitle.runAction(SKAction.sequence([actionMoveDown, actionMoveUp, actionMoveDownFast, wait, showButton]))

    }
    
    func setUpSoundButton() {
        
        if _btnSound {
            
            _btnSound!.removeFromParent()
        }
        
        if (_soundOff)
        {
            if let btnSound = SKSpriteNode(imageNamed: "button_sound_off") as SKSpriteNode? {

                self._btnSound = btnSound
                self._btnSound!.position = CGPointMake(980, 38)
                addChild(self._btnSound)

            }

            self._backgroundMusicPlayer!.stop()
        }
        else
        {
            if let btnSound = SKSpriteNode(imageNamed: "button_sound_on") as SKSpriteNode? {
                
                self._btnSound = btnSound
                self._btnSound!.position = CGPointMake(980, 38)
            
                addChild(self._btnSound)
            }
            
            _backgroundMusicPlayer!.play()
        }
    }
    
    func playBackgroundMusic(file : String) {
        
        var error : NSError? = nil
        let backgroundMusicURL = NSBundle.mainBundle().URLForResource(file , withExtension:nil)
        self._backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: backgroundMusicURL, error: &error)

        self._backgroundMusicPlayer!.numberOfLoops = -1
        self._backgroundMusicPlayer!.volume = 1.0
        self._backgroundMusicPlayer!.prepareToPlay()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        for touch : AnyObject in touches {
            
            let startButton = self.childNodeWithName("buttonStart")
            
            let location = touch.locationInNode(self)
            if self._btnSound!.containsPoint(location)  {
                showSoundButtonForTogglePosition(_soundOff)
            }
            else if (startButton.containsPoint(location))
            {
                self._backgroundMusicPlayer!.stop()
                
                let scene = Scene01(size: self.size)
                let sceneTransition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 1)
                self.view.presentScene(scene, transition:sceneTransition)
            }
            
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
    
}
