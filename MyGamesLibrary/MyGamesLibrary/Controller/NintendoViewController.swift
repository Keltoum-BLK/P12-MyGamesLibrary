//
//  NintendoViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 11/02/2022.
//

import UIKit

class NintendoViewController: UIViewController {
    
    //MARK: UI Properties
    @IBOutlet weak var nintendoHeader: UIImageView!
    @IBOutlet weak var nintendoTableView: UITableView!
    
    //MARK: Properties
    private var nintendoGames: [Game]?
    private var nextPage: String = ""
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nintendoTableView.delegate = self
        nintendoTableView.dataSource = self
        getGames()
        setUpTableView()
        setUpImage()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        nintendoHeader.addGradientLayerInBackground(frame: nintendoHeader.bounds, colors: [UIColor(ciColor: .clear), UIColor(ciColor: .white)])
    }
    
    //MARK: Segue method to pass data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NintendoCard", let next = segue.destination as? GameCardViewController {
            next.game = sender as? Game
        }
    }
    
    //MARK: Methods
    private func setUpImage() {
        nintendoHeader.backgroundImage(view: self.view, multiplier: 0.25)
    }
    private func setUpTableView() {
        nintendoTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameTableViewCell")
        nintendoTableView.tableViewConstraints(view: self.view, constant: 120)
    }
    //get games 
    private func getGames() {
        GameService.shared.fetchGames(platform: GamePlatform.nintendo.rawValue, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let games):
                    self.nintendoGames = games.results
                    self.nintendoTableView.reloadData()
                    self.nextPage = games.next ?? "no next page"
            case .failure(let error):
                self.showAlertMessage(title: "Error", message: "Une erreur est survenue, \(error.description)")
            }
        }
    }
    //load data for the pagination
    private func loadMoreData() {
        GameService.shared.getDataFromUrl(next: nextPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let games):
                self.nintendoGames?.append(contentsOf: games.results ?? [])
                self.nextPage = games.next ?? "no next page"
                self.nintendoTableView.reloadData()
            case .failure(let error):
                self.showAlertMessage(title: "Error", message: "Vous avez vu tout les jeux disponibles, \(error.description)")
            }
        }
    }
}

extension NintendoViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: TableView Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.sizeWithTheDevice()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let gamesCount = nintendoGames?.count else {return 0}
        return gamesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = nintendoTableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as! GameTableViewCell
        cell.selectionStyle = .none
        cell.gameImage.cacheImage(urlString: nintendoGames?[indexPath.row].backgroundImage ?? "no image")
        cell.gameTitle.text = nintendoGames?[indexPath.row].name ?? "no name"
        cell.gameTitle.textColor = .red
        cell.setUpShadow(color: UIColor.systemRed.cgColor, cell: cell, width: 0, height: 5)
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
        performSegue(withIdentifier: "NintendoCard", sender: nintendoGames?[indexPath.row])
    }
}
