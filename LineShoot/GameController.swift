//
//  GameController.swift
//  LineShoot
//
//  Created by Florian Marcu on 10/10/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import Foundation
import UIKit

class GameController: NSObject {
    var game: Game = Game()
    var highScoreManager: HighScoreManager = HighScoreManager(userDefaults: UserDefaults.standard)

    internal func increaseLevel() {
        game.incrementLevel()
        highScoreManager.updateHighScoreIfNecessary(score: Double(game.level - 1))
    }

    internal func monsterRadius() -> CGFloat {
        return CGFloat(game.monsterRadius)
    }

    internal func monsterCycleDuration() -> TimeInterval {
        return game.monsterDuration
    }

    internal func getScore() -> String {
        return String(game.level - 1)
    }
}
