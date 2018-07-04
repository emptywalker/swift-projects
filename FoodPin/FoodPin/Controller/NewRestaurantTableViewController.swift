//
//  NewRestaurantTableViewController.swift
//  FoodPin
//
//  Created by 许有红 on 2018/6/25.
//  Copyright © 2018 EmptyWlaker. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class NewRestaurantTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    var name: String?
    var type: String?
    var address: String?
    var phone: String?
    var restaurant: RestaurantMO!
    
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.delegate = self
            descriptionTextView.layer.cornerRadius = 5.0
            descriptionTextView.clipsToBounds = true
            descriptionTextView.tag = 5
        }
    }
    @IBOutlet weak var phoneTextField: RoundedTextField! {
        didSet {
            phoneTextField.delegate = self
            phoneTextField.tag = 4
        }
    }
    @IBOutlet weak var typeTextField: RoundedTextField! {
        didSet {
            typeTextField.delegate = self
            typeTextField.tag = 2
        }
    }
    @IBOutlet weak var nameTextField: RoundedTextField! {
        didSet {
            nameTextField.delegate = self
            nameTextField.tag = 1
        }
    }
    @IBOutlet weak var addressTextField: RoundedTextField! {
        didSet {
            addressTextField.delegate = self
            addressTextField.tag = 3
        }
    }
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure navigation bar appearance
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        if let customFont = UIFont(name: "Rubik-Medium", size: 35.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red: 231, green: 76, blue: 60), NSAttributedStringKey.font: customFont]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = self.view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            name = textField.text
        case 2:
            type = textField.text
        case 3:
            address = textField.text
        case 4:
            phone = textField.text
        default:
            fatalError("no textfield exsit!")
        }
    }

    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
            
            let camermaAction = UIAlertAction(title: NSLocalizedString("Camerma", comment: "Camerma"), style: .default) { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.sourceType = .camera
                    imagePicker.allowsEditing = true
                    imagePicker.delegate = self
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
            
            let photoLibraryAction = UIAlertAction(title: NSLocalizedString("Photo library", comment: "Photo library"), style: .default) { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.allowsEditing = false
                    imagePicker.delegate = self
                    self.present(imagePicker, animated: true, completion: nil)
                    
                }
            }
            
            photoSourceRequestController.addAction(camermaAction)
            photoSourceRequestController.addAction(photoLibraryAction)
            
            present(photoSourceRequestController, animated: true, completion: nil)
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
        }
        layoutPhotoImageView()
        dismiss(animated: true, completion: nil)
    }
    
    // MRAK: - Set up
    func layoutPhotoImageView() {
        let leadingConstraint = NSLayoutConstraint(item: photoImageView, attribute: .leading, relatedBy:.equal , toItem: photoImageView.superview, attribute: .leading, multiplier: 1.0, constant: 0)
        leadingConstraint.isActive = true
        
        let trailingConstraint = NSLayoutConstraint(item: photoImageView, attribute: .trailing, relatedBy: .equal, toItem: photoImageView.superview, attribute: .trailing, multiplier: 1.0, constant: 0)
        trailingConstraint.isActive = true
        
        let topConstraint = NSLayoutConstraint(item: photoImageView, attribute: .top, relatedBy: .equal, toItem: photoImageView.superview, attribute: .top, multiplier: 1.0, constant: 0)
        topConstraint.isActive = true
        
        let bottomConstraint = NSLayoutConstraint(item: photoImageView, attribute: .bottom, relatedBy: .equal, toItem: photoImageView.superview, attribute: .bottom, multiplier: 1.0, constant: 0)
        bottomConstraint.isActive = true
        
    }
    // MARK: Actions
    
    @IBAction func saveActions(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        
        let alertController = UIAlertController(title: "Oops", message: "We can't proceed because ont of the fields is blank. Please note that all fileds are required.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        guard let name = name else {
            present(alertController, animated: true, completion: nil)
            return
        }
        guard let type = type else {
            present(alertController, animated: true, completion: nil)
            return
        }
        guard let address = address else {
            present(alertController, animated: true, completion: nil)
            return
        }
        guard let phone = phone else {
            present(alertController, animated: true, completion: nil)
            return
        }
        
        // Persistent restaurant
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            restaurant = RestaurantMO(context: appDelegate.persistentContainer.viewContext)
            restaurant.name = name
            restaurant.type = type
            restaurant.location = address
            restaurant.phone = phone
            restaurant.summary = descriptionTextView.text
            restaurant.isVisited = false
            if let restaurantImage = photoImageView.image {
                restaurant.image = UIImagePNGRepresentation(restaurantImage)
            }
            
            saveRecordToCloud(restaurant: restaurant)
            
            print("Saving data to context ...")
            appDelegate.saveContext()
        }
        
        
//        let info = ["Name": name, "Type": type, "Location": address, "Phone": phone, "Despription": descriptionTextView.text] as [String : Any]
//        print(info)
        dismiss(animated: true, completion: nil)
//        performSegue(withIdentifier: "unwindToHome", sender: self)
    }
    
    // MARK: - Private methods
    
    func saveRecordToCloud(restaurant: RestaurantMO!) -> Void {
        // Prepare the record to save
        let record = CKRecord(recordType: "Restaurant")
        record.setValue(restaurant.name, forKey: "name")
        record.setValue(restaurant.type, forKey: "type")
        record.setValue(restaurant.location, forKey: "location")
        record.setValue(restaurant.phone, forKey: "phone")
        record.setValue(restaurant.summary, forKey: "description")
        
        let imageData = restaurant.image! as Data
        
        // Resize the image
        let originalImage = UIImage(data: imageData)!
        let scalingFactor = (originalImage.size.width > 1024) ? 1024 / originalImage.size.width : 1.0
        let scaledImage = UIImage(data: imageData, scale: scalingFactor)!
        
        // Write the image to local file for temporary use
        let imageFilePath = NSTemporaryDirectory() + restaurant.name!
        let imageFileURL = URL(fileURLWithPath: imageFilePath)
        try? UIImageJPEGRepresentation(scaledImage, 0.8)?.write(to: imageFileURL)
        
        // Created image to upload
        let imageAsset = CKAsset(fileURL: imageFileURL)
        
        record.setValue(imageAsset, forKey: "image")
        
        // Get the Public iCloud Database
        let publicDatabase = CKContainer.default().publicCloudDatabase
        
        // Save the record to iCloud
        publicDatabase.save(record) { (record, error) in
            // Remove temp file
            try? FileManager.default.removeItem(at: imageFileURL)
            
            print("Complete record upload: \(String(describing: error?.localizedDescription))")
        }
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
