//
//  GameListViewController.swift
//  Twine Player
//
//  Created by je09 on 28.05.2020.
//  Copyright © 2020 Petr Grakunov. All rights reserved.
//

import UIKit
import SwiftLog

class GameListViewController: UIViewController {
    @IBOutlet weak var gameListTableView: UITableView!
    
    // List of twine games in Games directory
    var gameList: TwineList?
    let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refresh
    }()
    
    @objc private func refresh(sender: UIRefreshControl){
        gameList = parseFolder()
        gameListTableView.reloadData()
        sender.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameListTableView.dataSource = self
        
        self.createAppDirectory()
        gameList = parseFolder()
        gameListTableView.refreshControl = refreshControl
    }

}

// MARK: - UITableViewDataSource

extension GameListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = gameList!.list[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            do {
                try FileManager.default.removeItem(at: self.gameList!.list[indexPath.row].url)
            } catch let error as NSError {
                logw("Couldn\'t delete file \(error.localizedDescription)")
            }
            tableView.deleteRows(at: [ indexPath ], with: .automatic)
            self.gameList?.list.remove(at: indexPath.row)
            tableView.endUpdates()
        }
    }
}
