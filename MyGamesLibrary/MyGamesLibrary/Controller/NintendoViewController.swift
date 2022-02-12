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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nintendoTableView.delegate = self
        nintendoTableView.dataSource = self
        setUpTableView()
        setUpImage()
        // Do any additional setup after loading the view.
    }
   func setUpTableView() {
        nintendoTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameTableViewCell")
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
}

extension NintendoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = nintendoTableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as! GameTableViewCell
        Tool.shared.setUpShadowCell(color: UIColor.systemRed.cgColor, cell: cell)
        return cell
    }
}
