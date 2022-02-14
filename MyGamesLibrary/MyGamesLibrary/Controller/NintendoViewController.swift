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
    
    var nintendoGames: [Game]?
    
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
    func setUpImage() {
        nintendoHeader.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nintendoHeader.widthAnchor.constraint(equalTo: view.widthAnchor),
            nintendoHeader.topAnchor.constraint(equalTo: view.topAnchor),
            nintendoHeader.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.25),
            nintendoHeader.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            nintendoHeader.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        ])
    }
    func setUpTableView() {
        nintendoTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameTableViewCell")
    }
    
    private func getGames() {
        GameService.shared.fetchGames(platform: Platform.nswitch.rawValue) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let games):
                DispatchQueue.main.async {
                    self.nintendoGames = games.results
                    self.nintendoTableView.reloadData()
                }
            case .failure(let error):
                print(error.description)
            }
        }
    }
    
}

extension NintendoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let gamesCount = nintendoGames?.count else {return 0}
        return gamesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = nintendoTableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as! GameTableViewCell
        cell.gameImage.downloaded(from: nintendoGames?[indexPath.row].backgroundImage ?? "no image")
        cell.gameTitle.text = nintendoGames?[indexPath.row].name ?? "no name"
        cell.gameTypeLabel.text = Tool.shared.getDoubleToString(number: nintendoGames?[indexPath.row].rating)
        Tool.shared.setUpShadowTableCell(color: UIColor.systemRed.cgColor, cell: cell)
        return cell
    }
}
