//
//  SKEmitterNodeExtensions.swift
//  TheSeasons
//
//  Created by ZhouHao on 8/7/14.
//  Copyright (c) 2014 Zeus Software. All rights reserved.
//

import SpriteKit

extension SKEmitterNode {
    
    class func skt_emitterNamed(name : NSString) -> SKAction
    {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource(name, ofType: "sks")) as SKAction
    }
    
}
