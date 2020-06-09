//
//  GameViewcontrollerExtenction.swift
//  Twine Player
//
//  Created by je09 on 30.05.2020.
//  Copyright © 2020 Petr Grakunov. All rights reserved.
//

import Foundation
import SwiftLog


extension GameListViewController{
    private func returnAppDir() -> URL {
        let directoryName = "Games"
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let gamesDirectory = path!.appendingPathComponent(directoryName)
        
        logw(String(format: "Dir path \(gamesDirectory.path)"))
        
        return gamesDirectory
    }
    
    func createAppDirectory() {
        let appUrl = returnAppDir()
        
        if !FileManager.default.fileExists(atPath: appUrl.path) {
            logw("Trying to create a folder")
            do {
                try FileManager.default.createDirectory(atPath: appUrl.path, withIntermediateDirectories: true, attributes: nil)
                logw("Created")
            } catch let error as NSError {
                logw(error.localizedDescription)
            }
        } else {
            logw("Folder exists")
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
                    logw("Checking \"\(item)\"")
                    let path = appUrl.appendingPathComponent(item)
                    logw("Calling for \"\(path.path)\"")
                    
                    var game: TwineGame?
                    
                    if gameDecodedList[path] == nil {
                        logw("Wasn't synced")
                        game = TwineGame(path)
                    } else if gameDecodedList != nil {
                        logw("Was synced")
                        game = gameDecodedList[path]
                    }
                    
                    newGameList.append(try! JSONEncoder().encode(game))
                    list.append(game!)
                }
            } catch let error as NSError {
                logw(error.localizedDescription)
            }
        }
        
        UserDefaults.standard.set(newGameList, forKey: "gameList")
        
        logw("\(list.count) elements")
        
        return list
    }
}
