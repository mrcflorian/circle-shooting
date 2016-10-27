//
//  GameViewController.swift
//  LineShoot
//
//  Created by Florian Marcu on 9/25/16.
//  Copyright (c) 2016 Florian Marcu. All rights reserved.
//

import UIKit
import SpriteKit

private let kScoreViewDimension: CGFloat = 50.0;
private let kScoreViewPadding: CGFloat = 20.0;

class GameViewController: UIViewController {

    var scene: GameScene?
    var frame: CGRect
    var scoreView: UILabel?

    init(frame: CGRect) {
        self.frame = frame
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let scoreFrame = CGRect(x:kScoreViewPadding, y:kScoreViewPadding, width:kScoreViewDimension, height:kScoreViewDimension)
        scoreView = UILabel(frame: scoreFrame)
        scoreView?.backgroundColor = UIColor.clear
        scoreView?.textColor = UIColor.red
        scoreView?.font = UIFont(name: "Chalkduster", size: 20)
        self.view.addSubview(scoreView!);

        // Configure the game view.
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.backgroundColor = UIColor.clear
        self.startGame()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        scene?.launchProjectileIfPossible()
    }

    override func loadView() {
        self.view = SKView(frame: frame)
        self.view.backgroundColor = UIColor.black
    }

    func startGame() {
        // Create and configure the scene.
        let skView = view as! SKView
        scene = GameScene(size: skView.bounds.size)
        scene?.scaleMode = .aspectFit
        scene?.backgroundColor = UIColor.black
        scene?.viewController = self

        // Present the scene.
        skView.presentScene(scene)
    }

    func gameOver() {
        //let gameOverVC = GameOverViewController(gameController: scene?.gameController)
        //self.presentingViewController?.present(gameOverVC, animated: false, completion:nil)
        self.dismiss(animated: false, completion: nil)
    }

    func update(score: String) {
        scoreView?.text = score
    }
}
