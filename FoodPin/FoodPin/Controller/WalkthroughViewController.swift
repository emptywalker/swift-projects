
//
//  WalkthroughViewController.swift
//  FoodPin
//
//  Created by 许有红 on 2018/6/29.
//  Copyright © 2018 EmptyWlaker. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController, WalkthroughPageViewControllerDelegate {

    // MARK: - Properties
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.layer.cornerRadius = 5.0
            nextButton.clipsToBounds = true
        }
    }
    @IBOutlet weak var pageControl: UIPageControl!
    
    var walkthourghPageViewController: WalkthroughPageViewController?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Set up UI
    func updateUI() {
        if let index = walkthourghPageViewController?.currentIndex {
            switch index {
            case 0...1:
                nextButton.setTitle("NEXT", for: .normal)
                skipButton.isHidden = false
            case 2:
                nextButton.setTitle("GET STARTED", for: .normal)
                skipButton.isHidden = true
            default:
                break
            }
            pageControl.currentPage = index
        }
    }
    // MARK: - WalkthroughPageViewControllerDelegate
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
    
    // MARK: - Actions

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if let index = walkthourghPageViewController?.currentIndex {
            switch index {
            case 0...1:
                walkthourghPageViewController?.forwardPage()
            case 2:
                dismissWalkthroughViewController()
            default:
                break
            }
        }
        updateUI()
    }
    
    @IBAction func skipButtonTapped(_ sender: UIButton) {
        dismissWalkthroughViewController()
    }
    
    
    // MARK: - Private Methods
    func dismissWalkthroughViewController() {
        UserDefaults.standard.set(true, forKey: "hasWalkthroughViewController")
        createQuickActions()
        dismiss(animated: true, completion: nil)
    }
    
    func createQuickActions() {
        // Add Quick Actions
        if traitCollection.forceTouchCapability == .available {
            if let bundleIdentifier = Bundle.main.bundleIdentifier {
                let shortcutItem1 = UIApplicationShortcutItem(type: "\(bundleIdentifier).OpenFavorites", localizedTitle: NSLocalizedString("Show Favorites", comment: "Show Favorites"), localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "favorite"), userInfo: nil)
                
                let shortcutItem2 = UIApplicationShortcutItem(type: "\(bundleIdentifier).OpenDiscover", localizedTitle: NSLocalizedString("Disvcoer Restaurant", comment: "Disvcoer Restaurant"), localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "discover"), userInfo: nil)
                
                let shortcutItem3 = UIApplicationShortcutItem(type: "\(bundleIdentifier).NewRestaurant", localizedTitle: NSLocalizedString("New Restaurant", comment: "New Restaurant"), localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: .add), userInfo: nil)
                
                UIApplication.shared.shortcutItems = [shortcutItem1, shortcutItem2, shortcutItem3]
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pageViewController = segue.destination as? WalkthroughPageViewController {
            walkthourghPageViewController = pageViewController
            walkthourghPageViewController?.walkthroughDelegate = self
        }
    }
    

}
