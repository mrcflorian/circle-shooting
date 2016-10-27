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

let kPlayButtonSize = CGSize(width: 110.0, height: 90.0)
let kHighScoreLabelHeight: CGFloat = 50.0
let kSceneViewPadding: CGFloat = 60.0
let kTrackRadius: CGFloat = 90.0

class LandingViewController: UIViewController
{
    let highScoreManager = HighScoreManager(userDefaults: UserDefaults.standard)

    let playButton = UIButton(type: UIButtonType.system)
    let highScoreLabel = UILabel()
    let sceneView = SKView()
    let scene = SKScene()

    var track: SKShapeNode!
    var monster: SKShapeNode!

    init() {
        super.init(nibName: nil, bundle: nil)
        playButton.setTitle("Play", for: UIControlState.normal)
        playButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        playButton.backgroundColor = UIColor.red
        playButton.titleLabel?.font = UIFont(name: "Chalkduster", size: 40)
        playButton.layer.cornerRadius = 50
        playButton.addTarget(self, action:#selector(didTapPlayButton), for: .touchUpInside)

        scene.scaleMode = .aspectFit

        highScoreLabel.textColor = UIColor.red

        sceneView.backgroundColor = UIColor.clear
        scene.backgroundColor = UIColor.clear
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
        drawScene()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        playButton.frame = CGRect(x: self.view.bounds.midX - kPlayButtonSize.width / 2, y: self.view.bounds.midY - kPlayButtonSize.height, width: kPlayButtonSize.width, height: kPlayButtonSize.height)

        highScoreLabel.frame = CGRect(x: 0.0, y: 0.0, width: self.view.bounds.width, height: kHighScoreLabelHeight)
        let playBtnFrame = playButton.frame
        sceneView.frame = CGRect(x: playBtnFrame.minX - kSceneViewPadding, y: playBtnFrame.minY - kSceneViewPadding, width: playBtnFrame.width + 2 * kSceneViewPadding, height: playBtnFrame.height + 2 * kSceneViewPadding)
        scene.size = sceneView.frame.size

        let sceneElementsOrigin = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2);
        track.position = sceneElementsOrigin


        let circleP = CGMutablePath()
        circleP.addArc(center: sceneElementsOrigin, radius: kTrackRadius,
                       startAngle: 2 * CGFloat(M_PI), endAngle: 0, clockwise: true)
        circleP.closeSubpath();
        let circularMove = SKAction.follow(circleP, asOffset: false, orientToPath: true, duration: 2.0)
        monster.run(SKAction.repeatForever(circularMove))
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

    private func drawScene() {
        track = SKShapeNode(circleOfRadius: kTrackRadius)
        track.strokeColor = UIColor.white
        track.glowWidth = 1.0
        track.lineWidth = 2
        track.fillColor = UIColor.clear
        track.zPosition = 0
        scene.addChild(track)

        monster = SKShapeNode(circleOfRadius: 15)
        monster.fillColor = UIColor.red
        monster.strokeColor = UIColor.red
        monster.zPosition = 10

        scene.addChild(monster!)

        sceneView.presentScene(scene)
    }
}
