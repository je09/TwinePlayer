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

    
    @IBOutlet weak var webViewBrowser: WKWebView!
    var game: TwineGame?
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        if let html = game?.html {
            self.webViewBrowser.loadHTMLString(html, baseURL: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Can't get a game", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            logw("No game!")
        }
    }
}
