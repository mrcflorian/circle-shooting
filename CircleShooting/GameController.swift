//
//  GameController.swift
//  CircleShooting
//
//  Created by Florian Marcu on 10/10/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import Foundation
import UIKit

class GameController {
    var game: Game = Game()
    var scoreManager: ScoreManager = ScoreManager(userDefaults: UserDefaults.standard)

    init() {
        scoreManager.updateLastScore(score: 0.0)
    }

    internal func increaseLevel() {
        game.incrementLevel()
        let score = Double(game.level - 1)
        scoreManager.updateHighScoreIfNecessary(score: score)
        scoreManager.updateLastScore(score: score)
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
