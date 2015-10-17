//
//  Constants.swift
//  Nimble Ninja
//
//  Created by Matthew Frampton on 03/09/2015.
//  Copyright (c) 2015 theswiftproject. All rights reserved.
//

import Foundation
import UIKit

//Configuration
let KMLGroundHeight: CGFloat = 20.0

//Initial variables
let kDefaultXToMovePerSecond: CGFloat = 300.0

//Collision Detection
let heroCatagory: UInt32 = 0x1 << 0
let wallCatagory: UInt32 = 0x1 << 1

//Game variables
let kNumberOfPointsPerLevel = 5
let kLevelGenerationTimes: [NSTimeInterval] = [1.0, 0.8, 0.7, 0.5, 0.4]