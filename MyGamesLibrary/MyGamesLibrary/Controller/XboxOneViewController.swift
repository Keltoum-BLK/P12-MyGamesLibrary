//
//  XboxOneViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 09/02/2022.
//

import UIKit

class XboxOneViewController: UIViewController {
    
    @IBOutlet weak var xboxHeader: UIImageView!
    @IBOutlet weak var xboxTableView: UITableView!
    
    private var xboxGames: [Game]?
    private var nextPage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        xboxTableView.dataSource = self
        xboxTableView.delegate = self
        getGames()
        setUpTableView()
        setUpImage()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        xboxHeader.addGradientLayerInBackground(frame: xboxHeader.bounds, colors: [UIColor(ciColor: .clear), UIColor(ciColor: .white)])
    }
    
    private  func setUpTableView() {
        xboxTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameTableViewCell")
        
        xboxTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            xboxTableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            xboxTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            xboxTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            xboxTableView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func getGames() {
        GameService.shared.fetchGames(platform: Platform.xbox.rawValue,page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let games):
                DispatchQueue.main.async {
                    self.xboxGames = games.results
                    self.xboxTableView.reloadData()
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
                self.xboxGames = games.results
                self.nextPage = games.next ?? "no next page"
                self.xboxTableView.reloadData()
            case .failure(let error):
                self.showAlertMessage(title: "Error", message: "Vous avez vu tout les jeux disponibles, \(error.description)")
            }
        }
    }
    
    private func setUpImage() {
        xboxHeader.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            xboxHeader.widthAnchor.constraint(equalTo: view.widthAnchor),
            xboxHeader.topAnchor.constraint(equalTo: view.topAnchor),
            xboxHeader.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.25),
            xboxHeader.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            xboxHeader.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        ])
    }
}

extension XboxOneViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.sizeWithTheDevice()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let gamesCount = xboxGames?.count else {return 0}
        return gamesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = xboxTableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as! GameTableViewCell
        cell.gameImage.cacheImage(urlString: xboxGames?[indexPath.row].backgroundImage ?? "no image")
        cell.gameTitle.text = xboxGames?[indexPath.row].name ?? "no name"
        cell.gameTitle.textColor = .green
        Tool.shared.setUpShadowTableCell(color: UIColor.systemGreen.cgColor, cell: cell)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewHeight = scrollView.frame.size.height;
                let scrollContentSizeHeight = scrollView.contentSize.height;
                let scrollOffset = scrollView.contentOffset.y;
                if (scrollOffset + scrollViewHeight == scrollContentSizeHeight) {
                    loadMoreData()
                    xboxTableView.setContentOffset(.zero, animated: true)
                }
    }
}
