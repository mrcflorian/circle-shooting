//
//  GameOverViewController.swift
//  LineShoot
//
//  Created by Florian Marcu on 10/10/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {

    var gameController: GameController?
    init(gameController: GameController?) {
        super.init(nibName: nil, bundle: nil)
        self.gameController = gameController
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
