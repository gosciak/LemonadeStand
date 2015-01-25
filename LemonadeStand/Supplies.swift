//
//  Supplies.swift
//  LemonadeStand
//
//  Created by Doug Gosciak on 15/01/17.
//  Copyright (c) 2015 Doug Gosciak. All rights reserved.
//

import Foundation


struct Supplies {
    var money = 0
    var lemons = 0
    var iceCubes = 0
    
    init(aMoney: Int, aLemons:Int, aIceCubes: Int) {
        money = aMoney
        lemons = aLemons
        iceCubes = aIceCubes
    }
}
