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
    
    lazy var playstationFavorite = [Game]()
    lazy var xboxFavorite = [Game]()
    lazy var nintendoFavorite = [Game]()
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setup()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        backgroundImage.addGradientLayerInBackground(frame: backgroundImage.bounds, colors: [UIColor(ciColor: .clear), UIColor(ciColor: .white)])
    }
    
    private func setup() {
        DispatchQueue.main.async {
            self.backgroundImage.image = self.image
        }
        backgroundImage.backgroundImage(view: self.view, multiplier: 0.35)
     
       
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
        return playstationFavorite.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = gamesFavoriteTableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as! GameTableViewCell
        return cell 
    }
}
