//
//  PurchasepremiumVC.swift
//  RightWeather
//
//  Created by Alphabit Technologies on 25/06/18.
//  Copyright © 2018 alphabit tech. All rights reserved.
//

import UIKit
import MapKit

class PurchasepremiumVC: UIViewController,UITextFieldDelegate {
    
    
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var btnCamera: UIButton!
    
    @IBOutlet weak var txtLocation1: UITextField!
    
    @IBOutlet weak var txtLocation2: UITextField!
    
    @IBOutlet weak var btnCompare: UIButton!
    
    @IBOutlet weak var mkmap: MKMapView!
    
    @IBOutlet weak var heightOfvw: NSLayoutConstraint!
    
    @IBOutlet weak var lbltemp1: UILabel!
    
    @IBOutlet weak var lblPressure1: UILabel!
    
    @IBOutlet weak var lblHumidity1: UILabel!
    
    @IBOutlet weak var lblWindspeed1: UILabel!
    
    @IBOutlet weak var lblClouds1: UILabel!
    @IBOutlet weak var lblWeather1: UILabel!
    
    
    @IBOutlet weak var lblTemp2: UILabel!
    
    @IBOutlet weak var lblPressure2: UILabel!
    
    @IBOutlet weak var lblHumidy2: UILabel!
    
    @IBOutlet weak var lblWindspeed2: UILabel!
    
    @IBOutlet weak var lblClouds2: UILabel!
    
    @IBOutlet weak var lblWeather2: UILabel!
    
    @IBOutlet weak var heightVwcompare: NSLayoutConstraint!
    
    @IBOutlet weak var vwcompare1: UIView!
    
    @IBOutlet weak var vwcompare2: UIView!
    
    @IBOutlet weak var vwLoader: UIView!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var btnNewalert: UIButton!
    
    @IBOutlet weak var vwcompare: UIView!
    
    @IBOutlet weak var lblCity: UILabel!
    
    @IBOutlet weak var lblCity2: UILabel!
    
    
    
    var weatherAPI = OWMWeatherAPI()
    var dateFormatter = DateFormatter()
    var LocationCoord1 = CLLocationCoordinate2D()
    var LocationCoord2 = CLLocationCoordinate2D()
    
