//
//  MyScanViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 18/02/2022.
//

import AVFoundation
import UIKit

class MyScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    private var gameUPC = ""
    private var gameName = ""
    var games: [Game]?
    private var item: [Item]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

    }
    
    private func setup() {
        view.backgroundColor = UIColor.lightGray
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 40, y: 80, width: 300, height: 200)
        previewLayer.cornerRadius = 20
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        view.backgroundColor = .lightGray
        captureSession.startRunning()
    }
    
    func failed() {
        self.showAlertMessageBeforeToDismiss(title: "Erreur détectée ⛔️", message: "Impossible de lire le code barre 👾.")
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
            captureSession.stopRunning()
        }
        games = getDataWithGameName()
        dump(item)
        dismiss(animated: true) {
            let searchVC = SearchViewController()
            searchVC.searchGames = self.games
        }
    }
    
    func found(code: String) {
        getUpcInfo()
        gameName = item?.first?.title ?? "no title"
        print(gameName)
        print(code)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
     private func getUpcInfo() {
            GameService.shared.getDataWithUPC(barCode: gameUPC) {[weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let itemsList):
                    self.item = itemsList.items
                case .failure(let error):
                    self.showAlertMessageBeforeToDismiss(title: "Erreur détectée ⛔️", message: "Nous n'avons pas trouvé le jeu que vous cherchez, nous vous invitons à faire une recherche ou bien créer une fiche 👾 \n \(error.description)")
                    }
                }
        }
        
    func getDataWithGameName() -> [Game] {
            GameService.shared.fetchSearchGames(search: gameName) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let games):
                    guard let gameList = games.results else { return }
                    return self.games = gameList
                case .failure(let error):
                    self.showAlertMessageBeforeToDismiss(title: "Erreur détectée ⛔️", message: "Nous n'avons pas trouvé le jeu que vous cherchez, essaye un autre jeu 👾, \n \(error.description)")
                    return self.games = []
                }
            }
        dump(games)
        return games ?? []
        }
}
