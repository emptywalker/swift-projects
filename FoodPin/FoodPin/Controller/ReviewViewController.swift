//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by 许有红 on 2018/6/25.
//  Copyright © 2018 EmptyWlaker. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var rateButtons: [UIButton]!
    var restaurant: RestaurantMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let restaurantImageData = restaurant.image {
            backgroundImageView.image = UIImage(data: restaurantImageData)
        }
        // Applying the blur effect
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
//        let moveRightTransform = CGAffineTransform(translationX: 600, y: 0)
        let scaleUpTransform = CGAffineTransform(scaleX: 5.0, y: 5.0)
//        let moveScaleTransform = moveRightTransform.concatenating(scaleUpTransform)
        for button in rateButtons {
            button.transform = scaleUpTransform
            button.alpha = 0
        }
        
        let moveTopTransform = CGAffineTransform(translationX: 0, y: 80)
        backButton.transform = moveTopTransform
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Solution 1:
        
//        UIView.animate(withDuration: 2.0) {
//            self.rateButtons[0].alpha = 1
//            self.rateButtons[1].alpha = 1
//            self.rateButtons[2].alpha = 1
//            self.rateButtons[3].alpha = 1
//            self.rateButtons[4].alpha = 1
//        }
//        UIView.animate(withDuration: 0.5, delay: 0.5, options: [], animations: {
//            self.rateButtons[0].alpha = 1
//            self.rateButtons[0].transform = .identity
//        }, completion: nil)
        
        // Solution 2:
//        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: [], animations: {
//            self.rateButtons[0].alpha = 1
//            self.rateButtons[0].transform = .identity
//        }, completion: nil)
//        UIView.animate(withDuration: 0.5, delay: 1.0, options: [], animations: {
//            self.rateButtons[1].alpha = 1
//            self.rateButtons[1].transform = .identity
//        }, completion: nil)
//        UIView.animate(withDuration: 0.5, delay: 1.5, options: [], animations: {
//            self.rateButtons[2].alpha = 1
//            self.rateButtons[2].transform = .identity
//        }, completion: nil)
//        UIView.animate(withDuration: 0.5, delay: 2.0, options: [], animations: {
//            self.rateButtons[3].alpha = 1
//            self.rateButtons[3].transform = .identity
//        }, completion: nil)
//        UIView.animate(withDuration: 0.5, delay: 2.5, options: [], animations: {
//            self.rateButtons[4].alpha = 1
//            self.rateButtons[4].transform = .identity
//        }, completion: nil)
        
        // Solution 3:
        for index in 0 ..< rateButtons.count {
            let delay = 0.5 * (Double(index) + 1.0)
            UIView.animate(withDuration: 0.5, delay: delay, options: [], animations: {
                self.rateButtons[index].alpha = 1
                self.rateButtons[index].transform = .identity
            }, completion: nil)
        }
        
        // backButton animate
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: [], animations: {
            self.backButton.transform = .identity
        }, completion: nil)
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
