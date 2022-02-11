//
//  PS4ViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 09/02/2022.
//

import UIKit

class PS4ViewController: UIViewController {

    @IBOutlet weak var pS4GamesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pS4GamesTableView.delegate = self
        pS4GamesTableView.dataSource = self
        setUpTableView()
        // Do any additional setup after loading the view.
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = pS4GamesTableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as! GameTableViewCell
        
        return cell
    }
    
    
}
