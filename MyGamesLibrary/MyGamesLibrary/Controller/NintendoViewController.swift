//
//  NintendoViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 11/02/2022.
//

import UIKit

class NintendoViewController: UIViewController {

    @IBOutlet weak var nintendoTitle: UILabel!
    @IBOutlet weak var nintendoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nintendoTableView.delegate = self
        nintendoTableView.dataSource = self
        setUpLabel()
        setUpTableView()
        // Do any additional setup after loading the view.
    }
    
    func setUpLabel() {
        nintendoTitle.setMargins()
        nintendoTitle.layer.masksToBounds = true
        nintendoTitle.layer.cornerRadius = 20
    }
   func setUpTableView() {
        nintendoTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameTableViewCell")
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
        
        return cell
    }
}
