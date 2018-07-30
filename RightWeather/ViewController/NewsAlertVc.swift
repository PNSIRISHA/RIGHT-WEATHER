//
//  NewsAlertVc.swift
//  RightWeather
//
//  Created by Alphabit on 28/06/18.
//  Copyright © 2018 alphabit tech. All rights reserved.
//

import UIKit

class NewsAlertVc: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    var arrnews = [["title":"the GEO Business 2018 event","desc":"ergey Venediktov, COO, Openweather.  A couple of weeks ago, the OpenWeather team visited the GEO Business 2018 event at the Business Design Centre in London. As promised, we will share our impressions with you","time":"20 mins ago"],["title":"The OpenWeather team visited","desc":"Sergey Venediktov, COO, Openweather.  The OpenWeather team visited GEO Business Show 2018  in London on 22–23 May. The show is an international exhibition for the geospatial industry that provides an excellent opportunity","time":"2 hours ago"],["title":"Satellite Images API for Agriculture","desc":"Olga Makarova, PR Manager, Openweather.  Satellite images API on the basis of which we calculate quantitative indices, such as NDVI, EVI, and others, and from which we also obtain ready-made images of territories in ","time":"5 hours ago"],["title":"Helping farmers manage their enterprises:","desc":"Olga Makarova, PR Manager, Openweather.  Objectives: As farms mainly consist of crop fields, which can be hundreds of acres in size, much time and resources are demanded of farmers in obtaining an accurate picture of the o...","time":"1 day ago"],["title":"NEW! Agro API - service for Agriculture","desc":"Bronislava Stavnitskaya, Product Manager, Openweather.  OpenWeatherMap team are pleased to announce that we are launching a new product aimed primarily at specialists developing agricultural services and addressing the spec...","time":"26 jun 2018"],["title":"Temperature and Soil Moisture. Their Interaction and Effect on Plant Growth","desc":"By: Olga Makarova, PR Manager, Openweather.  Crop farming covers around 40% of the globe and uses 85% of its fresh water. Often, in countries where agriculture constitutes the principal occupation of farmers, due to drought an...","time":"14 jun 2018"],["title":"Meteorological and Climate Indices for Assessing the Effects of Weather Events on Agriculture","desc":"A couple of weeks ago, the OpenWeather team visited the GEO Business 2018 event","time":"06 jun 2018"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnbackonclick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- tableview delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrnews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:newAlertCell = tableView.dequeueReusableCell(withIdentifier: "cellNews") as! newAlertCell!
        
        if let dictnews = arrnews[indexPath.row] as? NSDictionary {
            
            if let strtilte = dictnews.value(forKey: "title") as? String {
                cell.lblnewTitle.text = strtilte
            }
            if let strDesc = dictnews.value(forKey: "desc") as? String {
                cell.lblnewsDes.text = strDesc
            }
            if let strtime = dictnews.value(forKey: "time") as? String {
                cell.lbltime.text = strtime
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
