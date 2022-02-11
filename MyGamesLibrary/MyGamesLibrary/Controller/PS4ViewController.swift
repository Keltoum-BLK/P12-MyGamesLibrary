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
        pS4GamesTableView.register(UINib(nibName: "GameCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }
}

extension PS4ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = pS4GamesTableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as! GameTableViewCell
        
        return cell
    }
    
    
}
