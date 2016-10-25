//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Myadam, Sasikiran on 10/18/16.
//  Copyright © 2016 Myadam, Sasikiran. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var errorMessage: UIView!
    var movies: [NSDictionary]?
    //var refreshControl: UIRefreshControl
    var endpoint: String = "now_playing"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.errorMessage.hidden = true

        tableView.dataSource = self
        tableView.delegate = self
        
        loadDataAsync()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MoviesViewController.refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        // Do any additional setup after loading the view.
        /*let apiKey="a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: {(dataOrNil, response,
                error) in
                if let data = dataOrNil{
                    if let responseDictionary = try!
                    NSJSONSerialization.JSONObjectWithData(data,
                    options: []) as? NSDictionary
                    {
                        self.movies = responseDictionary["results"] as? [NSDictionary]
                        self.tableView.reloadData()
                    //print("response: \(responseDictionary)")
                    }
                }
            });
            task.resume()
         */
   
        
        
        
    }
    
    func loadDataAsync(){
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let myRequest = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(myRequest,
                   completionHandler: { (dataOrNil, response, error) in
                   // Hide HUD once the network request comes back
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                   // json parsing
                   if let data = dataOrNil {
                       if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                               data, options:[]) as? NSDictionary {
                                self.movies = responseDictionary["results"] as? [NSDictionary]
                                 dispatch_async(dispatch_get_main_queue(), {self.tableView.reloadData()})
                    }
                   }else{
                    self.errorMessage.hidden = false
                    }
                    
        });
        task.resume()
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl){
        loadDataAsync()
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if let movies = movies{
            return movies.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        if let posterPath = movie["poster_path"] as? String{
            let baseUrl = "https://image.tmdb.org/t/p/w500"
            let imageUrl = NSURL(string: baseUrl + posterPath)
            cell.posterView.setImageWithURL(imageUrl!)
        }

        
        
        //cell.textLabel!.text = "\(title)"
        //print("row \(indexPath.row)")
        return cell
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //print("prepare for segue called")
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = movie
    }
    

}
