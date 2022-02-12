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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        xboxTableView.dataSource = self
        xboxTableView.delegate = self
        setUpTableView()
        setUpImage()
        // Do any additional setup after loading the view.
    }
   func setUpTableView() {
        xboxTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameTableViewCell")
    }
    
    override func viewDidLayoutSubviews() {
        xboxHeader.addGradientLayerInBackground(frame: xboxHeader.bounds, colors: [UIColor(ciColor: .clear), UIColor(ciColor: .white)])
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = xboxTableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as! GameTableViewCell
        Tool.shared.setUpShadowCell(color: UIColor.systemGreen.cgColor, cell: cell)
        return cell
    }
}
