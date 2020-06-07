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


struct TwineGame {
    var title: String?
    var url: URL
    var html: String?
    var backgroundColor: String?
    
    init( _ url: URL) {
        self.url = url
        if let fileContents = readFile(url){
            self.html = fileContents
            let doc: Document = try! SwiftSoup.parse(fileContents)
            title = try! doc.title()
//            backgroundColor = try! doc.css
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
