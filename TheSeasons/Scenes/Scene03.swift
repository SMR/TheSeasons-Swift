//
//  Scene03.swift
//  TheSeasons
//
//  Created by ZhouHao on 8/7/14.
//  Copyright (c) 2014 Zeus Software. All rights reserved.
//

import SpriteKit
import AVFoundation

class Scene03: SKScene {
    
    var _footer : SKSpriteNode?
    var _btnLeft : SKSpriteNode?
    var _btnRight : SKSpriteNode?
    var _soundOff : Bool
    var _btnSound : SKSpriteNode?
    var _backgroundMusicPlayer : AVAudioPlayer?
    
    init(size: CGSize)  {
        
        /* set up your scene here */
        
        /* set up Sound */
        
        _soundOff = NSUserDefaults.standardUserDefaults().boolForKey("pref_sound")
        
        super.init(size: size)
        
        playBackgroundMusic("pg03_bgMusic.mp3")
        
        /* add background image */
        
        let background = SKSpriteNode(imageNamed: "bg_pg03")
        background.anchorPoint = CGPointZero
        background.position = CGPointZero
        
        addChild(background)
        
        /* additional setup */
        setUpText()
        setUpFooter()
        setUpMainScene()
        
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
        let text = SKSpriteNode(imageNamed: "pg03_text")
        text.position = CGPointMake(690 , 585)
        
        addChild(text)
        readText()
    }
    
    func readText() {
        if (!self.actionForKey("readText"))
        {
            let readPause = SKAction.waitForDuration(0.25)
            let readText = SKAction.playSoundFileNamed("pg03.wav", waitForCompletion:true)
            
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
    
    func setUpMainScene() {
        /* add the kid and the cat */
        
        let cat = SKSpriteNode(imageNamed: "pg03_kid_cat")
        cat.anchorPoint = CGPointZero
        cat.position = CGPointMake(self.size.width/2 - 25, 84)
        
        addChild(cat)
        
        /* add Snowflakes */
        
        let duration = 1.25 // determines how often to create snowflakes
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock{self.spawnSnowflake()},SKAction.waitForDuration(duration)])))
        
    }
    
    func spawnSnowflake() {
        
        // here you can even add physics and a shake motion too
        let randomNumber : Float = RandomFloatRange2(1, 4)
        let duration : Float = RandomFloatRange2(5, 21)
        
        let snowflakeImageName = NSString(format: "snowfall0%.0f",randomNumber)
        let snowflake = SKSpriteNode(imageNamed: snowflakeImageName)
        snowflake.name = "snowflake";
        
        snowflake.position = CGPointMake(RandomFloatRange2(0, UInt32(self.size.height)), self.size.height + self.size.height/2);
        self.addChild(snowflake)
        
        let actionMove = SKAction.moveTo(CGPointMake(snowflake.position.x + 100, -snowflake.size.height/2), duration:Double(duration))
        
        let actionRemove = SKAction.removeFromParent()
        snowflake.runAction(SKAction.sequence([actionMove, actionRemove]))
    }
    
    func checkCollisions()
    {
        // simplified version
        self.enumerateChildNodesWithName("snowflake") {
            node, stop in

            var snowflake = node as SKSpriteNode
            let footerFrameWithPadding = CGRectInset(self._footer!.frame, -25, -25) // set padding around foot frame
            
            if (CGRectIntersectsRect(snowflake.frame, footerFrameWithPadding))
            {
                snowflake.removeFromParent()
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
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        for touch : AnyObject in touches {
            
            let location = touch.locationInNode(self)
            
            if self._btnSound!.containsPoint(location)  {
                showSoundButtonForTogglePosition(_soundOff)
            }
            else if (_btnRight!.containsPoint(location))
            {
                // NSLog(@">>>>>>>>>>>>>>>>> page forward");
                
                if (!actionForKey("readText")) // do not turn page if reading
                {
                    _backgroundMusicPlayer!.stop()
                    
                    let scene = Scene04(size: self.size)
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
                    
                    let scene = Scene02(size: self.size)
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
    
    override func update(currentTime: NSTimeInterval) {
        
        // TODO: this will cause crash
        // the error message is: was mutated while being enumerated.
        //self.checkCollisions()
    }
    
}