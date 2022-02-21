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
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var gameUPC = ""
    var gameName = ""
    var items: [Item]?
    
    //MARK: Cycle Life
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        setupScan()
        
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
    //MARK: Methods
    private func setupScan() {
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

    private func failed() {
        let ac = UIAlertController(title: "Erreur de lecture", message: "Votre appareil ne prend pas en charge la numérisation d'un code à partir d'un élément. Veuillez utiliser un appareil avec une caméra.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

   
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
//        if gameName == "" {
//            self.showAlertMessageBeforeToDismiss(title: "Erreur détectée ⛔️", message: "Nous n'avons pas trouvé le jeu que vous cherchez, nous vous invitons à faire une recherche ou bien créer une fiche 👾")
//        } else {
        dismiss(animated: true)
//        }
    }

    func found(code: String) {
        gameUPC = code
    }
    
    private func getUpcInfo() {
        GameService.shared.getDataWithUPC(barCode: gameUPC) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let itemsList):
                self.items = itemsList.items
            case .failure(let error):
                self.showAlertMessage(title: "Erreur détectée ⛔️", message: "Nous n'avons pas trouvé le jeu que vous cherchez, nous vous invitons à faire une recherche ou bien créer une fiche 👾 \n \(error.description)")
                }
            }
    }
//    func getDataWithGameName() {
//        GameService.shared.fetchSearchGames(search: gameName) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let games):
//                self.searchVC.searchGames = games.results
//                self.searchVC.searchTableView.reloadData()
//                self.searchVC.nextPage = games.next ?? "no next"
//            case .failure(let error):
//                print(error.description)
//                self.showAlertMessage(title: "Erreur détectée ⛔️", message: "Nous n'avons pas trouvé le jeu que vous cherchez, essaye un autre jeu 👾, \n \(error.description)")
//            }
//        }
//    }
}
