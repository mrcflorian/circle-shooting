//
//  LandingGameScene.swift
//  CircleShooting
//
//  Created by Florian Marcu on 10/27/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import SpriteKit

let kTrackRadius: CGFloat = 120.0
let kMonsterRadius: CGFloat = 15.0

class LandingGameScene: SKScene {

    var track: SKShapeNode!
    var monster: SKShapeNode!

    override init() {
        super.init()

        self.backgroundColor = UIColor.clear
        scaleMode = .aspectFit

        track = SKShapeNode(circleOfRadius: kTrackRadius)
        track.strokeColor = UIColor(white: 0.9, alpha: 0.5)
        track.glowWidth = 1.0
        track.lineWidth = 2
        track.fillColor = UIColor.clear
        track.zPosition = 0
        addChild(track)

        monster = SKShapeNode(circleOfRadius: kMonsterRadius)
        monster.fillColor = UIColor.red
        monster.strokeColor = UIColor.red
        monster.zPosition = 10

        addChild(monster!)
    }

    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updatePosition() {
        let sceneElementsOrigin = CGPoint(x: size.width / 2, y: size.height / 2);
        track.position = sceneElementsOrigin

        let circleP = CGMutablePath()
        circleP.addArc(center: sceneElementsOrigin, radius: kTrackRadius,
                       startAngle: 2 * CGFloat(M_PI), endAngle: 0, clockwise: true)
        circleP.closeSubpath();
        let circularMove = SKAction.follow(circleP, asOffset: false, orientToPath: true, duration: 2.0)
        monster.run(SKAction.repeatForever(circularMove))
    }
}
