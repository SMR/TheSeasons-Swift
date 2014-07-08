//
//  Scene01.swift
//  TheSeasons
//
//  Created by ZhouHao on 8/7/14.
//  Copyright (c) 2014 Zeus Software. All rights reserved.
//

import SpriteKit
import AVFoundation

class Scene01: SKScene {
   
    var _footer : SKSpriteNode?
    var _btnLeft : SKSpriteNode?
    var _btnRight : SKSpriteNode?
    var _soundOff : Bool
    var _btnSound : SKSpriteNode?
    var _backgroundMusicPlayer : AVAudioPlayer?
    var _kid : SKSpriteNode?
    var _hat : SKSpriteNode?
    var _touchingHat : Bool = false
    var _touchPoint : CGPoint = CGPointZero
    
    init(size: CGSize)  {
        
        /* set up your scene here */
        
        /* set up Sound */
        
        _soundOff = NSUserDefaults.standardUserDefaults().boolForKey("pref_sound")
        
        super.init(size: size)
        
        playBackgroundMusic("pg01_bgMusic.mp3")
        
        /* add background image */
        
        let background = SKSpriteNode(imageNamed: "bg_pg01")
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
        let text = SKSpriteNode(imageNamed: "pg01_text")
        text.position = CGPointMake(300 , 530)
        
        addChild(text)
        readText()
    }
    
    func readText() {
        if (!self.actionForKey("readText"))
        {
            let readPause = SKAction.waitForDuration(0.25)
            let readText = SKAction.playSoundFileNamed("pg01.wav", waitForCompletion:true)
            
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
        
        setUpMainCharacter()
        setUpHat()
        
    }
    
    func setUpMainCharacter() {
        
        _kid = SKSpriteNode(imageNamed: "pg01_kid")
        _kid!.anchorPoint = CGPointZero
        _kid!.position = CGPointMake(self.size.width/2 - 245, 45)
        
        addChild(_kid)
        setUpMainCharacterAnimation()
    }
    
    func setUpHat() {
        let label = SKLabelNode(fontNamed: "Thonburi-Bold")
        label.text = "Help Mikey put on his hat!"
        label.fontSize = 20.0
        label.fontColor = UIColor.yellowColor()
        label.position = CGPointMake(160, 180)
        
        addChild(label)
        
        _hat = SKSpriteNode(imageNamed: "pg01_kid_hat")
        _hat!.position = CGPointMake(150, 290)
        _hat!.physicsBody = SKPhysicsBody(rectangleOfSize: _hat!.size)
        _hat!.physicsBody.restitution = 0.5
        
        addChild(_hat)
    }
    
    func setUpMainCharacterAnimation() {
        
        var textures = [SKTexture]()
        
        for ( var i = 0; i <= 2; i++)
        {
            let textureName = NSString(format: "pg01_kid0%d", i)
            let texture = SKTexture(imageNamed: textureName)
            textures.append(texture)
        }
  
        let duration : Float = RandomFloatRange2(3, 6)
        
        let blink = SKAction.animateWithTextures(textures, timePerFrame: 0.25)
        let wait = SKAction.waitForDuration(Double(duration))
        
        let mainCharacterAnimation = SKAction.sequence([blink, wait, blink, blink, wait , blink, blink])
        _kid!.runAction(SKAction.repeatActionForever(mainCharacterAnimation))
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
            
            if(_hat!.containsPoint(location))
            {
                // NSLog(@"xxxxxxxxxxxxxxxxxxx touched hat");
                _touchingHat = true
                _touchPoint = location
                
                /* change the physics or the hat is too 'heavy' */
                
                _hat!.physicsBody.velocity = CGVectorMake(0, 0)
                _hat!.physicsBody.angularVelocity = 0
                _hat!.physicsBody.affectedByGravity = false
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
                    
                    let scene = Scene02(size: self.size)
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
                    
                    let scene = Scene00(size: self.size)
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

    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        
        _touchPoint = touches.anyObject().locationInNode(self)
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        if (_touchingHat)
        {
            var currentPoint = touches.anyObject().locationInNode(self)
            
            if ( currentPoint.x >= 300 && currentPoint.x <= 550 &&
                currentPoint.y >= 250 && currentPoint.y <= 400 )
            {
                // NSLog(@"Close Enough! Let me do it for you");
                
                currentPoint.x = 420.0
                currentPoint.y = 330.0
                
                _hat!.position = currentPoint;
                
                let popSound = SKAction.playSoundFileNamed("thompsonman_pop.wav", waitForCompletion:false)
                _hat!.runAction(popSound)
            }
            else {
                _hat!.physicsBody.affectedByGravity = true
            }
            
            _touchingHat = false
        }
    }
    
    override func touchesCancelled(touches: NSSet, withEvent event: UIEvent) {
        _touchingHat = false
        _hat!.physicsBody.affectedByGravity = true
    }
    
    override func update(currentTime: NSTimeInterval) {
        if (_touchingHat)
        {
            _touchPoint.x = Clamp(_touchPoint.x, _hat!.size.width / 2, self.size.width - _hat!.size.width / 2);
            _touchPoint.y = Clamp(_touchPoint.y,
                _footer!.size.height +  _hat!.size.height / 2,
                self.size.height - _hat!.size.height / 2);
            
            _hat!.position = _touchPoint;
        }
    }
}
