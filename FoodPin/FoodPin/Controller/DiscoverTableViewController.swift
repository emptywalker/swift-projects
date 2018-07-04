//
//  DiscoverTableViewController.swift
//  FoodPin
//
//  Created by 许有红 on 2018/6/29.
//  Copyright © 2018 EmptyWlaker. All rights reserved.
//

import UIKit
import CloudKit
import Foundation

class DiscoverTableViewController: UITableViewController {

    // MARK: - Properties
    var restaurants: [CKRecord] = []
    var spinner = UIActivityIndicatorView()
    
    
    
    // MARK: - Private properties
    private var imageCache = NSCache<CKRecordID, NSURL>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.cellLayoutMarginsFollowReadableWidth = true
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        if let customFont = UIFont(name: "Rubik-Medium", size: 40.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red: 231, green: 76, blue: 60),NSAttributedStringKey.font: customFont]
        }
        tableView.tableFooterView = UIView()
//        tableView.rowHeight = 516
        
        addSpinner()
        
        fetchRecordFromCloud()
        addPullToRefreshControl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup UI
    func addSpinner() {
        spinner.activityIndicatorViewStyle = .gray
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        
        // Define layout constraints for the spinner
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([spinner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150.0), spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0)])
        spinner.startAnimating()
    }
    
    func addPullToRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = .white
        refreshControl?.tintColor = .gray
        refreshControl?.addTarget(self, action: #selector(fetchRecordFromCloud), for: .valueChanged)
    }
    
    // MARK: - Fetch Data
    @objc func fetchRecordFromCloud() {
        // Remove existing records before refreshing
        restaurants.removeAll()
        tableView.reloadData()
        
        let cloudContainer = CKContainer.default()
        let publicDataBase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        
        // Fetch data use operation API
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name", "type", "location", "phone", "description"]
        queryOperation.queuePriority = .veryHigh
        queryOperation.resultsLimit = 50
        queryOperation.recordFetchedBlock = { (record) -> Void in
            self.restaurants.append(record)
        }
        queryOperation.queryCompletionBlock = { (cursor, error) -> Void in
            if let error = error {
                print("Failed to get data from iCloud - \(error.localizedDescription)")
                return
            }
            print("Successfully retrieve data from iCloud")
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.tableView.reloadData()
                if let refreshControl = self.refreshControl {
                    if refreshControl.isRefreshing {
                        refreshControl.endRefreshing()
                    }
                }
            }
        }
        // Execute the query
        publicDataBase.add(queryOperation)
        
        
        // Fetch data use convenience API
//        publicDataBase.perform(query, inZoneWith: nil) { (results, error) in
//            if let error = error {
//                print(error)
//                return
//            }
//            if let results = results {
//                print("Completed the download of Restaurant data")
//                self.restaurants = results
//                DispatchQueue.main.sync {
//                    self.tableView.reloadData()
//                }
//
//            }
//        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurants.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverCell", for: indexPath) as! DiscoverTableViewCell
        
        let restaurant = restaurants[indexPath.row]
        
        // Configure the cell...
        cell.nameLabel.text = restaurant.object(forKey: "name") as? String
        cell.typeLabel.text = restaurant.object(forKey: "type") as? String
        cell.locationLabel.text = restaurant.object(forKey: "location") as? String
        cell.phoneLabel.text = restaurant.object(forKey: "phone") as? String
        cell.descriptionLabel.text = restaurant.object(forKey: "description") as? String
//        if let image = restaurant.object(forKey: "image"), let imageAsset = image as? CKAsset {
//            if let imageData = try? Data.init(contentsOf: imageAsset.fileURL) {
//                cell.imageView?.image = UIImage(data: imageData)
//            }
//        }
        
        cell.resturantImageView.image = UIImage(named: "photo")
        
        // Check if the image is stored in cache
        if let imageFileURL = imageCache.object(forKey: restaurant.recordID) {
            // Fetch image from cache
            print("Get image from cache with record id : \(restaurant.recordID)")
            if let imageData = try? Data.init(contentsOf: imageFileURL as URL) {
                cell.resturantImageView.image = UIImage(data: imageData)
//                cell.setNeedsLayout()
            }
        } else {
            
            let publicDataBase = CKContainer.default().publicCloudDatabase
            let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [restaurant.recordID])
            fetchRecordsImageOperation.desiredKeys = ["image"]
            fetchRecordsImageOperation.queuePriority = .high
            fetchRecordsImageOperation.perRecordCompletionBlock = { (record, recordID, error) -> Void in
                if let error = error {
                    print("Failed to get restaurant image: \(error.localizedDescription)")
                    return
                }
                if let restaurantRecord = record,
                    let image = restaurantRecord.object(forKey: "image"),
                    let imageAsset = image as? CKAsset {
                    if let imageData = try? Data.init(contentsOf: imageAsset.fileURL) {
                        DispatchQueue.main.async {
                            cell.resturantImageView.image = UIImage(data: imageData)
                            cell.setNeedsLayout()
                        }
                    }
                    // Add image url to cache
                    self.imageCache.setObject(imageAsset.fileURL as NSURL, forKey: restaurant.recordID)
                }
            }
            publicDataBase.add(fetchRecordsImageOperation)
        }

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
