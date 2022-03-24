//
//  MyScanViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 18/02/2022.
//

import AVFoundation
import UIKit
//MARK: Protocol Delegate to pass data
protocol ScanControllerDelegate: AnyObject {
    func showGameList(with games: [Game])
}

class MyScanViewController: UIViewController {
    
    //MARK: Properties
    weak var delegate: ScanControllerDelegate?
    private var captureSession = AVCaptureSession()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setupLiveView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
    
    // MARK: Private Methods
    private func setupLiveView() {
        captureSession.sessionPreset = .hd1280x720
        guard let videoDeviceInput = addVideoInput() else { return }
        captureSession.addInput(videoDeviceInput)
        addCaptureOutput()
    }
    
    private func addVideoInput() -> AVCaptureDeviceInput? {
        let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                    for: .video,
                                                    position: .back)
        
        guard let videoCaptureDevice = captureDevice else { return nil }
        AVCaptureDevice.requestAccess(for: .video) { isAuthorized in
            if !isAuthorized {
                DispatchQueue.main.async {
                    self.presentCameraSettings()
                }
            }
        }
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice)
        else {
            return nil
        }
        captureSession.canAddInput(videoInput)
        return videoInput
    }
    //add capture
    private func addCaptureOutput() {
        let metadataOutput = AVCaptureMetadataOutput()
        guard captureSession.canAddOutput(metadataOutput) else {
            showFailedSessionMessage()
            return
        }
        captureSession.addOutput(metadataOutput)
        let queue = DispatchQueue.main
        metadataOutput.setMetadataObjectsDelegate(self, queue: queue)
        metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        
        configurePreviewLayer()
        captureSession.startRunning()
    }
    //configure the previewViewLayer
    private func configurePreviewLayer() {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 20,
                                    y: 20,
                                    width: view.bounds.size.width - 40,
                                    height: view.bounds.size.height * 0.3)
        previewLayer.cornerRadius = 20
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }
    
    // MARK: Api call to fetch game's name
    private func fetchTitle(from code: String) {
        GameService.shared.getDataWithUPC(barCode: code) { [weak self] result in
            switch result {
            case .success(let info):
                guard let gameTitle = info.items.first?.title else {
                    self?.showFailedSessionMessage()
                    return
                }
                self?.fetchGamesList(title: gameTitle)
                print(info)
            case .failure(let error):
                print(error.description)
            }
        }
    }
    // fetch games list
    func fetchGamesList(title: String) {
        GameService.shared.fetchSearchGames(search: title) { [weak self] result in
            switch result {
            case .success(let result):
                guard let foundGamesList = result.results else {
                    self?.showAlertMessageBeforeToDismiss(title: "Erreur détectée ⛔️",
                                                          message: "Impossible de trouver ton jeu 👾. Tu peux soit effectuer une recherche ou bien créer la fiche de ton jeu.")
                    return
                }
                self?.delegate?.showGameList(with: foundGamesList)
                self?.dismiss(animated: true)
            case .failure(let error):
                print(error.description)
            }
        }
    }
    
    private func showFailedSessionMessage() {
        self.showAlertMessageBeforeToDismiss(title: "Erreur détectée ⛔️",
                                             message: "Impossible de lire le code barre 👾. Tu peux soit effectuer une recherche ou bien créer la fiche de ton jeu.")
    }
    //alert Message to add user to make a choice
    func presentCameraSettings() {
        let alertController = UIAlertController(title: "Error",
                                                message: "Camera access is denied",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default) {_ in
            self.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    // Handle
                })
            }
        })
        present(alertController, animated: true)
    }
}

extension MyScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            fetchTitle(from: stringValue)
        }
    }
}
