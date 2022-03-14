//
//  MyScanViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 18/02/2022.
//

import AVFoundation
import UIKit

protocol ScanControllerDelegate: AnyObject {
    func showGameList(with games: [Game])
}

class MyScanViewController: UIViewController {
    
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
    
    // MARK: Private functions
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
        guard let videoCaptureDevice = captureDevice,
              let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
              captureSession.canAddInput(videoInput) else {
            return nil
        }
        return videoInput
    }
    
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
    
    // MARK: Api call
    private func fetchTitle(from code: String) {
        GameService.shared.getDataWithUPC(barCode: code) { [weak self] result in
            switch result {
            case .success(let info):
                guard let gameTitle = info.items.first?.title else {
                    self?.showAlertMessageBeforeToDismiss(title: "Erreur détectée ⛔️", message: "Nous n'avons pas trouvé ton jeu, tu peux l'ajouter ou bien le chercher, appuies sur OK pour y accéder.")
                    return
                }
                self?.fetchGamesList(title: gameTitle)
                print(info)
            case .failure(let error):
                print(error.description)
            }
        }
    }
    
    func fetchGamesList(title: String) {
        GameService.shared.fetchSearchGames(search: title) { [weak self] result in
            switch result {
            case .success(let result):
                guard let foundGamesList = result.results else {
                    // TODO: Inform user or no game found with title
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
                                             message: "Impossible de lire le code barre 👾.")
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
