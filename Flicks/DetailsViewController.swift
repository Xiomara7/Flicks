//
//  DetailsViewController.swift
//  Flicks
//
//  Created by Xiomara on 10/15/16.
//  Copyright © 2016 Xiomara. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(
            width: scrollView.frame.size.width,
            height: infoView.frame.origin.y + infoView.frame.size.height
        )
        
        let baseURL = "https://image.tmdb.org/t/p/w342"
        
        if let posterPath = movie["poster_path"] as? String {
            let imageStr = baseURL + posterPath
            let imageURL = URL(string: imageStr)
            
            let imageRequest = NSURLRequest(url: imageURL!)
            
            posterImageView.setImageWith(
                imageRequest as URLRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        self.posterImageView.alpha = 0.0
                        self.posterImageView.image = image
                        
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            self.posterImageView.alpha = 1.0
                        })
                    } else {
                        self.posterImageView.image = image
                    }
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    self.posterImageView.image = nil
                }
            )
        } else {
            posterImageView.image = nil
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
