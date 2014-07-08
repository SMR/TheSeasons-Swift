//
//  SKTUtils.swift
//  TheSeasons
//
//  Created by ZhouHao on 8/7/14.
//  Copyright (c) 2014 Zeus Software. All rights reserved.
//

import SpriteKit
import Foundation

/*
func CGPointFromGLKVector2(vector : GLKVector2) -> CGPoint {
    return CGPointMake(vector.x, vector.y)
}
*/

func Clamp(value : Float, min : Float, max : Float) -> Float {
    return value < min ? min : value > max ? max : value;
}

// TODO: this one works only in playground!!!
let ARC4RANDOM_MAX = 0x100000000
func RandomFloatRange(min : Float, max : Float) -> Float {
    return floorf((Float(arc4random()) / Float(ARC4RANDOM_MAX)) * (max - min) + min);
}

// This one works
func RandomFloatRange2(min : UInt32, max : UInt32) -> Float {
    return Float(min + arc4random_uniform(max-min))
}
