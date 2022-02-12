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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pS4GamesTableView.delegate = self
        pS4GamesTableView.dataSource = self
        setUpTableView()
        setUpImage()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        ps4Header.addGradientLayerInBackground(frame: ps4Header.bounds, colors: [UIColor(ciColor: .clear), UIColor(ciColor: .white)])
    }
    func setUpImage() {
        ps4Header.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ps4Header.widthAnchor.constraint(equalTo: view.widthAnchor),
            ps4Header.topAnchor.constraint(equalTo: view.topAnchor),
            ps4Header.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.25),
            ps4Header.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            ps4Header.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        ])
    }
    
   func setUpTableView() {
        pS4GamesTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameTableViewCell")
    }
}

extension PS4ViewController: UITableViewDelegate, UITableViewDataSource {
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = pS4GamesTableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as! GameTableViewCell
        Tool.shared.setUpShadowCell(color: UIColor.systemBlue.cgColor, cell: cell)
        return cell
    }
    
   
}
