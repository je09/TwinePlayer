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
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.hidesBarsOnSwipe = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.hidesBarsOnSwipe = true

        setUI()
    }
    
    @IBAction func saveButton(_ sender: Any) {
         saveState()
    }
    
    
    @IBAction func loadButton(_ sender: UIBarButtonItem) {
    }
    
    func setUI() {
        if !FileManager.default.fileExists(atPath: game!.url.path) {
            let alert = UIAlertController(title: "Error", message: "Couldn't open the game. \nFile not found.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
        if let title = game?.title {
            logw("Loading of tbe hame")
            self.webViewBrowser.loadFileURL(game!.url, allowingReadAccessTo: game!.url)
            self.title = title
        } else {
            let alert = UIAlertController(title: "Error", message: "Couldn't open the game", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            logw("No game!")
        }
    }
}

extension GameViewController {
    func saveState() {
        let cookies = HTTPCookieStorage.shared.cookies
        print("\(cookies)")
    }
}
