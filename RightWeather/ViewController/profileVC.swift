//
//  profileVC.swift
//  RightWeather
//
//  Created by Alphabit Technologies on 25/06/18.
//  Copyright © 2018 alphabit tech. All rights reserved.
//

import UIKit
import CoreData

class profileVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var txtFirstname: UITextField!
    
    @IBOutlet weak var txtLastName: UITextField!
    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    var picker:UIImagePickerController?=UIImagePickerController()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var coreDataProvider : CoreDataProvider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSave.layer.cornerRadius = 8
        btnSave.layer.borderColor = UIColor.black.cgColor
        btnSave.layer.borderWidth = 1.0
        picker?.delegate = self
        imgProfile.layer.cornerRadius = imgProfile.frame.width / 2
        imgProfile.layer.borderWidth = 1.0
        imgProfile.clipsToBounds = true
        imgProfile.layer.borderColor = UIColor.lightGray.cgColor
        
        configureuserList()
        
        
            let user = coreDataProvider.getUserDetails()
            if user != nil {
            let objImage = self.getImageFromDocumentDirectory(image_name: (user?.image!)!, dirName: "UPLOADS")
            imgProfile.image = objImage
            txtFirstname.text = user?.first_name
            txtLastName.text = user?.last_name
        }
        
            
        
        
        // Do any additional setup after loading the view.
    }
    
    func configureuserList() {
        self.coreDataProvider =  CoreDataProvider.sharedList
        self.coreDataProvider.initDataSourceForList(user_id: "1")
    }
    
    
    
    //MARK:- Button Actions
    
    
    @IBAction func btnProfileOnClick(_ sender: Any) {
        
        let actionCamera: UIAlertController = UIAlertController(title: "Please select Option", message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Gallary", style: .default) { _ in
            self.openGallary()
        }
        actionCamera.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: "Camera", style: .default)
        { _ in
            self.openCamera()
        }
        actionCamera.addAction(saveActionButton)
        
        let cancelbtn = UIAlertAction(title: "Cancel", style: .cancel)
        { _ in
            
        }
        actionCamera.addAction(cancelbtn)
        
        self.present(actionCamera, animated: true, completion: nil)
        
        
    }
    
    //MARK:- Image picker accessing
    
    func openGallary()
    {
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(picker!, animated: true, completion: nil)
        
    }
    
    func openCamera()
    {
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker!.allowsEditing = false
            picker!.sourceType = UIImagePickerControllerSourceType.camera
            picker!.cameraCaptureMode = .photo
            present(picker!, animated: true, completion: nil)
            }else{
            let alert = UIAlertController(title:"Camera Not Found", message:"This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title:"OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let chooseimg = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgProfile.contentMode = .scaleAspectFit
            imgProfile.image = chooseimg
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnBackArrowOnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnSaveOnClick(_ sender: Any) {
        
        
        if txtFirstname.text == "" {
            alertviewwithmsg(strmsg: "Please enter frist name")
        }
        else if txtLastName.text == "" {
            alertviewwithmsg(strmsg: "Please enter last name")
        }
        else if imgProfile.image == nil {
            alertviewwithmsg(strmsg: "Please select profile pic")
        }
        else{
             view.endEditing(true)
             let user = coreDataProvider.getUserDetails()
            
            if user == nil {
                 saveData(image: imgProfile.image!)
            }
            else{
                updated(image: imgProfile.image!)
            }
           
        }
        
    }
    
    func saveData(image : UIImage)
    {
        let user = User.createInContext(context: CoreDataProvider.sharedDataManager.managedObjectContext)
        user.first_name = txtFirstname.text
        user.last_name = txtLastName.text
        user.expiry_date = ""
        user.creadit_card = ""
        user.user_id = "1"
        let name = "\((Date().timeIntervalSince1970))".replacingOccurrences(of: ".", with: "")
        user.image = name
        _ = self.saveImageToDocumentDirectory(image: image, dirName: "UPLOADS", file_name: name)
        CoreDataProvider.sharedDataManager.saveContext()
        
    }
    
    func updated(image : UIImage)
    {
        let user = coreDataProvider.getUserDetails()
        user?.first_name = txtFirstname.text
        user?.last_name = txtLastName.text
        let name = "\((Date().timeIntervalSince1970))".replacingOccurrences(of: ".", with: "")
        user?.image = name
        _ = self.saveImageToDocumentDirectory(image: image, dirName: "UPLOADS", file_name: name)
        CoreDataProvider.sharedDataManager.saveContext()
    }
    
    
    //MARK:- UIAlert view displaying
    
    
    func alertviewwithmsg(strmsg:String) {
        let alrtvw = UIAlertView.init(title: "", message: strmsg, delegate: nil, cancelButtonTitle: "Ok")
        alrtvw.show()
        
    }
    
    
    //MARK:- image Uploadfing
    
    
    func getImageFromDocumentDirectory(image_name : String,dirName: String) -> UIImage?
    {
        let paths = self.getImagePath(image_name, dirName: dirName) + ".jpg"
        let imageURL = URL(fileURLWithPath: paths)
        let image    = UIImage(contentsOfFile: imageURL.path)
        return image
    }
    
    func getImagePath(_ imageName: String, dirName: String) -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.appendingPathComponent(dirName+"/"+imageName)?.path
        return filePath!
    }
    func saveImageToDocumentDirectory(image: UIImage, dirName: String,file_name : String) -> URL? {
        let URLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = URLs[0] as URL
        
        let fileName = file_name
        let dataPath = documentsDirectory.appendingPathComponent(dirName)
        
        do {
            try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("Error creating directory: \(error.localizedDescription)")
        }
        
        let destinationURL = dataPath.appendingPathComponent(fileName + ".jpg")
        print(destinationURL)
        
        do {
            try FileManager.default.removeItem(at: destinationURL)
        } catch let error as NSError {
            print(error)
        }
        
        do {
            if let imageData = UIImageJPEGRepresentation(image, 1) {
                try imageData.write(to: destinationURL)
                return destinationURL
            }
        } catch let error as NSError {
            print(error)
        }
        
        return nil
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
