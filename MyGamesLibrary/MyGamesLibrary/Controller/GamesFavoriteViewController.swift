//
//  GamesFavoriteViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 28/02/2022.
//

import UIKit
import CoreData

class GamesFavoriteViewController: UIViewController {
    
   //MARK: UI Properties
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var backBTN: UIButton!
    @IBOutlet weak var gamesFavoriteTableView: UITableView!
    
    //MARK: Properties
    private var gamesLibrary: [MyGame]? {
        didSet {
            DispatchQueue.main.async {
                self.gamesFavoriteTableView.reloadData()
            }
        }
    }
    private var image: UIImage?
    var platformElements: MyLibraryElements?
    private var filteredGames: [MyGame]?
    private var coreDataManager = CoreDataManager(managedObjectContext: CoreDataStack.shared.mainContext)
    private var isSearching = false
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            self.gamesFavoriteTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        backgroundImage.addGradientLayerInBackground(frame: backgroundImage.bounds, colors: [UIColor(ciColor: .clear), UIColor(ciColor: .white)])
    }
    
    //MARK: Segue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MyGameCard", let next = segue.destination as? MyGameViewController {
            next.myGame = sender as? MyGame
        }
    }
    
    //MARK: Methods
    private func setUp() {
        searchBar.delegate = self
        notificationSetUp()
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.bottomAnchor.constraint(equalTo: backgroundImage.bottomAnchor).isActive = true
        
        backgroundImage.image = UIImage(named: platformElements?.image ?? "gamesLibrary")
        
        gamesLibrary = platformElements?.myGames
        
        backBTN.layer.cornerRadius = 5
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.font = UIFont(name: "Menlo", size: 15)
        backgroundImage.backgroundImage(view: self.view, multiplier: 0.25)
        
        gamesFavoriteTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameTableViewCell")
        gamesFavoriteTableView.dataSource = self
        gamesFavoriteTableView.delegate = self
        
        backBTN.layer.cornerRadius = 10
        Tool.shared.setUpShadow(color: UIColor.black.cgColor, cell: backBTN, width: 3, height: 3)
    }
    
    
    private func notificationSetUp() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(needReloadTableview), name: Notification.Name(rawValue: "needReload"), object: nil)
    }
    
    @objc func needReloadTableview() {
        gamesLibrary = coreDataManager.fetchGames(mygames: gamesLibrary!)
    }
    
    
    //MARK: UI Action Method
    @IBAction func dismissBTN(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension GamesFavoriteViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //MARK: TableView Methods
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
        if isSearching {
            performSegue(withIdentifier: "MyGameCard", sender: filteredGames?[indexPath.row])
        } else {
            performSegue(withIdentifier: "MyGameCard", sender: gamesLibrary?[indexPath.row])
        }
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
        cell.selectionStyle = .none
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
    //MARK: searchBar Methods
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}

