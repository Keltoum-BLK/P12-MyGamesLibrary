//
//  FormViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 25/02/2022.
//

import UIKit
import PhotosUI
import Photos

class FormViewController: UIViewController {

 
    @IBOutlet weak var dismissBTN: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var releaseDateTextField: UITextField!
    @IBOutlet weak var imagePicker: UIImageView!
    @IBOutlet weak var takePicBTN: UIButton!
    @IBOutlet weak var ratingSlide: UISlider!
    @IBOutlet weak var playstationBTN: UIButton!
    @IBOutlet weak var xboxBTN: UIButton!
    @IBOutlet weak var nintendoBTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    func setupUI() {
        playstationBTN.layer.cornerRadius = 20
        xboxBTN.layer.cornerRadius = 20
        nintendoBTN.layer.cornerRadius = 20
        dismissBTN.layer.cornerRadius = dismissBTN.frame.height / 2
        
        imagePicker.layer.cornerRadius = 20
        takePicBTN.layer.cornerRadius = 10
        titleTextField.changeThePLaceholderFont(text: "Saisissez le titre du jeu.", textField: self.titleTextField)
        releaseDateTextField.changeThePLaceholderFont(text: "Quand est-il sorti?", textField: self.releaseDateTextField)
        
    }
    
    @IBAction func dismissBTN(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func pickAnImage(_ sender: Any) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = 1
        configuration.filter = .images
        let pickerController = PHPickerViewController(configuration: configuration)
        pickerController.delegate = self
        present(pickerController, animated: true)
    }
}

extension FormViewController: UINavigationControllerDelegate, PHPickerViewControllerDelegate {
   
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
                guard let self = self else { return }
                guard let image = reading as? UIImage, error == nil  else { return }
                DispatchQueue.main.async {
                    self.imagePicker.image = image
                }
                
            }
        }
    }
}

