//
//  PopViewViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 19/03/2022.
//

import UIKit


class PlatformsViewController: UITableViewController {
    //MARK: Properties
    var game: Game?
    private var plateformNames = ""
    private var plateformArray = [String]()
        
    //MARK: Life Cycle 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        plateformNames = game?.createNameList(for: game?.platforms) ?? "no platform"
        plateformArray = plateformNames.split(separator: ",").map { String($0.capitalized.trimmingCharacters(in: .whitespacesAndNewlines)) }

        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plateformArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.font = UIFont(name: "Futura", size: 30)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = plateformArray[indexPath.row]
        return cell
    }
}
