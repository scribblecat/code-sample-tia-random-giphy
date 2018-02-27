//
//  ViewController.swift
//  CodeSample-Tia-Giphy
//
//  Created by sadie on 2/26/18.
//  Copyright © 2018 Sadie Contini. All rights reserved.
//

import UIKit

class RandomGiphyImagesVC: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var giphyImages = [GiphyImage]()
    var currentNumberOfCells = 0
    
    let initialFetchImageNumber = 12
    let scrollFetchImageNumber = 4
    
    let apiService = WebAPIService.shared
    
    var activeDownloadsUrlData = Dictionary<String, Data?>()
    
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration,
                          delegate: self,
                          delegateQueue: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchNewRandomGiphyImages(count: initialFetchImageNumber)
    }
    
    func fetchNewRandomGiphyImages(count: Int) {
        currentNumberOfCells += count

        for _ in 1...count {
            apiService.fetchRandomGiphyImage() {
                [weak self] (result: ApiResult) in
                switch result {
                case .success(let giphyImage):
                    self?.fetchImage(for: giphyImage)
                case .error(let error):
                    // TODO: handle error by switch statement
                    print(error.description)
                }
            }
        }
    }
    
    func fetchImage(for giphyImage: GiphyImage) {
        activeDownloadsUrlData[giphyImage.urlString] = nil
        if let url = giphyImage.url() {
            let task = downloadsSession.downloadTask(with: url)
            task.resume()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension RandomGiphyImagesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GiphyImageCell.self), for: indexPath) as! GiphyImageCell
        
        if indexPath.row < giphyImages.count {
            let giphyImage = giphyImages[indexPath.row]
            cell.backgroundColor = .clear
            cell.configure(with: giphyImage)
        } else {
            let colors: [UIColor] = [.purple, .green, .red, .blue, .yellow, .orange]
            let colorIndex = indexPath.row % colors.count
            cell.backgroundColor = colors[colorIndex]
        }
        
        // if we're at the end, get more!
        if indexPath.row == giphyImages.count - 1 {
            fetchNewRandomGiphyImages(count: scrollFetchImageNumber)
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentNumberOfCells
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension RandomGiphyImagesVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat =  20
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/2,
                      height: collectionViewSize/2)
    }
}

extension RandomGiphyImagesVC: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        if let urlString = downloadTask.currentRequest?.url?.absoluteString {
            
            // remove from active download
            if activeDownloadsUrlData[urlString] != nil  {
                activeDownloadsUrlData.removeValue(forKey: urlString)
            }
            // add to giphyImages
            let imageData = try! Data(contentsOf: location)
            giphyImages.append(GiphyImage(urlString: urlString,
                                          image: UIImage(data: imageData)))
            DispatchQueue.main.async {
                [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
}
