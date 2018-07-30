//
//  MenuVC.swift
//  RightWeather
//
//  Created by Alphabit Technologies on 25/06/18.
//  Copyright © 2018 alphabit tech. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- Button Actions
    
    @IBAction func btnBackarrowOnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnProfileOnClick(_ sender: Any) {
        self.performSegue(withIdentifier: "pushProfilevc", sender: self)
    }
    
    @IBAction func btnPaymentOnClick(_ sender: Any) {
        self.performSegue(withIdentifier: "PushPaymentVc", sender: self)
    }
    
    @IBAction func btnpurchasepremiumfeaturesOnClick(_ sender: Any) {
        self.performSegue(withIdentifier: "PushPremiumFeatures", sender: self)
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
