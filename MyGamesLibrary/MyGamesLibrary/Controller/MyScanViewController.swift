//
//  MyScanViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 18/02/2022.
//

import UIKit
import AVFoundation

class MyScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    //MARK: Properties
    @IBOutlet weak var scannerView: UPCScannerView! {
        didSet {
            scannerView.delegate = self 
        }
    }
    @IBOutlet weak var scanBTN: UIButton! {
        didSet {
            scanBTN.setTitle("Stop", for: .normal)
        }
    }

    var gameName: String = ""
    var items: [Item]?
    var games: [Game]?
    var gameUPC: ScanData? = nil {
        didSet {
            if games != nil {
                self.performSegue(withIdentifier: "SearchControllerID", sender: self)
            }
        }
    }
    var searchController = SearchViewController()
    
    //MARK: Cycle Life
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
   
    
    private func getUpcInfo() {
        guard let barCode = gameUPC?.scanData else {
            return
        }
        GameService.shared.getDataWithUPC(barCode: barCode) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let itemsList):
                guard let title = itemsList.items.first?.title else { return }
                self.gameName = title
            case .failure(let error):
                self.showAlertMessage(title: "Erreur détectée ⛔️", message: "Nous n'avons pas trouvé le jeu que vous cherchez, nous vous invitons à faire une recherche ou bien créer une fiche 👾 \n \(error.description)")
                }
            }
    }
    func getDataWithGameName() {
        GameService.shared.fetchSearchGames(search: gameName) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let games):
                self.games = games.results
            case .failure(let error):
                print(error.description)
                self.showAlertMessage(title: "Erreur détectée ⛔️", message: "Nous n'avons pas trouvé le jeu que vous cherchez, essaye un autre jeu 👾, \n \(error.description)")
            }
        }
    }
}

extension MyScanViewController: UPCScannerViewDelegate {
    func upcScanningDidFail() {
        
        self.showAlertMessage(title: "Erreur détectée", message: "Impossible de lire le code barre, Veuillez réessayer.👾")
    }
    
    func upcScanningSucceededWithCode(_ str: String?) {
        self.gameUPC = ScanData(scanData: str)
    }
    
    func upcScanningDidStop() {
        let buttonTitle = scannerView.isRunning ? "Stop" : "Scan"
        scanBTN.setTitle(buttonTitle, for: .normal)
    }
    
    
}
