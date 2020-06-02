//
//  GameViewController.swift
//  Twine Player
//
//  Created by je09 on 02.06.2020.
//  Copyright © 2020 Petr Grakunov. All rights reserved.
//

import UIKit
import WebKit
import SwiftLog

class GameViewController: UIViewController {

    @IBOutlet var webViewBrowser: WKWebView?
    var game: TwineGame!
    var delegate: GameListViewController?
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

protocol GameViewControllerDelegate {
    func selectedGame(_ game: TwineGame)
}

extension GameViewController: GameViewControllerDelegate {
    func selectedGame(_ game: TwineGame) {
        logw("Got \(String(describing: game.url))")
        if let web = webViewBrowser {
            web.loadHTMLString(game.html!, baseURL: nil)
        }
        
    }
}