    let BaseGoogleUrl = "https://maps.googleapis.com/maps/api/geocode/json"
    let API_KEY = "AIzaSyAj1zYN_aAZuJjpmUJh2exNZi_Wb_IqoF8"
    
    
    var picker:UIImagePickerController?=UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        // Do any additional setup after loading the view.
    }
    
    func setUpData()  {
        
        vwLoader.isHidden = true
        imgProfile.layer.cornerRadius = imgProfile.frame.width / 2
        imgProfile.layer.borderColor = UIColor.lightGray.cgColor
        imgProfile.layer.borderWidth = 1.0
        imgProfile.clipsToBounds = true
        
        
        btnNewalert.layer.cornerRadius = 8
        btnNewalert.layer.borderColor = UIColor.lightGray.cgColor
        btnNewalert.layer.borderWidth = 1.0
        btnNewalert.clipsToBounds = true
        
        vwcompare.layer.cornerRadius = 6
        vwcompare.layer.borderColor = UIColor.lightGray.cgColor
        vwcompare.layer.borderWidth = 1.0
        vwcompare.clipsToBounds = true

        
        
        
        let dateComponents = "H:m yyMMMMd"
        let dateFormat = DateFormatter.dateFormat(fromTemplate: dateComponents, options: 0, locale: Locale.current)
        dateFormatter.dateFormat = dateFormat
        weatherAPI = OWMWeatherAPI.init(apiKey: "748999a5f6403380ce2d5e7b4e98ea63")
        weatherAPI.setLangWithPreferedLanguage()
        weatherAPI.setTemperatureFormat(kOWMTempCelcius)

        
        //        btnCompare.layer.cornerRadius = 4
        //        btnCompare.clipsToBounds = true
        //        btnCompare.layer.borderWidth = 1.0
        //        btnCompare.layer.borderColor = UIColor.lightGray.cgColor
        
        heightVwcompare.constant = 132
        heightOfvw.constant = 0
        vwcompare1.isHidden = true
        vwcompare2.isHidden = true
        
        btnCompare.backgroundColor = UIColor(red: 0.0/255.0, green: 124.0/255.0, blue: 195.0/255.0, alpha: 0.25)
        btnCompare.isUserInteractionEnabled = false
    }
    
    
    //MARK:- Button Actions
    
    @IBAction func btnBackOnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnCameraOnClick(_ sender: Any) {
        openCamera()
    }
    
    @IBAction func btnCompareOnClick(_ sender: Any) {
        
        webcallGetLocationBasedOnGecoding(textlocation: txtLocation1.text!, isfirst: true)
        
        
        
        
    }
    @IBAction func btnNewsAlertOnClick(_ sender: Any) {
        self.performSegue(withIdentifier: "pushnewalertVc", sender: self)
    }
    
    //MARK:- imagepicker Delegate methods
    
    
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
            btnCamera.setTitle("", for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtLocation1 {
            
            if range.location > 6 {
                return false
            }
            
        }
        else{
            
            if range.location > 6 {
                return false
            }
            
        }
        
        
        return true
    }
    
    
    @IBAction func txtLocation2didchanges(_ sender: Any) {
        
        if validZipCode(POSTAL: txtLocation2.text!) {
            // correct password
            if validZipCode(POSTAL: txtLocation1.text!) {
                btncomprecolorActive()
            }
            else{
                btncompareInActive()
            }
        }
        else {
            btncompareInActive()
        }
    }
    
    @IBAction func txtLocation1Didchanges(_ sender: Any) {
        if validZipCode(POSTAL: txtLocation1.text!) {
            if validZipCode(POSTAL: txtLocation2.text!) {
                btncomprecolorActive()
            }
            else{
                btncompareInActive()
            }
        }
        else {
            btncompareInActive()
        }
        
    }
    
    
    func btncomprecolorActive()  {
        btnCompare.isUserInteractionEnabled = true
        btnCompare.backgroundColor = UIColor(red: 0.0/255.0, green: 124.0/255.0, blue: 195.0/255.0, alpha: 1.0)
        
    }
    
    func btncompareInActive() {
        btnCompare.isUserInteractionEnabled = false
        btnCompare.backgroundColor = UIColor(red: 0.0/255.0, green: 124.0/255.0, blue: 195.0/255.0, alpha: 0.25)
        
    }
    

    //MARk:- Validation for postal code
    
    func validZipCode(POSTAL:String)->Bool{
        print("validate POSTALCODE: \(POSTAL)")
        let postalcodeRegex = "^[ABCEGHJ-NPRSTVXY]{1}[0-9]{1}[ABCEGHJ-NPRSTV-Z]{1}[ ]?[0-9]{1}[ABCEGHJ-NPRSTV-Z]{1}[0-9]{1}$"
        let pinPredicate = NSPredicate(format: "SELF MATCHES %@", postalcodeRegex)
        let RESULT = pinPredicate.evaluate(with: POSTAL) as Bool
        return RESULT
        
    }
    
    //MARK:- WebCalling
    
    
    func webcallGetLocationBasedOnGecoding(textlocation:String,isfirst:Bool) {
        
        //  MyAppManager().showLoaderInMainThread()
        
        var json: NSMutableDictionary = NSMutableDictionary()
        self.vwLoader.isHidden = false
        self.activity.startAnimating()
        
        json = ["address": textlocation,"key":API_KEY]
        
        WSManager().requestAPIX(params: json,url:BaseGoogleUrl,method:"GET",postCompleted:
            { (succeeded: Bool, msg: String, responsedata:NSDictionary) -> () in
                DispatchQueue.main.async( execute:
                    {
                        //MyAppManager().hideLoaderInMainThread()
                        if(succeeded)
                        {
                            print(responsedata)
                            
                            if let result = responsedata["results"] as? NSArray {
                                
                                if result.count == 0 {
                                    self.alertviewwithmsg(strmsg: "There is no postal code")
                                    return
                                }
                                if let arrresults = result.object(at: 0) as? NSDictionary {
                                    
                                    if let geometry = arrresults["geometry"] as? NSDictionary {
                                        if let location = geometry["location"] as? NSDictionary {
                                            var latitude = 0.0
                                            var longitude = 0.0
                                            if let strlat = location["lat"] as? Double {
                                                latitude = strlat
                                            }
                                            if let strlat = location["lng"] as? Double {
                                                longitude = strlat
                                            }
                                            if isfirst {
                                                self.LocationCoord1 = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
                                                self.webcallGetLocationBasedOnGecoding(textlocation: self.txtLocation2.text!, isfirst: false)
                                                print(self.LocationCoord1)
                                            }
                                            else{
                                                self.LocationCoord2 = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
                                                self.setUpCurrentWeather(picklocation: self.LocationCoord1, isfrist: true)
                                                print(self.LocationCoord2)
                                            }
                                            
                                            
                                        }
                                    }
                                    
                                }
                            }
                        }else
                        {
                            self.alertviewwithmsg(strmsg: "invalid postal code")
                            
                            // showAlert(aMessage: msg)
                        }
                })
        })
        
    }
    
    
    
    func setUpCurrentWeather(picklocation:CLLocationCoordinate2D,isfrist:Bool) {
        weatherAPI.currentWeather(by: picklocation, withCallback: { (error, result) in
            
            if (error != nil) {
                
            }
            else{
                //print(result)
                if !isfrist {
                    self.vwLoader.isHidden = true
                    self.activity.stopAnimating()
                    self.vwcompare1.isHidden = false
                    self.vwcompare2.isHidden = false
                    self.heightOfvw.constant = 128
                    self.heightVwcompare.constant = 260
                }
                if isfrist {
                    self.setUpCurrentWeather(picklocation: self.LocationCoord2, isfrist: false)
                }
                if let strname = result!["name"] as? String {
                    let name = String(format:"City: %@",strname)
                    if isfrist { self.lblCity.text = name}else{self.lblCity2.text = name}
                }
                
                if let dictmain = result!["main"] as? NSDictionary {
                    if let strtemp = dictmain.value(forKey: "temp") as? Double {
                        let strTemp = String(format:"Temp: %.2f°c",strtemp)
                        if isfrist { self.lbltemp1.text = strTemp}else{self.lblTemp2.text = strTemp}
                    }
                    if let strtemp = dictmain.value(forKey: "pressure") as? Int {
                        let strPressure = String(format:"Pressure: %d",strtemp)
                        if isfrist { self.lblPressure1.text = strPressure}else{self.lblPressure2.text = strPressure}
                    }
                    if let strtemp = dictmain.value(forKey: "humidity") as? Int {
                        let strhumidity = String(format:"Humidity: %d",strtemp)
                        if isfrist { self.lblHumidity1.text = strhumidity}else{self.lblHumidy2.text = strhumidity}
                        
                    }
                }
                if let dictmain = result!["wind"] as? NSDictionary {
                    if let strwindspeed = dictmain.value(forKey: "speed") as? Int {
                        let strspeed = String(format:"wind-speed: %d",strwindspeed)
                        if isfrist { self.lblWindspeed1.text = strspeed}else{self.lblWindspeed2.text = strspeed}
                        
                    }
                }
                if let dictmain = result!["clouds"] as? NSDictionary {
                    if let strwindspeed = dictmain.value(forKey: "all") as? Int {
                        let strclouds = String(format:"clouds: %d",strwindspeed)
                        if isfrist { self.lblClouds1.text = strclouds}else{self.lblClouds2.text = strclouds}
                    }
                }
                
                if let arrWeather = result!["weather"] as? NSArray {
                    if let dictweather = arrWeather.object(at: 0) as? NSDictionary {
                        if let strdes = dictweather.value(forKey: "description") as? String {
                            let strweather = String(format:"weather: %@",strdes)
                            if isfrist { self.lblWeather1.text = strweather}else{self.lblWeather2.text = strweather}
                        }
                        
//                        if let strimg = dictweather.value(forKey: "icon") as? String {
//
//                            let urlimg = URL.init(string: self.imgURL + strimg + ".png")
//
//                            self.downloadImage(url: urlimg!)
//
//                        }
                    }
                    
                }
                
            }
        })
    }
    
    
    
    //MARK:- UIAlert view displaying
    
    
    func alertviewwithmsg(strmsg:String) {
        let alrtvw = UIAlertView.init(title: "", message: strmsg, delegate: nil, cancelButtonTitle: "Ok")
        alrtvw.show()
        
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
