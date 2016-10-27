//
//  LandingViewController.swift
//  LineShoot
//
//  Created by Florian Marcu on 10/11/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import UIKit
import SpriteKit
import GameAnalytics
import Crashlytics

let kPlayButtonSize = CGSize(width: 60.0, height: 60.0)
let kPlayButtonCornerRadius: CGFloat = 30
let kPlayButtonFontFamily = "MarkerFelt-Wide"
let kPlayButtonFontSize: CGFloat = 30

let kHighScoreLabelHeight: CGFloat = 50.0
let kSceneViewPadding: CGFloat = 80.0

class LandingViewController: UIViewController
{
    let highScoreManager = HighScoreManager(userDefaults: UserDefaults.standard)

    let playButton = UIButton(type: UIButtonType.system)
    let highScoreLabel = UILabel()
    let sceneView = SKView()

    let scene = LandingGameScene()

    init() {
        super.init(nibName: nil, bundle: nil)
        playButton.setTitle("Go!", for: UIControlState.normal)
        playButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        playButton.backgroundColor = UIColor.red
        playButton.titleLabel?.font = UIFont(name: kPlayButtonFontFamily, size: kPlayButtonFontSize)
        playButton.layer.cornerRadius = kPlayButtonCornerRadius
        playButton.addTarget(self, action:#selector(didTapPlayButton), for: .touchUpInside)

        self.playButton.layer.shadowColor = UIColor(colorLiteralRed: 100.0/255.0, green: 0, blue: 0, alpha: 1).cgColor
        self.playButton.layer.shadowOpacity = 1.0
        self.playButton.layer.shadowRadius = 1.0
        self.playButton.layer.shadowOffset = CGSize(width: 0, height: 3)

        highScoreLabel.textColor = UIColor.red

        sceneView.backgroundColor = UIColor.clear
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateHighScoreTextLabelIfNeeded()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(playButton)
        self.view.addSubview(highScoreLabel)
        self.view.insertSubview(sceneView, belowSubview: playButton)
        sceneView.presentScene(scene)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        playButton.frame = CGRect(x: self.view.bounds.midX - kPlayButtonSize.width / 2, y: self.view.bounds.midY - kPlayButtonSize.height, width: kPlayButtonSize.width, height: kPlayButtonSize.height)

        highScoreLabel.frame = CGRect(x: 0.0, y: 0.0, width: self.view.bounds.width, height: kHighScoreLabelHeight)
        let playBtnFrame = playButton.frame
        sceneView.frame = CGRect(x: playBtnFrame.minX - kSceneViewPadding, y: playBtnFrame.minY - kSceneViewPadding, width: playBtnFrame.width + 2 * kSceneViewPadding, height: playBtnFrame.height + 2 * kSceneViewPadding)
        scene.size = sceneView.frame.size
        scene.updatePosition()
    }

    func didTapPlayButton(sender: UIButton) {
        let gameVC = GameViewController(frame: view.frame)

        GameAnalytics.addProgressionEvent(with: GAProgressionStatusStart, progression01:"game", progression02:"landing", progression03:"play-button")

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
