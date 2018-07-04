//
//  WorkthroughContentViewController.swift
//  FoodPin
//
//  Created by 许有红 on 2018/6/29.
//  Copyright © 2018 EmptyWlaker. All rights reserved.
//

import UIKit

class WorkthroughContentViewController: UIViewController {

    @IBOutlet weak var subheadLabel: UILabel! {
        didSet {
            subheadLabel.numberOfLines = 0
        }
    }
    @IBOutlet weak var headLabel: UILabel! {
        didSet {
            headLabel.numberOfLines = 0
        }
    }
    @IBOutlet weak var contentImageView: UIImageView!
    
    
    var index = 0
    var imageFile = ""
    var heading = ""
    var subheading = ""
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentImageView.image = UIImage(named: imageFile)
        headLabel.text = heading
        subheadLabel.text = subheading
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
