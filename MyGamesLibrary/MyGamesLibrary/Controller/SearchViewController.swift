//
//  ScannerViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 11/02/2022.
//

import UIKit
import AVFoundation

class SearchViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var searchContainer: UIStackView!
    @IBOutlet weak var scanTitle: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var scanBTN: UIButton!
    @IBOutlet weak var searchBTN: UIButton!
    @IBOutlet weak var searchTableView: UITableView!
 
   
    private var searchGames: [Game]?
    private var nextPage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.delegate = self
        searchTableView.dataSource = self
        setUpUI()
        setUpTableView()
    }

    func setUpUI() {
        view.backgroundColor = UIColor.white
        searchBTN.backgroundColor = .lightGray
        searchBTN.layer.cornerRadius = searchBTN.frame.height / 2
        
        scanBTN.backgroundColor = .white
        scanBTN.layer.cornerRadius = scanBTN.frame.height / 2
        
        searchContainer.layer.cornerRadius = 20
        
        scanTitle.layer.masksToBounds = true
        scanTitle.layer.cornerRadius = 20
        
        searchTextField.changeThePLaceholderFont(text: "Quel jeu cherches-tu?", textField: searchTextField)
    }
    
    private  func setUpTableView() {
        searchTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameTableViewCell")
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchTableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            searchTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 159),
            searchTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            searchTableView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    //search video games
    @IBAction func getGames(_ sender: Any) {
        searchTextField.resignFirstResponder()
        fetchDataGames()
    }
    
    private func fetchDataGames () {
        guard let title = searchTextField.text else { return }
        GameService.shared.fetchSearchGames(search: title) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let games):
                    self.searchGames = games.results
                    self.searchTableView.reloadData()
                    self.nextPage = games.next ?? "no next"
            case .failure(let error):
                print(error.description)
                self.showAlertMessage(title: "Error", message: "Nous n'avons pas trouvé le jeu que vous cherchez, essaye un autre nom, \n \(error.description)")
            }
        }
    }
    //load the next page of games data
    private func loadMoreData() {
        GameService.shared.getDataFromUrl(next: nextPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let games):
                self.searchGames = games.results
                self.nextPage = games.next ?? "no next page"
                self.searchTableView.reloadData()
            case .failure(let error):
                self.showAlertMessage(title: "Error", message: "Vous avez vu tout les jeux disponibles, \(error.description)")
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchGameCard", let next = segue.destination as? GameCardViewController {
            next.game = sender as? Game
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
    
    //MARK: Pop-up Alert
       func showAlertMessage(title: String, message: String) {
           let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
           self.present(alert, animated: true)
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
            cell.favoriteBTN.isHidden = true
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
                    searchTableView.setContentOffset(.zero, animated: true)
                }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SearchGameCard", sender: searchGames?[indexPath.row])
    }
    
    
}
