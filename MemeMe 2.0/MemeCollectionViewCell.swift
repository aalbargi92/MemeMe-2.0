//
//  MemeCollectionViewCell.swift
//  MemeMe 2.0
//
//  Created by Abdullah AlBargi on 10/10/2019.
//  Copyright © 2019 Abdullah AlBargi. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var memeTitle: UILabel!
    
    func setup(with meme: Meme) {
        memeImage.image = meme.memeImage
        memeTitle.text = "\(meme.topText) \(meme.bottomText)"
    }
}
