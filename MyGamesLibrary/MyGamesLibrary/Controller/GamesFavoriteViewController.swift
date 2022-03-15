//
//  GamesFavoriteViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 28/02/2022.
//

import UIKit
import CoreData

class GamesFavoriteViewController: UIViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var gamesFavoriteTableView: UITableView!
    
    var gamesLibrary: [MyGame]?
    var image: UIImage?
    var platformElements: MyLibraryElements?
    
    private var filteredGames: [MyGame]?
    private var coreDataManager = CoreDataManager(managedObjectContext: CoreDataStack.shared.mainContext)
    private var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
        
        backgroundImage.image = UIImage(named: platformElements?.image ?? "gamesLibrary")
        
        gamesLibrary = platformElements?.myGames
        gamesFavoriteTableView.reloadData()
        gamesFavoriteTableView.reloadData()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        backgroundImage.addGradientLayerInBackground(frame: backgroundImage.bounds, colors: [UIColor(ciColor: .clear), UIColor(ciColor: .white)])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FavoriteCard", let next = segue.destination as? GameCardViewController {
            next.favoriteGame = sender as? MyGame
        }
    }
    
    private func setup() {
        
        backgroundImage.backgroundImage(view: self.view, multiplier: 0.25)
        
        
        gamesFavoriteTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameTableViewCell")
        gamesFavoriteTableView.dataSource = self
        gamesFavoriteTableView.delegate = self
    }
    
    
}
extension GamesFavoriteViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredGames?.count ?? 0
        } else {
            return gamesLibrary?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.sizeWithTheDevice()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "FavoriteCard", sender: filteredGames?[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            coreDataManager.removeGameInArray(row: indexPath.row, array: gamesLibrary ?? [])
            gamesLibrary?.remove(at: indexPath.row)
            gamesFavoriteTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = gamesFavoriteTableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as! GameTableViewCell
        if isSearching {
            guard let dataImage = filteredGames?[indexPath.row].backgroundImage else { return UITableViewCell() }
            cell.gameImage.cacheImage(urlString: String(decoding: dataImage, as: UTF8.self))
            cell.gameTitle.text = filteredGames?[indexPath.row].name ?? "no name"
            cell.gameTitle.textColor = .black
            Tool.shared.setUpShadow(color: UIColor.black.cgColor, cell: cell, width: 0, height: 5)
            return cell
        } else {
            guard let dataImage =  gamesLibrary?[indexPath.row].backgroundImage else { return UITableViewCell() }
            cell.gameImage.cacheImage(urlString: String(decoding: dataImage, as: UTF8.self))
            cell.gameTitle.text = gamesLibrary?[indexPath.row].name ?? "no name"
            cell.gameTitle.textColor = .black
            Tool.shared.setUpShadow(color: UIColor.black.cgColor, cell: cell, width: 0, height: 5)
            return cell
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let games = gamesLibrary else { return }
        if searchText == "" {
            filteredGames = gamesLibrary
            gamesFavoriteTableView.reloadData()
        } else {
            filteredGames = games.filter({ (game : MyGame) -> Bool in
                guard let myGame = game.name else { return false }
                return myGame.lowercased().contains(searchText.lowercased())
            })
            isSearching = true
            gamesFavoriteTableView.reloadData()
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchBar.text?.isEmpty ?? true
    }
    
}

