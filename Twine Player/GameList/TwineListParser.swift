//
//  TwineListParser.swift
//  Twine Player
//
//  Created by je09 on 28.05.2020.
//  Copyright © 2020 Petr Grakunov. All rights reserved.
//

import Foundation
import SwiftSoup


// Codable – may be converted onto date object
struct TwineGame: Codable {
    var title: String?
    var url: URL
//    var engine: String?
    var color: String?
    var isTwine: Bool!
    
    init( _ url: URL) {
        self.url = url
        if let fileContents = readFile(url){
            let doc: Document = try! SwiftSoup.parse(fileContents)
            let twineData = try! doc.select("tw-storydata")
            let data = doc.data()
            
            self.title = try? twineData.attr("name")
            if self.title == "" {
                self.title = try? doc.title()
            }
            
//            self.engine = try! twineData.attr("format")
            self.color = getBgColor(data)
            self.isTwine = fileContents.contains("twine")
        }
    }
    
    private func getBgColor(_ css: String) -> String {
        if css.contains("background-color:black"){
            return "black"
        } else {
            return "white"
        }
    }
    
    private func readFile(_ url: URL) -> String? {
        var contents:String?
        NSLog("Trying to read file \(url.path)")
        
        if url.pathExtension == "html" {
            do {
                contents = try String(contentsOf: url, encoding: .utf8)
            } catch let error as NSError {
                NSLog(error.localizedDescription)
            }
        }
        
        return contents
    }
}

struct TwineList {
    var list:[TwineGame] = []
    var count: Int {
        get {
            return list.count
        }
    }
    
    mutating func append(_ game: TwineGame) {
        if game.title != nil {
            list.append(game)
        }
    }
}
