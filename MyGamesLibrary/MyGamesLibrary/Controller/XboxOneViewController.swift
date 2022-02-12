//
//  XboxOneViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 09/02/2022.
//

import UIKit

class XboxOneViewController: UIViewController {

    @IBOutlet weak var xboxTitle: UILabel!
    @IBOutlet weak var xboxTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        xboxTableView.dataSource = self
        xboxTableView.delegate = self
        setUpLabel()
        setUpTableView()
        // Do any additional setup after loading the view.
    }
    func setUpLabel() {
        xboxTitle.setMargins()
        xboxTitle.layer.masksToBounds = true
        xboxTitle.layer.cornerRadius = 20
    }
   func setUpTableView() {
        xboxTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameTableViewCell")
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
        
        return cell
    }
    
    
}
