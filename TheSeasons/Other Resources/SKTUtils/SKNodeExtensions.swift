//
//  SKNodeExtensions.swift
//  TheSeasons
//
//  Created by ZhouHao on 8/7/14.
//  Copyright (c) 2014 Zeus Software. All rights reserved.
//

import SpriteKit

extension SKNode {
    
    func skt_performSelector(selector : Selector, target : AnyObject, delay: NSTimeInterval)
    {
/*
    [self runAction:
    [SKAction sequence:@[
    [SKAction waitForDuration:delay],
    [SKAction performSelector:selector onTarget:target],
    ]]];
*/
    }
    
    func skt_bringToFront()
    {
        let parent = self.parent
        self.removeFromParent()
        parent.addChild(self)
    }
    
}