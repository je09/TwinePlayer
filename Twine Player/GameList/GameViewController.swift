//
//  GameViewController.swift
//  Twine Player
//
//  Created by je09 on 02.06.2020.
//  Copyright © 2020 Petr Grakunov. All rights reserved.
//

import UIKit
import WebKit

class GameViewController: UIViewController {

    
    @IBOutlet weak var webViewBrowser: WKWebView!
    var game: TwineGame?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.hidesBarsOnSwipe = true

        setUI()
        setBrowser()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.hidesBarsOnSwipe = false
    }
    
    
    func setUI() {
        if !FileManager.default.fileExists(atPath: game!.url.path) {
            self.alert(title: "Error", description: "Couldn't open the game. \nFile not found.")
        }
        
        if let title = game?.title {
            NSLog("Loading of tbe hame")
            self.webViewBrowser.loadFileURL(game!.url, allowingReadAccessTo: game!.url)
            self.title = title
        } else {
            self.alert(title: "Error", description: "Couldn't open the game")
            NSLog("No game!")
        }
    }
    
    func setBrowser() {
        NSLog("BG color: \(String(describing: game?.color!))")
        if game?.color! == "black" {
            self.webViewBrowser.backgroundColor = .black
        } else {
            self.webViewBrowser.backgroundColor = .white
        }
        self.webViewBrowser.scrollView.backgroundColor = .black
    }
}

// Save and Load Functions

//extension GameViewController {
//    func saveState(autoSave auto: Bool) {
//        NSLog("Trying to save")
//        var saveName = "save_"
//        if auto {
//            saveName = "autosave_"
//        }
//        saveName += "\(String(describing: self.game!.title))"
//        let js = "sessionStorage.getItem(\"Saved Session\")"
//
//        self.webViewBrowser.evaluateJavaScript(js) { (result, error) in
//            if error == nil {
//                if result as! String != "" && !auto {
//                    self.alert(title: "Save", description: "Saved successfully")
//                    NSLog("Saved successfully")
//                    UserDefaults.standard.set(result, forKey: saveName)
//                }
//
//            }
//        }
//    }
//
//    func loadState(autoLoad auto: Bool) {
//        NSLog("Trying to load")
//        var loadName = "save_"
//        if auto {
//            loadName = "autosave_"
//        }
//        loadName += "\(String(describing: self.game!.title))"
//        let result = UserDefaults.standard.string(forKey: loadName)
//
//        if result != "" {
//            let js = "sessionStorage.setItem(\"Saved Session\", \(result!))"
//            print(js)
//            self.webViewBrowser.evaluateJavaScript(js) { (result, error) in
//                if error == nil && !auto {
//                    self.alert(title: "Load", description: "Loaded successfully")
//                    NSLog("Loaded successfully")
//                    self.webViewBrowser.reloadInputViews()
//
//                } else {
//                    NSLog("\(error?.localizedDescription)")
//                }
//            }
//        }
//
//    }
//}

// MARK: - Alert
extension GameViewController {
    func alert(title: String, description: String) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
