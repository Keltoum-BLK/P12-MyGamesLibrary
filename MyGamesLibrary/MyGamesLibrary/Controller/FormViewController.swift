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
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var takePicBTN: UIButton!
    @IBOutlet weak var ratingSlide: UISlider!
    @IBOutlet weak var playstationBTN: UIButton!
    @IBOutlet weak var xboxBTN: UIButton!
    @IBOutlet weak var nintendoBTN: UIButton!
    @IBOutlet weak var ratingValue: UILabel!
    @IBOutlet weak var backBTN: UIButton!
    
    private let datePicker = UIDatePicker()
    private var coreDataManager = CoreDataManager(managedObjectContext: CoreDataStack.shared.mainContext)
    var games = [MyGame]()
    var imageUrl = "" {
        didSet {
            gameImage.downloaded(from: imageUrl)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        createDtePicker()
        print(imageUrl)
        gameImage.downloaded(from: imageUrl)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SuggestedImages", let next = segue.destination as? SuggestedImagesViewController {
            next.delegate = self 
            next.gameTitle = sender as? String ?? "no title"
        }
    }
    
    private func createDtePicker() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        toolbar.sizeToFit()
        
        let doneBTN = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBTN], animated: true)
        
        releaseDateTextField.inputAccessoryView = toolbar
        
        releaseDateTextField.inputView = datePicker
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        self.view.window?.addSubview(datePicker)
    }
    
    @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.timeStyle = .none
        releaseDateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    private func setup() {
        playstationBTN.layer.cornerRadius = 20
        xboxBTN.layer.cornerRadius = 20
        nintendoBTN.layer.cornerRadius = 20
        
        gameImage.layer.cornerRadius = 20
        
        takePicBTN.layer.cornerRadius = 10
        
        backBTN.layer.cornerRadius = 10
        Tool.shared.setUpShadow(color: UIColor.black.cgColor, cell: backBTN, width: 3, height: 3)
        
        titleTextField.changeThePLaceholderFont(text: "Saisissez le titre du jeu.", textField: self.titleTextField)
        releaseDateTextField.changeThePLaceholderFont(text: "JJ/MM/AAAA", textField: self.releaseDateTextField)
        titleTextField.delegate = self
        releaseDateTextField.delegate = self
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pickAnImage(_ sender: Any) {
        performSegue(withIdentifier: "SuggestedImages", sender: titleTextField.text)
    }
    
    func createAGameCard(platform: Platform) -> Game {
        let game = Game(name: titleTextField.text, released: releaseDateTextField.text, backgroundImage: imageUrl, rating: Double(ratingValue.text ?? "0"),platforms: [PlatformElements(platform: platform)], short_screenshots: [])
        return game
    }
    
    @IBAction func addGamInPS4List(_ sender: Any) {
        let game = createAGameCard(platform: Platform(slug: "playstation4", name: "Playstation 4"))
        coreDataManager.addGame(game: game)
        self.showAlertMessage(title: "Bravo", message: "Tu as bien rajouté le jeu au catalogue. 🤖")
    }
    
    @IBAction func addGameInXboxList(_ sender: Any) {
        let game = createAGameCard(platform: Platform(slug: "xbox-one", name: "Xbox One"))
        coreDataManager.addGame(game: game)
        self.showAlertMessage(title: "Bravo", message: "Tu as bien rajouté le jeu au catalogue. 🤖")
    }
    
    @IBAction func addGameInSwitchList(_ sender: Any) {
        if everyElementAreFilled() {
            let game = createAGameCard(platform: Platform(slug: "nintendo-switch", name: "Nintendo Switch"))
            coreDataManager.addGame(game: game)
            self.showAlertMessage(title: "Bravo", message: "Tu as bien rajouté le jeu au catalogue. 🤖")
        }
    }
    
    @IBAction func ratingValue(_ sender: UISlider) {
        ratingValue.text = String(Int(sender.value))
    }
    
    private func everyElementAreFilled() -> Bool {
        if titleTextField.text != "", releaseDateTextField.text != "", gameImage.image != nil, ratingValue.text != "" {
            return true
        } else if (releaseDateTextField.text?.first?.isNumber ?? true) {
            return true
        } else {
            self.showAlertMessage(title: "Erreur détectée", message: "Tu as oublié un élement 🙀.")
            return false
        }
    }
}

extension FormViewController: UITextFieldDelegate, SendImageDelegate {
    func sendImage(imageStr: String) {
        imageUrl = imageStr
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return true
    }
}

