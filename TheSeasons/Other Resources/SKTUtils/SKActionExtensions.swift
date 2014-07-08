//
//  SKActionExtensions.swift
//  TheSeasons
//
//  Created by ZhouHao on 8/7/14.
//  Copyright (c) 2014 Zeus Software. All rights reserved.
//

import SpriteKit

extension SKAction {
    
    class func skt_afterDelay(duration : NSTimeInterval, action: SKAction) -> SKAction
    {
        return SKAction.sequence([SKAction.waitForDuration(duration),action])
    }
    
    class func skt_afterDelay(duration: NSTimeInterval, block : dispatch_block_t) -> SKAction
    {
        return self.skt_afterDelay(duration, action: SKAction.runBlock(block))
    }
    
    class func skt_removeFromParentAfterDelay(duration: NSTimeInterval) -> SKAction
    {
        return self.skt_afterDelay(duration, action: SKAction.removeFromParent())
    }
    
}
