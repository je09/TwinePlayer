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
        
        welcomeMessage()
        
        gameListTableView.dataSource = self
        gameListTableView.delegate = self
        
        self.createAppDirectory()
        gameList = parseFolder()
        gameListTableView.refreshControl = refreshControl
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ListToShow" {
            let gameVC = segue.destination as! GameViewController
            gameVC.game = sender as? TwineGame
        }
    }

}

// MARK: - First run function

extension GameListViewController {
    func welcomeMessage() {
        let firstTime = UserDefaults.standard.bool(forKey: "firstTime")
        if !firstTime{
            let message = "Hello and welcome to the Twine Player. I hope, you would find this "
                        + "application useful. \nHowever, I wan't to point, that save and load "
                        + "functionality may not work in some Twine stories. It caused because "
                        + "of different engines used by developers. I wasn't able to find a "
                        + "universal way to implement this functions, but I'm trying to develop it. "
                        + "Even when you sleep. \nHave fun and read good stories."
            
            let alert = UIAlertController(title: "Welcome", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            UserDefaults.standard.set(true, forKey: "firstTime")
        }
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


// MARK: - UITableViewDelegate

extension GameListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        logw("Selected on row \(indexPath.row)")
        if let game = self.gameList?.list[indexPath.row] {
            logw("Game url: \(game.url)")
            
            performSegue(withIdentifier: "ListToShow", sender: game)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
