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
    private var currentPage = 1
    var isLoadingList: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nintendoTableView.delegate = self
        nintendoTableView.dataSource = self
        getGames(page: currentPage)
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
    
    private func getGames(page: Int) {
        GameService.shared.fetchGames(platform: Platform.nswitch.rawValue, page: page) { [weak self] result in
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
    
    func getListFromServer(currentPage : Int){
        self.isLoadingList = false
        self.nintendoTableView.reloadData()
    }
    
    func loadMoreItemsForList(){
        currentPage += 1
        getListFromServer(currentPage: currentPage)
        getGames(page: currentPage)
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
        cell.gameImage.downloaded(from: nintendoGames?[indexPath.row].backgroundImage ?? "no image")
        cell.gameTitle.text = nintendoGames?[indexPath.row].name ?? "no name"
        cell.gameTitle.textColor = .red
        cell.gameTypeLabel.text = Tool.shared.getDoubleToString(number: nintendoGames?[indexPath.row].rating)
        Tool.shared.setUpShadowTableCell(color: UIColor.systemRed.cgColor, cell: cell)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
                   self.isLoadingList = true
                   self.loadMoreItemsForList()
               }
    }
}
