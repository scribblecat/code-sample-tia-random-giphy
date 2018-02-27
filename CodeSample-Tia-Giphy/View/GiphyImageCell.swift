//
//  GiphyImageCell.swift
//  CodeSample-Tia-Giphy
//
//  Created by sadie on 2/26/18.
//  Copyright © 2018 Sadie Contini. All rights reserved.
//

import UIKit

class GiphyImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        imageView?.image = nil
        super.prepareForReuse()
    }
    
    var giphyImage: GiphyImage! {
        didSet {
            imageView.image = giphyImage.image
        }
    }
    
    func configure(with giphyImage: GiphyImage) {
        self.giphyImage = giphyImage
    }
}
