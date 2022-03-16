//
//  MyGameViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 15/03/2022.
//

import UIKit

class MyGameViewController: UIViewController {

    @IBOutlet weak var backBTN: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    
    @IBOutlet weak var ratingStack: UIStackView!
    @IBOutlet weak var marketBTN: UIButton!
    @IBOutlet weak var videoWebBTN: UIButton!
    
    @IBOutlet weak var heart1: UIImageView!
    @IBOutlet weak var heart2: UIImageView!
    @IBOutlet weak var heart3: UIImageView!
    @IBOutlet weak var heart4: UIImageView!
    @IBOutlet weak var heart5: UIImageView!
    
    var myGame: MyGame?
    private var ratingViews = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MyWebPage", let next = segue.destination as? WebViewController {
            next.url = sender as? String
        }
    }
    
    override func viewDidLayoutSubviews() {
        backgroundImage.addGradientLayerInBackground(frame: backgroundImage.bounds, colors: [UIColor(ciColor: .clear), UIColor(ciColor: .white)])
    }
    
    
    
   private func setupUI() {
       guard let myGameCard = myGame else { return }
       guard let dataImage = myGameCard.backgroundImage else { return }
       backgroundImage.downloaded(from: String(decoding: dataImage, as: UTF8.self))
       gameImage.downloaded(from: String(decoding: dataImage, as: UTF8.self))
       gameImage.layer.borderColor = UIColor.white.cgColor
       gameImage.layer.borderWidth = 3
       gameImage.layer.cornerRadius = 20
       
       gameTitle.text = myGameCard.name
       releaseDate.text = myGameCard.release_date
       setRating(for: myGameCard.rating)
       
       videoWebBTN.layer.borderWidth = 3
       videoWebBTN.layer.borderColor = UIColor.black.cgColor
       videoWebBTN.layer.cornerRadius = 20
       gameTitle.layer.masksToBounds = true
       gameTitle.layer.cornerRadius = 20
       gameTitle.setMargins()
       gameTitle.textAlignment = .center
       marketBTN.layer.cornerRadius = 20
       ratingStack.translatesAutoresizingMaskIntoConstraints = false
       backgroundImage.backgroundImage(view: self.view, multiplier: 0.60)
    }
    
    
    private func setUpHeart() {
        ratingViews = [heart1, heart2, heart3, heart4, heart5]
        ratingViews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.image = UIImage(systemName: "heart.fill")
            $0.sizeThatFits(CGSize(width: 8, height: 8))
            $0.contentMode = .scaleAspectFit
        }
    }
    
    //MARK: SetUp and method for update the rating star for each destination.
    //condition to change the star's shape according to the rating
    func setRating(for star : Double) {
        setUpHeart()
        let rating = Int(star)
        switch rating {
        case 0:
            heart1.image = UIImage(systemName: "heart")
            heart2.image = UIImage(systemName: "heart")
            heart3.image = UIImage(systemName: "heart")
            heart4.image = UIImage(systemName: "heart")
            heart5.image = UIImage(systemName: "heart")
        case 1:
            heart2.image = UIImage(systemName: "heart")
            heart3.image = UIImage(systemName: "heart")
            heart4.image = UIImage(systemName: "heart")
            heart5.image = UIImage(systemName: "heart")
            
        case 2:
            heart3.image = UIImage(systemName: "heart")
            heart4.image = UIImage(systemName: "heart")
            heart5.image = UIImage(systemName: "heart")
        case 3:
            heart4.image = UIImage(systemName: "heart")
            heart5.image = UIImage(systemName: "heart")
        case 4:
            heart5.image = UIImage(systemName: "heart")
            
        default:
            break
        }
    }
    
    @IBAction func dismissBTN(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func marketAction(_ sender: Any) {
        let gameUrl = "https://ledenicheur.fr/search?search=\(myGame?.name?.replacingOccurrences(of: " ", with: "%20") ?? "no url")"
        performSegue(withIdentifier: "MyWebPage", sender: gameUrl)
    }
    
    @IBAction func videoWebAction(_ sender: Any) {
        let gameUrl = "https://www.youtube.com/results?search_query=\(myGame?.name?.replacingOccurrences(of: " ", with: "+") ?? "no url")"
        performSegue(withIdentifier: "MyWebPage", sender: gameUrl)
    }
}
