//
//  GameViewcontrollerExtenction.swift
//  Twine Player
//
//  Created by je09 on 30.05.2020.
//  Copyright © 2020 Petr Grakunov. All rights reserved.
//

import UIKit

// Parsing functionality
extension GameListViewController{
    private func returnAppDir() -> URL {
        let directoryName = "Games"
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let gamesDirectory = path!.appendingPathComponent(directoryName)
        
        NSLog(String(format: "Dir path \(gamesDirectory.path)"))
        
        return gamesDirectory
    }
    
    func createAppDirectory() {
        let appUrl = returnAppDir()
        
        if !FileManager.default.fileExists(atPath: appUrl.path) {
            NSLog("Trying to create a folder")
            do {
                try FileManager.default.createDirectory(atPath: appUrl.path, withIntermediateDirectories: true, attributes: nil)
                NSLog("Created")
            } catch let error as NSError {
                NSLog(error.localizedDescription)
            }
        } else {
            NSLog("Folder exists")
        }
    }
    
    func parseUserArray(_ userArray: [Data]?) -> [URL:TwineGame] {
        var result = [URL: TwineGame]()
        
        if userArray != nil {
            for item in userArray! {
                if let decoded = try? JSONDecoder().decode(TwineGame.self, from: item) {
                    result[decoded.url] = decoded
                }
            }
        }
        
        return result
    }
    
    func parseFolder() -> TwineList {
        let appUrl = returnAppDir()
        var list: TwineList = TwineList()
        
        let gameList: [Data]? = UserDefaults.standard.array(forKey: "gameList") as? [Data]
        let gameDecodedList = parseUserArray(gameList)
        
        var newGameList = [Data]()
        
        if FileManager.default.fileExists(atPath: appUrl.path) {
            do {
                let items = try FileManager.default.contentsOfDirectory(atPath: appUrl.path)
                for item in items {
                    NSLog("Checking \"\(item)\"")
                    let path = appUrl.appendingPathComponent(item)
                    NSLog("Calling for \"\(path.path)\"")
                    
                    var game: TwineGame?
                    
                    if gameDecodedList[path] == nil {
                        NSLog("Wasn't synced")
                        game = TwineGame(path)
                    } else {
                        NSLog("Was synced")
                        game = gameDecodedList[path]
                    }
                    
                    if game?.isTwine as! Bool {
                        newGameList.append(try! JSONEncoder().encode(game))
                        list.append(game!)
                    }
                }
            } catch let error as NSError {
                NSLog(error.localizedDescription)
            }
        }
        
        UserDefaults.standard.set(newGameList, forKey: "gameList")
        
        NSLog("\(list.count) elements")
        
        return list
    }
    
    func importData(_ url: URL?) {
        NSLog("Trying to import data")
        var newPathUrl = returnAppDir()
        guard url != nil else {return}
        let fileName = url!.lastPathComponent
        
        newPathUrl.appendPathComponent(fileName, isDirectory: false)
        NSLog("Copy new file to \(newPathUrl)")
        
        do {
            try FileManager.default.copyItem(at: url!, to: newPathUrl)
        } catch let error as NSError {
            NSLog("Unable to copy item, \(error.localizedDescription) occured")
            alert(title: "Error occured", description: error.localizedDescription)
        }
        self.gameList = parseFolder()
        
    }
}

// MARK: - Alert
extension GameListViewController {
    func alert(title: String, description: String) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
