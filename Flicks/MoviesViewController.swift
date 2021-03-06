//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Xiomara on 10/12/16.
//  Copyright © 2016 Xiomara. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    var endpoint: String!
    var refreshControl: UIRefreshControl!
    var showErrorMessage: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(refreshControlAction(refreshControl:)),
            for: .valueChanged
        )
        tableView.insertSubview(refreshControl, at: 0)
        
        self.getMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        self.getMovies()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if showErrorMessage {
            return 34.0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if showErrorMessage {
            let errorView = UIView()
            errorView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            
            let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 328.0, height: 34.0))
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.text = "Network Error"
            
            errorView.addSubview(label)
            
            return errorView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        let baseURL = "https://image.tmdb.org/t/p/w342"
        
        if let posterPath = movie["poster_path"] as? String {
            let imageStr = baseURL + posterPath
            let imageURL = URL(string: imageStr)
            
            let imageRequest = NSURLRequest(url: imageURL!)
            
            cell.posterImageView.setImageWith(
                imageRequest as URLRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        cell.posterImageView.alpha = 0.0
                        cell.posterImageView.image = image
                        
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            cell.posterImageView.alpha = 1.0
                        })
                    } else {
                        cell.posterImageView.image = image
                    }
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    cell.posterImageView.image = nil
                }
            )
        } else {
            cell.posterImageView.image = nil
        }
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies?[indexPath.row]
        
        let detailsViewController = segue.destination as! DetailsViewController
        detailsViewController.movie = movie
    }
    
    func getMovies() {
        let clientId = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(clientId)")
        
        let request = NSURLRequest(url: url! as URL)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task: URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                
                // Hide HUD once the network request comes back
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if let _ = error {
                    self.showErrorMessage = true
                    
                } else if let requestData = data {
                    self.showErrorMessage = false
                    
                    if let dict = try! JSONSerialization.jsonObject(
                        with: requestData,
                        options: []
                        
                        ) as? NSDictionary {
                        self.movies = dict["results"] as? [NSDictionary]
                        
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                    }
                }
            }
        );
        task.resume()
    }
}
