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
    private var PageLimite = 25
    private var nextPage: String? = nil 
    
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
    
    @IBAction func getGames(_ sender: Any) {
        searchTextField.resignFirstResponder()
        fetchDataGames()
    }
    
    private func fetchDataGames (completed: ((Bool) -> Void)? = nil) {
        GameService.shared.fetchSearchGames(search: searchTextField.text ?? "The witcher") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let games):
                    self.searchGames = games.results
                    self.searchTableView.reloadData()
                    self.nextPage = games.next
                    completed?(true)
            case .failure(let error):
                print(error.description)
            }
        }
    }
    
    private func loadMore (completed: ((Bool) -> Void)? = nil) {
        GameService.shared.loadMore(next: nextPage ?? "no next page") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let games):
                    self.searchGames = games.results
                    self.searchTableView.reloadData()
                    self.nextPage = games.next
                    completed?(true)
            case .failure(let error):
                print(error.description)
            }
        }
    }
    
    
    @IBAction func getGamesbyBarcode(_ sender: Any) {
    }
    
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.sizeWithTheDevice()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let gamesCount = searchGames?.count else {return 0}
        print(gamesCount)
        return gamesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = TableSection(rawValue: indexPath.section) else { return UITableViewCell() }
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as! GameTableViewCell
        switch section {
        case .gameList:
            cell.favoriteBTN.isHidden = true
            cell.gameImage.downloaded(from: searchGames?[indexPath.row].backgroundImage ?? "no image")
            cell.gameTitle.text = searchGames?[indexPath.row].name ?? "no name"
            cell.gameTitle.textColor = .black
            Tool.shared.setUpShadowTableCell(color: UIColor.black.cgColor, cell: cell)
        case .loader:
            cell.loaderLabel.isHidden = false
            cell.gameTitle.isHidden = true
            cell.favoriteBTN.isHidden = true
            cell.gameImage.isHidden = true
            cell.backgroundColor = .white
            cell.loaderLabel.text = "Loading.."
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = TableSection(rawValue: indexPath.section) else { return }
        
        if section == .loader {
            print("load new games")
            loadMore() { [weak self] success in
                if !success {
                self?.hideBottomLoader()
                }
            }
        }
    }
    
    private func hideBottomLoader() {
            DispatchQueue.main.async {
                guard let numberOfGames = self.searchGames?.count else { return }
                let lastListIndexPath = IndexPath(row: numberOfGames - 1, section: TableSection.gameList.rawValue)
                self.searchTableView.scrollToRow(at: lastListIndexPath, at: .bottom, animated: true)
            }
        }
}
