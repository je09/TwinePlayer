//
//  TwineListParser.swift
//  Twine Player
//
//  Created by je09 on 28.05.2020.
//  Copyright © 2020 Petr Grakunov. All rights reserved.
//

import Foundation
import SwiftSoup
import SwiftLog

// Codable – may be converted onto date object
struct TwineGame: Codable {
    var title: String?
    var url: URL
    var engine: String?
    
    init( _ url: URL) {
        self.url = url
        if let fileContents = readFile(url){
            let doc: Document = try! SwiftSoup.parse(fileContents)
            let twineData = try! doc.select("tw-storydata")
            
            self.title = try! twineData.attr("name")
            self.engine = try! twineData.attr("format")
        }
    }
    
    private func readFile(_ url: URL) -> String? {
        var contents:String?
        logw("Trying to read file \(url.path)")
        
        if url.pathExtension == "html" {
            do {
                contents = try String(contentsOf: url, encoding: .utf8)
            } catch let error as NSError {
                logw(error.localizedDescription)
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
