//
//  ScannerViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 11/02/2022.
//

import UIKit
import AVFoundation

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchContainer: UIStackView!
    @IBOutlet weak var scanTitle: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var scanBTN: UIButton!
    @IBOutlet weak var searchBTN: UIButton!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var addGameStack: UIStackView!
    @IBOutlet weak var addGameBTN: UIButton!
    @IBOutlet weak var addLogo: UIImageView!
    @IBOutlet weak var hideTabView: UIButton!
    
    var searchGames: [Game]? {
        didSet {
            searchTableView.reloadData()
        }
    }
    
    var nextPage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTextField.delegate = self
        setUpUI()
        setUpTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchTableView.reloadData()
    }

    func setUpUI() {
        self.setupNavigationBack()
        view.backgroundColor = UIColor.white
        searchBTN.backgroundColor = .white
        searchBTN.layer.cornerRadius = searchBTN.frame.height / 2
        
        scanBTN.backgroundColor = .white
        scanBTN.layer.cornerRadius = scanBTN.frame.height / 2
        
        searchContainer.layer.cornerRadius = 20
        
        scanTitle.layer.masksToBounds = true
        scanTitle.layer.cornerRadius = 20
        
        searchTextField.changeThePLaceholderFont(text: "Quel jeu cherches-tu?", textField: searchTextField)
        
        addGameStack.addGameStackConstraints(view: self.view)
        addGameStack.layer.cornerRadius = 20
        addLogo.image = UIImage(named: "icons8-game-controller-30")
        addGameBTN.widthAnchor.constraint(equalToConstant: 150).isActive = true
        addGameBTN.layer.cornerRadius = addGameBTN.frame.height / 2
        Tool.shared.setUpShadowView(color: UIColor.black.cgColor, view: addGameBTN)
        
        searchTableView.isHidden = true
        
        hideTabView.layer.cornerRadius = hideTabView.frame.height / 2
    }
    
    private  func setUpTableView() {
        searchTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameTableViewCell")
        searchTableView.tableViewConstraints(view: self.view, constant: 160)
    }
    //fetch Data to launch the search
    private func fetchDataGames () {
        guard let title = searchTextField.text else { return }
        if title != ""{
            GameService.shared.fetchSearchGames(search: title) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let games):
                    self.searchGames = games.results
                    self.nextPage = games.next ?? "no next"
                    self.searchTextField.text = ""
                case .failure(let error):
                    print(error.description)
                    self.showAlertMessage(title: "Erreur détectée ⛔️", message: "Nous n'avons pas trouvé le jeu que vous cherchez, essaye un autre nom 👾, \n \(error.description)")
                }
            }
        } else {
            self.showAlertMessage(title: "Erreur détectée ⛔️", message: "Vous ne pouvez pas faire requête avec un champ vide 👾.")
        }
    }
    
    //search video games
    @IBAction func getGames(_ sender: Any) {
        searchTextField.resignFirstResponder()
        addGameStack.isHidden = true
        searchTableView.isHidden = false
        fetchDataGames()
    }

 
    //load the next page of games data
    private func loadMoreData() {
        GameService.shared.getDataFromUrl(next: nextPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let games):
                self.searchGames?.append(contentsOf: games.results ?? [])
                self.nextPage = games.next ?? "no next page"
            case .failure(let error):
                self.showAlertMessage(title: "Erreur détectée ⛔️", message: "Vous avez vu tout les jeux disponibles, \(error.description)")
            }
        }
    }
    
    @IBAction func getGamesbyBarcode(_ sender: Any) {
       let myscanVC = MyScanViewController()
        let nav = UINavigationController(rootViewController: myscanVC)
        
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        present(nav, animated: true)
    }
    
    //send data to the next Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchGameCard", let next = segue.destination as? GameCardViewController {
            next.game = sender as? Game
        }
    }
    
    @IBAction func hideTabViewAction(_ sender: Any) {
        searchTableView.isHidden = true
        addGameStack.isHidden = false 
    }
}

extension SearchViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        addGameStack.isHidden = true
        searchTableView.isHidden = false
        fetchDataGames()
        return true
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.sizeWithTheDevice()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let gamesCount = searchGames?.count else {return 0}
        return gamesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as! GameTableViewCell
            cell.gameImage.cacheImage(urlString: searchGames?[indexPath.row].backgroundImage ?? "no image")
            cell.gameTitle.text = searchGames?[indexPath.row].name ?? "no name"
            cell.gameTitle.textColor = .black
            Tool.shared.setUpShadowTableCell(color: UIColor.black.cgColor, cell: cell)
        return cell
    }
    //back to the tableView's top and load next page
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewHeight = scrollView.frame.size.height;
                let scrollContentSizeHeight = scrollView.contentSize.height;
                let scrollOffset = scrollView.contentOffset.y;
                if (scrollOffset + scrollViewHeight == scrollContentSizeHeight) {
                    loadMoreData()
                }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SearchGameCard", sender: searchGames?[indexPath.row])
    }
}
