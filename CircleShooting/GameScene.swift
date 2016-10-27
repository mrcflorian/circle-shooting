//
//  GameScene.swift
//  CircleShooting
//
//  Created by Florian Marcu on 9/25/16.
//  Copyright (c) 2016 Florian Marcu. All rights reserved.
//

import SpriteKit

let kBigCircleRadius: CGFloat = 100.0
let kProjectileRadius: CGFloat = 5.0
let kProjectileLauncherRadius: CGFloat = 5.0
let kProjectileSpeedDuration: TimeInterval = 1.0

// Colors
let kProjectileColor: UIColor = UIColor(white: 0.9, alpha: 0.5)
let kProjectileLauncherColor: UIColor = UIColor(white: 0.9, alpha: 0.5)
let kMonsterColor: UIColor = UIColor.red
let kTrackColor: UIColor = UIColor(white: 0.9, alpha: 0.5)

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Monster   : UInt32 = 0b1
    static let Projectile: UInt32 = 0b10
}

class GameScene: SKScene {

    weak var viewController: GameViewController?
    var track: SKShapeNode?
    var monster: SKShapeNode?
    var gun: SKShapeNode?
    var projectile: SKShapeNode?

    var startAngleInDegrees = 0.0
    var endAngleInDegrees = 90.0

    var gameController: GameController?
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }

    override init(size: CGSize) {
        super.init(size: size)

        gameController = GameController()
        drawTrack()
        drawProjectileLauncher()
        drawMonster()
    }

    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
    }

    override func update(_ currentTime: TimeInterval) {
        if (projectileMiss()) {
            viewController?.gameOver()
        }
    }

    func drawTrack() {
        track = SKShapeNode(circleOfRadius: kBigCircleRadius )
        track?.position = midScreenPoint()
        track?.strokeColor = kTrackColor
        track?.glowWidth = 1.0
        track?.lineWidth = 2
        track?.fillColor = UIColor.clear
        track?.zPosition = 0
        self.addChild(track!)
    }

    func drawMonster() {
        monster = SKShapeNode(circleOfRadius: gameController!.monsterRadius())
        monster?.fillColor = kMonsterColor
        monster?.strokeColor = kMonsterColor
        monster?.position = CGPoint(x: frame.midX + kBigCircleRadius, y:frame.midY)
        monster?.zPosition = 10

        let circleP = CGMutablePath();
        circleP.addArc(center: CGPoint(x: frame.midX, y: frame.midY), radius: kBigCircleRadius,
                    startAngle: 2 * CGFloat(M_PI), endAngle: 0, clockwise: true)
        circleP.closeSubpath();

        let circularMove = SKAction.follow(circleP, asOffset: false, orientToPath: true, duration: gameController!.monsterCycleDuration())

        monster?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: gameController!.monsterRadius(), height: gameController!.monsterRadius()))
        monster?.physicsBody?.isDynamic = true
        monster?.physicsBody?.categoryBitMask = PhysicsCategory.Monster
        monster?.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        monster?.physicsBody?.collisionBitMask = PhysicsCategory.None
        monster?.physicsBody?.usesPreciseCollisionDetection = true

        monster?.run(SKAction.repeatForever(circularMove))
        self.addChild(monster!)
    }

    func drawProjectileLauncher() {
        gun =  SKShapeNode(circleOfRadius: kProjectileLauncherRadius)
        gun?.fillColor = kProjectileLauncherColor
        gun?.strokeColor = kProjectileLauncherColor
        gun?.position = CGPoint(x:frame.midX, y:frame.midY)
        self.addChild(gun!)
    }

    func launchProjectileIfPossible() {
        if (projectile != nil) {
            return
        }
        projectile = SKShapeNode(circleOfRadius: kProjectileRadius)
        projectile?.position = midScreenPoint()
        projectile?.fillColor = kProjectileColor
        projectile?.strokeColor = kProjectileColor

        projectile?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: kProjectileRadius, height: kProjectileRadius))
        projectile?.physicsBody?.isDynamic = true
        projectile?.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        projectile?.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        projectile?.physicsBody?.collisionBitMask = PhysicsCategory.None
        projectile?.physicsBody?.usesPreciseCollisionDetection = true

        let moveUpAction = SKAction.moveBy(x: 0, y: frame.size.height / 2 + 15, duration: kProjectileSpeedDuration)
        projectile?.run(moveUpAction)
        self.insertChild(projectile!, at: 0)
    }

    private func projectileMiss() -> Bool {
        guard let projectile = projectile, let gameController = gameController, let track = track else {
            return false
        }
        return projectile.position.y > track.position.y + kBigCircleRadius + gameController.monsterRadius() + 10.0
    }

    private func midScreenPoint() -> CGPoint {
        return CGPoint(x: frame.midX, y: frame.midY)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }

        if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
            projectileDidCollideWithMonster(projectile: firstBody.node as! SKShapeNode, monster: secondBody.node as! SKShapeNode)
        }
    }

    private func projectileDidCollideWithMonster(projectile: SKShapeNode, monster: SKShapeNode) {
        projectile.removeFromParent()
        monster.removeFromParent()
        self.projectile = nil
        gameController!.increaseLevel()
        viewController?.update(score: gameController!.getScore())
        drawMonster()
    }
}
