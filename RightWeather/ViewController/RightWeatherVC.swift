//
//  RightWeatherVC.swift
//  RightWeather
//
//  Created by Alphabit Technologies on 25/06/18.
//  Copyright © 2018 alphabit tech. All rights reserved.
//

import UIKit
import Foundation

class RightWeatherVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    
    @IBOutlet weak var tblrightweather: UITableView!
    
    @IBOutlet weak var vwCurrentloc: UIView!
    
    @IBOutlet weak var txtPostalCode: UITextField!
    
    @IBOutlet weak var imgWeather: UIImageView!
    
    @IBOutlet weak var lblCityname: UILabel!
    
    @IBOutlet weak var vwHeader: UIView!
    
    
    @IBOutlet weak var btnSearch: UIButton!
    
    
    var weatherAPI = OWMWeatherAPI()
    var forecast =  NSArray()
    var dateFormatter = DateFormatter()
    var downloadCount:Int = 0
    let imgURL = "http://openweathermap.org/img/w/"
    let BaseGoogleUrl = "https://maps.googleapis.com/maps/api/geocode/json"
    let API_KEY = "AIzaSyAj1zYN_aAZuJjpmUJh2exNZi_Wb_IqoF8"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpData()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    //MARK:- custome classes
    
    func setUpData()  {
        
        self.navigationController?.isNavigationBarHidden = true
        
        tblrightweather.isHidden = true
        btnSearch.backgroundColor = UIColor(red: 0.0/255.0, green: 124.0/255.0, blue: 195.0/255.0, alpha: 0.25)
        btnSearch.isUserInteractionEnabled = false
        
        
        vwCurrentloc.layer.cornerRadius = vwCurrentloc.frame.width / 2
        vwCurrentloc.layer.borderColor = UIColor.black.cgColor
        vwCurrentloc.layer.borderWidth = 1.0
        
        
        vwCurrentloc.isHidden = true
        
        
        let dateComponents = "H:m yyMMMMd"
        let dateFormat = DateFormatter.dateFormat(fromTemplate: dateComponents, options: 0, locale: Locale.current)
        dateFormatter.dateFormat = dateFormat
        weatherAPI = OWMWeatherAPI.init(apiKey: "748999a5f6403380ce2d5e7b4e98ea63")
        weatherAPI.setLangWithPreferedLanguage()
        weatherAPI.setTemperatureFormat(kOWMTempCelcius)
        
        
    }
    
    
    
    
    
    
    //MARK:- Button Actions
    
    @IBAction func textfileddidchange(_ sender: Any) {
        
        if validZipCode(POSTAL: txtPostalCode.text!) {
            // correct password
            btnSearch.isUserInteractionEnabled = true
            btnSearch.backgroundColor = UIColor(red: 0.0/255.0, green: 124.0/255.0, blue: 195.0/255.0, alpha: 1.0)
        }
        else {
            btnSearch.isUserInteractionEnabled = false
            btnSearch.backgroundColor = UIColor(red: 0.0/255.0, green: 124.0/255.0, blue: 195.0/255.0, alpha: 0.25)
        }

        
    }
    
    @IBAction func btnSearchOnClick(_ sender: Any) {
        webcallGetLocationBasedOnGecoding()
    }
    
    @IBAction func btnMenuOnClick(_ sender: Any) {
        self.performSegue(withIdentifier: "PushMenuVC", sender: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    
    
    
    //MARK:- tableview delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:customCell = tableView.dequeueReusableCell(withIdentifier: "CellRightWeather") as! customCell!
        
        
        if let forecastData = forecast.object(at: indexPath.row) as? NSDictionary {
            
            if let strdate = forecastData.value(forKey: "dt") as? Int {
                
                let date = NSDate.init(timeIntervalSince1970: TimeInterval(strdate))
                
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let strdate1 = dateFormatterGet.string(from: date as Date)
                
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "dd,hh:mm a"

                
                if let date = dateFormatterGet.date(from: strdate1){
                    cell.lblTime.text = dateFormatterPrint.string(from: date)
                }
                
            }
            
            if let dictmain = forecastData.value(forKey: "main") as? NSDictionary {
                
                if let tempvalue = dictmain.value(forKey: "temp") as? Double {
                    
                    cell.lbltemp.text = String(format:"%.2f°c",tempvalue)
                }
                
            }
            
            if let arrWeather = forecastData.value(forKey: "weather") as? NSArray {
                
                var strdesc = ""
                if let dictweather = arrWeather.object(at: 0) as? NSDictionary {
                    if let imgIcon = dictweather.value(forKey: "icon") as? String {
                       
                        let urlimg:URL = URL.init(string: imgURL + imgIcon + ".png")!
                        
                        
                        getDataFromUrl(url: urlimg) { data, response, error in
                            guard let data = data, error == nil else { return }
                            print(response?.suggestedFilename ?? urlimg.lastPathComponent)
                            //print("Download Finished")
                            DispatchQueue.main.async() {
                                cell.imgOfReport.image = UIImage(data: data)!
                                //  return UIImage(data: data)
                            }
                        }
                        
                    }
                    
                    if let strmain = dictweather.value(forKey: "description") as? String {
                        strdesc = strmain
                    }
                    if let dictClouds = dictweather.value(forKey: "clouds") as? NSDictionary {
                        if let strclouds = dictClouds.value(forKey: "all") as? Int {
                            cell.lblClouds.text = String(format:"Clouds: %d",strdesc,strclouds)
                        }
                    }
                    
                    if let strmain = dictweather.value(forKey: "main") as? String {
                        
                        if strmain == "Rain" {
                            
                            if let dictrain = forecastData.value(forKey: "rain") as? NSDictionary {
                                if let strrain = dictrain.value(forKey: "3h") as? String {
                                    strdesc = strdesc + "3h :" + strrain
                                }
                            }
                        }
                        
                    }
                    cell.lbldesc.text = strdesc
                }
                
            }
        }
        
        
        return cell
        
    }
    
    
    
    //MARK:- Url convert to Uiimage
    
    func downloadImage(url: URL) {
        print("Download Started")
      //  var imgSample = UIImage.init()
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.imgWeather.image = UIImage(data: data)!
              //  return UIImage(data: data)
            }
        }
       
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    
    //MARK:- textfiled delegate methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 6
        let currentString: NSString = txtPostalCode.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength

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
    
    
    func webcallGetLocationBasedOnGecoding() {
        
      //  MyAppManager().showLoaderInMainThread()
        
        var json: NSMutableDictionary = NSMutableDictionary()
        
        
        json = ["address": txtPostalCode.text!,"key":API_KEY]
        
        WSManager().requestAPIX(params: json,url:BaseGoogleUrl,method:"GET",postCompleted:
            { (succeeded: Bool, msg: String, responsedata:NSDictionary) -> () in
                DispatchQueue.main.async( execute:
                    {
                        //MyAppManager().hideLoaderInMainThread()
                        if(succeeded)
                        {
                            print(responsedata)
                            
                            if let result = responsedata["results"] as? NSArray {
                                
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
                                            let locationcord = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
                                            
                                            self.setUpCurrentWeather(picklocation: locationcord)
                                            
                                            
                                        }
                                    }
                                    
                                }
                            }

                            
                            
                            
                            
                            /* if let statuscode = responsedata.value(forKey: APPWSConstant.KSTAUTS) as? Int {
                             if (statuscode == 200){
                             self.webCallingLoginuserornot()
                             }
                             else{
                             showAlert(aMessage: responsedata.value(forKey: APPWSConstant.KMESSAGE) as! String)
                             }
                             }*/
                        }else
                        {
                           // showAlert(aMessage: msg)
                        }
                })
        })
        
    }
    
    
    
    
    func setweatherreport(postallocation:CLLocationCoordinate2D)  {
        
        
        //  weatherAPI.dailyForecastWeather(byCityName: "Hyderabad", withCount: 20) { (error, result) in
        
        
        //weatherAPI.forecastWeather(byZipcode: txtPostalCode.text! + ",us") { (error, result) in
        
        

        
        weatherAPI.forecastWeather(by: postallocation) { (error, result) in
        
                    if (error != nil) {
                    }
                    else{
                        // print(result)
                        self.tblrightweather.isHidden = false
                        self.forecast = result!["list"] as! NSArray
                        self.tblrightweather.reloadData()
                    }
                }
    }
    
    
    func setUpCurrentWeather(picklocation:CLLocationCoordinate2D) {
        weatherAPI.currentWeather(by: picklocation, withCallback: { (error, result) in
            
            self.setweatherreport(postallocation: picklocation)
            
            if (error != nil) {
                
            }
            else{
                //print(result)
                self.vwCurrentloc.isHidden = false
                var strdesc = ""
                if let strname = result!["name"] as? String {
                    strdesc = strname
                }
                
                if let dictsys = result!["name"] as? NSDictionary {
                    
                    if let strcountry = dictsys.value(forKey: "country") as? String {
                        strdesc = String(format:"%@, %@",strdesc,strcountry)
                    }
                    
                }
                if let dictmain = result!["main"] as? NSDictionary {
                    if let strtemp = dictmain.value(forKey: "temp") as? Double {
                        strdesc = String(format:"%@, %.2f°c",strdesc,strtemp)
                    }
                }
                
                if let arrWeather = result!["weather"] as? NSArray {
                    if let dictweather = arrWeather.object(at: 0) as? NSDictionary {
                        if let strdes = dictweather.value(forKey: "description") as? String {
                            strdesc = strdesc + ", " + strdes
                        }
                        
                        if let strimg = dictweather.value(forKey: "icon") as? String {
                            
                            let urlimg = URL.init(string: self.imgURL + strimg + ".png")
                            
                            self.downloadImage(url: urlimg!)
                            
                        }
                    }
                    
                }
                
                self.lblCityname.text = strdesc
                
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
