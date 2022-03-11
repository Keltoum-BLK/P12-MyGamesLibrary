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
    
    var gamesLibrary: [MyGame]?
    var image: UIImage?
    var platformElements: MyLibraryElements?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        backgroundImage.image = UIImage(named: platformElements?.image ?? "gamesLibrary")
        gamesLibrary = platformElements?.myGames
        gamesFavoriteTableView.reloadData()
        dump(gamesLibrary)
       
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
        
        searchBarContainer.layer.cornerRadius = 20
        Tool.shared.setUpShadowView(color: UIColor.black.cgColor, view: searchBarContainer)
        
        searchTextField.changeThePLaceholderFont(text: "Quel jeu recherchez-vous?", textField: searchTextField.self)
        searchTextField.delegate = self 
        searchBTN.layer.cornerRadius = 10
        
        gamesFavoriteTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameTableViewCell")
        gamesFavoriteTableView.dataSource = self
        gamesFavoriteTableView.delegate = self
    }
    
    
    @IBAction func searchingBTN(_ sender: Any) {
        
    }
    
}
extension GamesFavoriteViewController: UITableViewDelegate, UITableViewDataSource {
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
extension GamesFavoriteViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
}
