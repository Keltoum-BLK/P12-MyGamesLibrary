//
//  XboxOneViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 09/02/2022.
//

import UIKit

class XboxOneViewController: UIViewController {
    //MARK: UI Properties
    @IBOutlet weak var xboxHeader: UIImageView!
    @IBOutlet weak var xboxTableView: UITableView!
    
    //MARK: Properties
    private var xboxGames: [Game]?
    private var nextPage: String = ""
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        xboxTableView.dataSource = self
        xboxTableView.delegate = self
        DispatchQueue.main.async {
            self.getGames()
        }
        setUpTableView()
        setUpImage()
    }
    
    override func viewDidLayoutSubviews() {
        xboxHeader.addGradientLayerInBackground(frame: xboxHeader.bounds, colors: [UIColor(ciColor: .clear), UIColor(ciColor: .white)])
    }
    
    //MARK: Segue Method to pass data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "XboxCard", let next = segue.destination as? GameCardViewController {
            next.game = sender as? Game
        }
    }
    
    //MARK: Methods
    private func setUpImage() {
        xboxHeader.backgroundImage(view: self.view, multiplier: 0.25)
    }

    private  func setUpTableView() {
        xboxTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameTableViewCell")
        
        xboxTableView.tableViewConstraints(view: self.view, constant: 120)
    }
    
    private func getGames() {
        GameService.shared.fetchGames(platform: GamePlatform.xbox.rawValue,page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let games):
                    self.xboxGames = games.results
                    self.xboxTableView.reloadData()
                    self.nextPage = games.next ?? "no next page"
            case .failure(let error):
                self.showAlertMessage(title: "Error", message: "Une erreur est survenue, \(error.description)")
            }
        }
    }
    
    private func loadMoreData() {
        GameService.shared.getDataFromUrl(next: nextPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let games):
                self.xboxGames?.append(contentsOf: games.results ?? [])
                self.nextPage = games.next ?? "no next page"
                self.xboxTableView.reloadData()
            case .failure(let error):
                self.showAlertMessage(title: "Error", message: "Vous avez vu tout les jeux disponibles, \(error.description)")
            }
        }
    }
}

extension XboxOneViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: TableView Methods 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.sizeWithTheDevice()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let gamesCount = xboxGames?.count else {return 0}
        return gamesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = xboxTableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as! GameTableViewCell
        cell.selectionStyle = .none
        cell.gameImage.cacheImage(urlString: xboxGames?[indexPath.row].backgroundImage ?? "no image")
        cell.gameTitle.text = xboxGames?[indexPath.row].name ?? "no name"
        cell.gameTitle.textColor = .green
        cell.setUpShadow(color: UIColor.systemGreen.cgColor, cell: cell, width: 0, height: 5)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewHeight = scrollView.frame.size.height;
              let scrollContentSizeHeight = scrollView.contentSize.height;
              let scrollOffset = scrollView.contentOffset.y;
              if (scrollOffset + scrollViewHeight == scrollContentSizeHeight) {
                  loadMoreData()
              }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "XboxCard", sender: xboxGames?[indexPath.row])
    }
}
