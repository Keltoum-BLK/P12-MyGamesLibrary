//
//  GamesFavoriteViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 28/02/2022.
//

import UIKit

class GamesFavoriteViewController: UIViewController {


    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var gamesFavoriteTableView: UITableView!
    
    var gamesLibrary: [MyGame]?
    var image: UIImage?
    var platformElements: MyLibraryElements?
    private var filteredGames: [MyGame]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        searchBar.delegate = self
        backgroundImage.image = UIImage(named: platformElements?.image ?? "gamesLibrary")
        gamesLibrary = platformElements?.myGames
        gamesFavoriteTableView.reloadData()
        dump(gamesLibrary)
        gamesFavoriteTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        backgroundImage.addGradientLayerInBackground(frame: backgroundImage.bounds, colors: [UIColor(ciColor: .clear), UIColor(ciColor: .white)])
    }
    
    private func setup() {
    
        backgroundImage.backgroundImage(view: self.view, multiplier: 0.35)
        

        gamesFavoriteTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameTableViewCell")
        gamesFavoriteTableView.dataSource = self
        gamesFavoriteTableView.delegate = self
    }
    
    
}
extension GamesFavoriteViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = gamesLibrary?.count else { return 1}
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.sizeWithTheDevice()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = gamesFavoriteTableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as! GameTableViewCell
        guard let dataImage =  gamesLibrary?[indexPath.row].backgroundImage else { return UITableViewCell() }
        cell.gameImage.cacheImage(urlString: String(decoding: dataImage, as: UTF8.self))
        cell.gameTitle.text = gamesLibrary?[indexPath.row].name ?? "no name"
        cell.gameTitle.textColor = .black
        Tool.shared.setUpShadowTableCell(color: UIColor.black.cgColor, cell: cell)
        return cell
    }
}

