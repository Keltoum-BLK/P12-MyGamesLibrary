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
    
    var xboxGames: [Game]?
    
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
    }
    
    private func getGames() {
        GameService.shared.fetchGames(platform: Platform.xboxone.rawValue) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let games):
                DispatchQueue.main.async {
                    self.xboxGames = games.results
                    self.xboxTableView.reloadData()
                }
            case .failure(let error):
                print(error.description)
            }
        }
    }
    
    
    func setUpImage() {
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
        return 200
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let gamesCount = xboxGames?.count else {return 0}
        return gamesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = xboxTableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as! GameTableViewCell
        cell.gameImage.downloaded(from: xboxGames?[indexPath.row].backgroundImage ?? "no image")
        cell.gameTitle.text = xboxGames?[indexPath.row].name ?? "no name"
        cell.gameTypeLabel.text = Tool.shared.getDoubleToString(number: xboxGames?[indexPath.row].rating)
        Tool.shared.setUpShadowTableCell(color: UIColor.systemGreen.cgColor, cell: cell)
        
        return cell
    }
}
