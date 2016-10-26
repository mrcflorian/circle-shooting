//
//  LandingViewController.swift
//  LineShoot
//
//  Created by Florian Marcu on 10/11/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import UIKit

let kPlayButtonSize = CGSize(width: 110.0, height: 90.0)
let kHighScoreLabelHeight: CGFloat = 50.0

class LandingViewController: UIViewController
{
    let highScoreManager = HighScoreManager(userDefaults: UserDefaults.standard)

    let playButton = UIButton(type: UIButtonType.system)
    let highScoreLabel = UILabel()

    init() {
        super.init(nibName: nil, bundle: nil)
        playButton.setTitle("Play", for: UIControlState.normal)
        playButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        playButton.backgroundColor = UIColor.red
        playButton.titleLabel?.font = UIFont(name: "Chalkduster", size: 40)
        playButton.layer.cornerRadius = 50
        playButton.addTarget(self, action:#selector(didTapPlayButton), for: .touchUpInside)

        highScoreLabel.textColor = UIColor.red
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateHighScoreTextLabelIfNeeded()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(playButton)
        self.view.addSubview(highScoreLabel)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        playButton.frame = CGRect(x: self.view.bounds.midX - kPlayButtonSize.width / 2, y: self.view.bounds.midY - kPlayButtonSize.height, width: kPlayButtonSize.width, height: kPlayButtonSize.height)

        highScoreLabel.frame = CGRect(x: 0.0, y: 0.0, width: self.view.bounds.width, height: kHighScoreLabelHeight)
    }

    func didTapPlayButton(sender: UIButton) {
        let gameVC = GameViewController(frame: view.frame)
        self.present(gameVC, animated: false, completion: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateHighScoreTextLabelIfNeeded() {
        let score = highScoreManager.currentHighScore()
        if (score > 0) {
            highScoreLabel.text = "Your best score: " + String(Int(score))
        } else {
            highScoreLabel.text = ""
        }
    }
}
