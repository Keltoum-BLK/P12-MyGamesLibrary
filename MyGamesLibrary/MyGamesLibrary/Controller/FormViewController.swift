//
//  FormViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 25/02/2022.
//

import UIKit
import PhotosUI
import Photos
import CoreData

class FormViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var releaseDateTextField: UITextField!
    @IBOutlet weak var imagePicker: UIImageView!
    @IBOutlet weak var takePicBTN: UIButton!
    @IBOutlet weak var ratingSlide: UISlider!
    @IBOutlet weak var playstationBTN: UIButton!
    @IBOutlet weak var xboxBTN: UIButton!
    @IBOutlet weak var nintendoBTN: UIButton!
    @IBOutlet weak var ratingValue: UILabel!
    
    var coreDataManager = CoreDataManager(managedObjectContext: CoreDataStack.shared.mainContext)
    var games = [MyGame]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
       
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        playstationBTN.layer.cornerRadius = 20
        xboxBTN.layer.cornerRadius = 20
        nintendoBTN.layer.cornerRadius = 20
        
        imagePicker.layer.cornerRadius = 20
        takePicBTN.layer.cornerRadius = 10
        titleTextField.changeThePLaceholderFont(text: "Saisissez le titre du jeu.", textField: self.titleTextField)
        releaseDateTextField.changeThePLaceholderFont(text: "Quand est-il sorti?", textField: self.releaseDateTextField)
        titleTextField.delegate = self
        releaseDateTextField.delegate = self
    }
    
    @IBAction func pickAnImage(_ sender: Any) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = 1
        configuration.filter = .images
        let pickerController = PHPickerViewController(configuration: configuration)
        pickerController.delegate = self
        present(pickerController, animated: true)
    }

    func createAGameCard(platform: Platform) -> Game {
            let gameImage = imagePicker.image?.pngData()?.base64EncodedString()
          let game = Game(name: titleTextField.text, released: releaseDateTextField.text, backgroundImage: gameImage, rating: Double(ratingValue.text ?? "0"),platforms: [PlatformElements(platform: platform)], short_screenshots: [])
            return game
    }
    
    @IBAction func addGamInPS4List(_ sender: Any) {
        let game = createAGameCard(platform: Platform(slug: "playstation"))
        coreDataManager.addGame(game: game)
        checkData()
        self.showAlertMessageBeforeToDismiss(title: "Bravo", message: "Tu as bien rajouté le jeu au catalogue. 🤖")
        print(games)
    }
    
    @IBAction func addGameInXboxList(_ sender: Any) {
        let game = createAGameCard(platform: Platform(slug: "xbox"))
        coreDataManager.addGame(game: game)
        self.showAlertMessageBeforeToDismiss(title: "Bravo", message: "Tu as bien rajouté le jeu au catalogue. 🤖")
    }
    
    @IBAction func addGameInSwitchList(_ sender: Any) {
        if everyElementAreFilled() {
        let game = createAGameCard(platform: Platform(slug: "nintendo-switch"))
        coreDataManager.addGame(game: game)
        self.showAlertMessageBeforeToDismiss(title: "Bravo", message: "Tu as bien rajouté le jeu au catalogue. 🤖")
        }
    }
    
    @IBAction func ratingValue(_ sender: UISlider) {
        ratingValue.text = String(Int(sender.value))
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        releaseDateTextField.resignFirstResponder()
        return true
    }
    func checkData() {
        games = coreDataManager.fetchGames(mygames: self.games)
    }
    
    private func everyElementAreFilled() -> Bool {
        if titleTextField.text != "", releaseDateTextField.text != "", imagePicker.image != nil, ratingValue.text != "" {
            return true
        } else {
            self.showAlertMessage(title: "Erreur détectée", message: "Tu as oublié un élement 🙀.")
            return false
        }
    }
}

extension FormViewController: UINavigationControllerDelegate, PHPickerViewControllerDelegate, UITextFieldDelegate {
   
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

