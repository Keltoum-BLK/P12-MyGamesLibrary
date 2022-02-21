//
//  NintendoViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 11/02/2022.
//

import UIKit

class NintendoViewController: UIViewController {
    
    @IBOutlet weak var nintendoHeader: UIImageView!
    @IBOutlet weak var nintendoTableView: UITableView!
    
    private var nintendoGames: [Game]?
    private var nextPage: String = ""
    
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
    
    private func setUpImage() {
        nintendoHeader.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nintendoHeader.widthAnchor.constraint(equalTo: view.widthAnchor),
            nintendoHeader.topAnchor.constraint(equalTo: view.topAnchor),
            nintendoHeader.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.25),
            nintendoHeader.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            nintendoHeader.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        ])
    }
    private func setUpTableView() {
        nintendoTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameTableViewCell")
        nintendoTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nintendoTableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            nintendoTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            nintendoTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            nintendoTableView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func getGames() {
        GameService.shared.fetchGames(platform: Platform.nintendo.rawValue, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let games):
                DispatchQueue.main.async {
                    self.nintendoGames = games.results
                    self.nintendoTableView.reloadData()
                    self.nextPage = games.next ?? "no next page"
                }
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
                self.nintendoGames = games.results
                self.nextPage = games.next ?? "no next page"
                self.nintendoTableView.reloadData()
            case .failure(let error):
                self.showAlertMessage(title: "Error", message: "Vous avez vu tout les jeux disponibles, \(error.description)")
            }
        }
    }
}

extension NintendoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.sizeWithTheDevice()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let gamesCount = nintendoGames?.count else {return 0}
        return gamesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = nintendoTableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as! GameTableViewCell
        cell.gameImage.cacheImage(urlString: nintendoGames?[indexPath.row].backgroundImage ?? "no image")
        cell.gameTitle.text = nintendoGames?[indexPath.row].name ?? "no name"
        cell.gameTitle.textColor = .red
        Tool.shared.setUpShadowTableCell(color: UIColor.systemRed.cgColor, cell: cell)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewHeight = scrollView.frame.size.height;
                let scrollContentSizeHeight = scrollView.contentSize.height;
                let scrollOffset = scrollView.contentOffset.y;
                if (scrollOffset + scrollViewHeight == scrollContentSizeHeight) {
                    loadMoreData()
                    nintendoTableView.setContentOffset(.zero, animated: true)
                }
    }
}
