//
//  Game.swift
//  LineShoot
//
//  Created by Florian Marcu on 10/10/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import Foundation

let kMaxMonsterRadius: Double = 20.0
let kMinMonsterRadius: Double = 10.0

let kInitialMonsterDuration: TimeInterval = 3

struct Game {
    var level: Int = 1
    var monsterRadius: Double = kMaxMonsterRadius
    var monsterDuration: TimeInterval = 5.0

    mutating func incrementLevel() {
        level += 1
        monsterRadius = generateMonsterSize()
        monsterDuration = generateMonsterDuration()
    }

    private func generateMonsterSize() -> Double {
        let newMonsterRadius = Game.generateRandomDoubleBetween(x: kMinMonsterRadius, y: kMaxMonsterRadius)
        return newMonsterRadius
    }

    private func generateMonsterDuration() -> TimeInterval {
        let x = TimeInterval(Int(kInitialMonsterDuration * 5) - self.level) / 4
        return max(x + Game.generateRandomSmallDouble(), 0.3)
    }

    private static func generateRandomDoubleBetween(x: Double, y: Double) -> Double {
        return x + Double(arc4random_uniform(UInt32(y-x)))
    }
    private static func generateRandomSmallDouble() -> Double {
        return Double(arc4random_uniform(UInt32(1000)))/1000.0
    }
}
