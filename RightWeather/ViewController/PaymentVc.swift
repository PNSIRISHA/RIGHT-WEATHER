//
//  PaymentVc.swift
//  RightWeather
//
//  Created by Alphabit Technologies on 25/06/18.
//  Copyright © 2018 alphabit tech. All rights reserved.
//

import UIKit

class PaymentVc: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var txtcreditcard: UITextField!
    
    @IBOutlet weak var txtexpiry: UITextField!
    
    @IBOutlet weak var btnsave: UIButton!
    let ACCEPTABLE_CHARACTERS = "1234567890/"
    var coreDataProvider : CoreDataProvider!
    
    
    @IBOutlet weak var vwdatepicker: UIView!
    
    @IBOutlet weak var topspacevwpicker: NSLayoutConstraint!
    
    @IBOutlet weak var datepicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnsave.layer.cornerRadius = 4
        btnsave.layer.borderColor = UIColor.black.cgColor
        btnsave.layer.borderWidth = 1.0

       
        configureuserList()
        
        let user = coreDataProvider.getUserDetails()
        
        if user != nil {
            txtcreditcard.text = user?.creadit_card
            txtexpiry.text = user?.expiry_date

        }

        
        
        // Do any additional setup after loading the view.
    }
    
    func configureuserList() {
        self.coreDataProvider =  CoreDataProvider.sharedList
        self.coreDataProvider.initDataSourceForList(user_id: "1")
    }
    
    //MARK:- Button Actions
    
    @IBAction func btnCancelOnClick(_ sender: Any) {
    }
    
    @IBAction func btnDoneOnClick(_ sender: Any) {
    }
    
    @IBAction func btnDatepickervalueChangeOnClick(_ sender: Any) {
    }
    
    
    @IBAction func btnBackOnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnSaveOnClick(_ sender: Any) {
        
        if txtcreditcard.text == "" {
            alertviewwithmsg(strmsg: "Please enter the Credit card details")
        }
        else if (txtcreditcard.text?.count)! < 16 {
            alertviewwithmsg(strmsg: "Please enter the valid Credit card details")
        }
        else if txtexpiry.text == "" {
            alertviewwithmsg(strmsg: "Please enter the Expiry date for Credit card")
        }
        else if (txtexpiry.text?.count)! < 5 {
            alertviewwithmsg(strmsg: "Please enter the valid Expiry date for Credit card")
        }
        else{
            
            view.endEditing(true)
             let user = coreDataProvider.getUserDetails()
            if user == nil {
                alertviewwithmsg(strmsg: "Please fill the profile information")
                self.performSegue(withIdentifier: "pushProfileVC", sender: self)
            }
            else{
               
                user?.creadit_card = txtcreditcard.text
                user?.expiry_date = txtexpiry.text
                CoreDataProvider.sharedDataManager.saveContext()
            }
            
            
        }
        
        
        
        
    }
    
    
    
    //MARK:- UITextField Delegate Methods
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let typeCasteToStringFirst = textField.text as NSString?
//        let newString = typeCasteToStringFirst?.replacingCharacters(in: range, with: string)
        
        if string.count == 0 {
            return true
        }
        
        if textField == txtcreditcard {
            if range.location > 16 {
                return false
            }
        }
        else{
          var orginalText = textField.text
            if range.location >= 5 {
                return false
            }
            
            if range.location == 2 {
                orginalText?.append(contentsOf: "/")
                textField.text = orginalText
            }
        }
        
        return true
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
