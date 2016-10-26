//
//  HighScoreManager.swift
//  LineShoot
//
//  Created by Florian Marcu on 10/20/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import UIKit
import Foundation

private let kHighScoreStoringKey = "kHighScoreStoringKey"

class HighScoreManager {

    var userDefaults: UserDefaults!

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    func updateHighScoreIfNecessary(score: Double) {
        let highScore = currentHighScore()
        if (score > highScore) {
            updateHighScore(score: score)
        }
    }

    func currentHighScore() -> Double {
        if userDefaults.object(forKey: kHighScoreStoringKey) != nil {
            return userDefaults.double(forKey: kHighScoreStoringKey)
        }
        return 0.0
    }

    private func updateHighScore(score: Double) {
        userDefaults.set(score, forKey: kHighScoreStoringKey)
    }
}
