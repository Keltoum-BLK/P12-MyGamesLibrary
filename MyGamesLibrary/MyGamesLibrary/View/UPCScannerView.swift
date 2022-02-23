//
//  UPCScannerView.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 23/02/2022.
//

import Foundation
import UIKit
import AVFoundation

protocol UPCScannerViewDelegate: AnyObject {
    func upcScanningDidFail()
    func upcScanningSucceededWithCode(_ str: String?)
    func upcScanningDidStop()
}

class UPCScannerView : UIView {
    //MARK: Properties
    weak var delegate: UPCScannerViewDelegate?
    
    //capture session which allows to start and stop scanning.
    var captureSession: AVCaptureSession?
    
    //MARK: Init methods
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        doInitialSetup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        doInitialSetup()
    }
    
    //MARK: overriding the layerClass to return "AVCaptureVideoPreviewLayer".
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    override var layer: AVCaptureVideoPreviewLayer {
        return super.layer as! AVCaptureVideoPreviewLayer
    }
}

extension UPCScannerView {
    
    var isRunning: Bool {
        captureSession?.isRunning ?? false
    }
    
    func startScanning() {
        captureSession?.startRunning()
    }
    
    func stopScanning() {
        captureSession?.stopRunning()
        delegate?.upcScanningDidStop()
    }
    
    //Does the initial setup for catureSession
    private func   doInitialSetup() {
        clipsToBounds = true
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch let error {
            print(error)
            return
        }
        
        if (captureSession?.canAddInput(videoInput) ?? false) {
            captureSession?.addInput(videoInput)
        } else {
            scanningDidFail()
            return
        }
        
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if (captureSession?.canAddOutput(metaDataOutput) ?? false ) {
            captureSession?.addOutput(metaDataOutput)
            
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            scanningDidFail()
            return
        }
        
        self.layer.session = captureSession
        self.layer.videoGravity = .resizeAspectFill
        self.layer.cornerRadius = 20
        captureSession?.startRunning()
    }
    
    func scanningDidFail() {
        delegate?.upcScanningDidFail()
        captureSession = nil
    }
    
    func found(code: String) {
        delegate?.upcScanningSucceededWithCode(code)
    }
}

extension UPCScannerView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        stopScanning()
        
        if let metaDataObject = metadataObjects.first {
            guard let readableObject = metaDataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }
    
}
