//
//  GamesFavoriteViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 28/02/2022.
//

import UIKit

class GamesFavoriteViewController: UIViewController {

    @IBOutlet weak var searchBarContainer: UIStackView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchBTN: UIButton!
    @IBOutlet weak var gamesFavoriteTableView: UITableView!
    
    lazy var gamesLibrary = [MyGame]()
    var image: UIImage?
    var platformElements: MyLibraryElements?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageStr = gamesLibrary.first?.backgroundImage?.base64EncodedString() ?? "no image"
        print(imageStr)
        setup()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        backgroundImage.addGradientLayerInBackground(frame: backgroundImage.bounds, colors: [UIColor(ciColor: .clear), UIColor(ciColor: .white)])
    }
    
    private func setup() {
        guard let imageStr = platformElements?.image else { return }
        DispatchQueue.main.async {
            self.backgroundImage.image = UIImage(contentsOfFile: imageStr)
        }
        backgroundImage.backgroundImage(view: self.view, multiplier: 0.35)
        guard let games = platformElements?.myGames else { return }
        gamesLibrary = games
        searchBarContainer.layer.cornerRadius = 20
        Tool.shared.setUpShadowView(color: UIColor.black.cgColor, view: searchBarContainer)
        
        searchTextField.changeThePLaceholderFont(text: "Quel jeu recherchez-vous?", textField: searchTextField.self)
        searchBTN.layer.cornerRadius = 10
        
        gamesFavoriteTableView.tableViewConstraints(view: self.view, constant: 200)
        gamesFavoriteTableView.register(GameTableViewCell.self, forCellReuseIdentifier: "GameTableViewCell")
        gamesFavoriteTableView.dataSource = self
        gamesFavoriteTableView.delegate = self
    }
}
extension GamesFavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesLibrary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = gamesFavoriteTableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as! GameTableViewCell
        cell.gameTitle.text = gamesLibrary[indexPath.row].name
       
//        cell.gameImage.cacheImage(urlString: imageStr)
       
        return cell 
    }
}
