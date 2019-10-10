//
//  MemeDetailsViewController.swift
//  MemeMe 2.0
//
//  Created by Abdullah AlBargi on 10/10/2019.
//  Copyright © 2019 Abdullah AlBargi. All rights reserved.
//

import UIKit

class MemeDetailsViewController: UIViewController {

    @IBOutlet weak var memeImage: UIImageView!
    
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        memeImage.image = meme.memeImage
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
