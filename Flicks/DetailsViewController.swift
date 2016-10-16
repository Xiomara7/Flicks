//
//  DetailsViewController.swift
//  Flicks
//
//  Created by Xiomara on 10/15/16.
//  Copyright © 2016 Xiomara. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    
    @IBOutlet var infoView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.size.height)
        
        let baseURL = "https://image.tmdb.org/t/p/w342"
        
        if let posterPath = movie["poster_path"] as? String {
            let imageStr = baseURL + posterPath
            let imageURL = URL(string: imageStr)
            
            posterImageView.setImageWith(imageURL!)
        }
        
        let title = movie["title"] as? String
        titleLabel.text = title
        
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
