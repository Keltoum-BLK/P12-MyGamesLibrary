//
//  PS4ViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 09/02/2022.
//

import UIKit

class PS4ViewController: UIViewController {
    
    @IBOutlet weak var ps4Header: UIImageView!
    @IBOutlet weak var pS4GamesTableView: UITableView!
    
    private var ps4Games: [Game]?
    private var nextPage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pS4GamesTableView.delegate = self
        pS4GamesTableView.dataSource = self
        getGames()
        setUpTableView()
        setUpImage()
    }
    override func viewDidLayoutSubviews() {
        ps4Header.addGradientLayerInBackground(frame: ps4Header.bounds, colors: [UIColor(ciColor: .clear), UIColor(ciColor: .white)])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    //send data to the next Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlaystationCard", let next = segue.destination as? GameCardViewController {
            next.game = sender as? Game
        }
    }

    private func setUpImage() {
        ps4Header.backgroundImage(view: self.view, multiplier: 0.25)
        
    }
    
    private func setUpTableView() {
        pS4GamesTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameTableViewCell")
        pS4GamesTableView.tableViewConstraints(view: self.view, constant: 120)
    }
    
    private func getGames() {
        GameService.shared.fetchGames(platform: GamePlatform.playstation.rawValue, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let games):
                self.ps4Games = games.results
                self.pS4GamesTableView.reloadData()
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
                self.ps4Games?.append(contentsOf: games.results ?? [])
                self.nextPage = games.next ?? "no next page"
                self.pS4GamesTableView.reloadData()
            case .failure(let error):
                self.showAlertMessage(title: "Error", message: "Vous avez vu tout les jeux disponibles, \(error.description)")
            }
        }
    }
}

extension PS4ViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.sizeWithTheDevice()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let gamesCount = ps4Games?.count else {return 0}
        return gamesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = pS4GamesTableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as! GameTableViewCell
        cell.selectionStyle = .none
        cell.gameImage.cacheImage(urlString: ps4Games?[indexPath.row].backgroundImage ?? "no image")
        cell.gameTitle.text = ps4Games?[indexPath.row].name ?? "no name"
        cell.gameTitle.textColor = .blue
        Tool.shared.setUpShadow(color: UIColor.systemBlue.cgColor, cell: cell, width: 0, height: 5)
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
        print(indexPath.row)
        performSegue(withIdentifier: "PlaystationCard", sender: ps4Games?[indexPath.row])
    }
}
