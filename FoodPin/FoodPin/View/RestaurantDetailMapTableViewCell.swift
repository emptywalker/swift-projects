//
//  RestaurantDetailMapTableViewCell.swift
//  FoodPin
//
//  Created by 许有红 on 2018/6/22.
//  Copyright © 2018 EmptyWlaker. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailMapTableViewCell: UITableViewCell {

    @IBOutlet weak var mapView: MKMapView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(location: String) {
        // Get location
        let geoCoder = CLGeocoder()
        print(location)
        geoCoder.geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let placemarks = placemarks {
                // Get first placemark
                let placemark = placemarks[0]
                // Add a annotation
                let annotation = MKPointAnnotation()
                if let location = placemark.location {
                    //Display the annotation
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                    // Set the zoom level
                    let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 250, 250)
                    self.mapView.setRegion(region, animated: true)
                }
            }
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
