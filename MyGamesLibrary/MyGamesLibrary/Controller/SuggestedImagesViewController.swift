//
//  SuggestedImagesViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 13/03/2022.
//

import UIKit
protocol SendImageDelegate {
    func sendImage(imageStr: String)
}

class SuggestedImagesViewController: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var suggestedImagesCollectionView: UICollectionView!
    
    
    var gameTitle: String = ""
    var gameImages = [String]()
    var delegate: SendImageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchSuggestion(title: gameTitle, images: gameImages) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.gameImages = result
                self.suggestedImagesCollectionView.reloadData()
                print(self.gameImages)
            }
        }
        suggestedImagesCollectionView.dataSource = self
        suggestedImagesCollectionView.delegate = self
        // Do any additional setup after loading the view.
    }

    private func fetchSuggestion(title: String, images : [String], completion: @escaping ([String]) -> Void) {
        var pics = images
        GameService.shared.fetchSearchGames(search: title) { result in
            switch result {
                case .success(let info):
                info.results?.forEach({ game in
                    pics.append(game.backgroundImage ?? "no title")
                })
               completion(pics)
                case .failure(let error):
                completion([])
                    print(error.description)
            }
        }
    }
    
    private func setup() {
        titleLabel.setMargins(margin: 10)
        titleLabel.layer.masksToBounds = true
        titleLabel.textAlignment = .center
        titleLabel.layer.cornerRadius = titleLabel.frame.height/2
    }
}

extension SuggestedImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func setupCollection() {
        suggestedImagesCollectionView.delegate = self
        suggestedImagesCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("==>\(gameImages.count)")
        return gameImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestedViewCell", for: indexPath) as! SuggestedViewCell
        cell.suggestedImage.cacheImage(urlString: gameImages[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width-20)/3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.sendImage(imageStr: gameImages[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
}
