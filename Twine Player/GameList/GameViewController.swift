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
        saveState(autoSave: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.hidesBarsOnSwipe = true

        setUI()
    }
    
    @IBAction func saveButton(_ sender: Any) {
         saveState(autoSave: false)
    }
    
    @IBAction func loadButton(_ sender: Any) {
//        loadState(autoLoad: false)
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
    func saveState(autoSave auto: Bool) {
        logw("Trying to save")
        let filepath = Bundle.main.path(forResource: "getHtml", ofType: "js")
        
        var saveName = "save_"
        if auto {
            saveName = "autosave_"
        }
        saveName += "\(String(describing: self.game!.title))"
        
        do {
            let js = try String(contentsOfFile: filepath!)
            self.webViewBrowser.evaluateJavaScript(js, completionHandler: {(html: Any?, error: Error?) in UserDefaults.standard.set(html, forKey: saveName)})
            logw("Saved")
        } catch {
            logw("Couldn't load getHtml.js")
        }
    }
    
    func loadState(autoLoad auto: Bool) {
        logw("Trying to load")
        let filepath = Bundle.main.path(forResource: "injectHtml", ofType: "js")
        
        var loadName = "save_"
               if auto {
                   loadName = "autosave_"
               }
        loadName += "\(String(describing: self.game!.title))"
        
        do {
            let js = try String(contentsOfFile: filepath!)
            self.webViewBrowser.loadHTMLString(UserDefaults.standard.object(forKey: loadName) as! String, baseURL: self.game!.url)
            logw("Loaded \(UserDefaults.standard.object(forKey: loadName) as! String)")
        } catch {
            logw("Couldn't load getHtml.js")
        }
    }
}
