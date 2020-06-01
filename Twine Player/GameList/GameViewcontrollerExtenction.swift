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
    
    func parseFolder() -> TwineList {
        let appUrl = returnAppDir()
        var list: TwineList = TwineList()
        
        if FileManager.default.fileExists(atPath: appUrl.path) {
            do {
                let items = try FileManager.default.contentsOfDirectory(atPath: appUrl.path)
                for item in items {
                    logw("Checking \"\(item)\"")
                    let path = appUrl.appendingPathComponent(item)
                    logw("Calling for \"\(path.path)\"")
                    list.append(TwineGame(path))
                }
            } catch let error as NSError {
                logw(error.localizedDescription)
            }
        }
        logw("\(list.count) elements")
        
        return list
    }
}
