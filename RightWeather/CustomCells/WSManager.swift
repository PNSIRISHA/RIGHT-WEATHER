

import Foundation
import UIKit

enum METHOD_TYPE
{
    case GET
    case POST
    case PUT
    case DELETE
}


public class WSManager: NSObject
{
    
    public var numOfAPIRequests : NSInteger = 0
    var logEnabled = true
    
    
    func queryString(parameters : NSDictionary) -> String
    {
        var firstPass = true
        var result = "?"
        for (key, value) in parameters
        {
            
            let encodedKey = (key as! NSString).addingPercentEscapes(using: String.Encoding.utf8.rawValue)!
            let encodedValue = (value as! NSString).addingPercentEscapes(using: String.Encoding.utf8.rawValue)!
            result += firstPass ? "\(encodedKey)=\(encodedValue)" : "&\(encodedKey)=\(encodedValue)"
            firstPass = false;
        }
        
        return result
    }
    func queryStringForPOST(parameters : NSDictionary) -> String
    {
        var firstPass = true
        var result = ""
        for (key, value) in parameters
        {
            let encodedKey = (key as! NSString).addingPercentEscapes(using: String.Encoding.utf8.rawValue)!
            let encodedValue = (value as! NSString).addingPercentEscapes(using: String.Encoding.utf8.rawValue)!
            result += firstPass ? "\(encodedKey)=\(encodedValue)" : "&\(encodedKey)=\(encodedValue)"
            firstPass = false;
        }
        
        return result
    }
    
    func requestAPIX(params : NSDictionary, url : String,method : String, postCompleted : @escaping (_ succeeded: Bool, _ msg: String, _ responsedata: NSDictionary) -> ())
    {
        
        var urlLogin: NSString = ""
        if method=="GET"
        {
            urlLogin = NSString(format:"%@%@",url,queryString(parameters: params))
        }
        else
        {
            urlLogin = NSString(format:"%@",url)
        }
        
        // print(params)
        //  print(urlLogin)
        
        var request:URLRequest = URLRequest(url:URL(string:urlLogin as String)!)
        request.httpMethod=method
        request.timeoutInterval=120
        
        if method=="POST"
        {
            
            let boundary : NSString = "---------------------------14737809831466499882746641449"
            //let contentType : NSString = NSString(format:"multipart/form-data; boundary=%@",boundary)
            let contentType : NSString = NSString(format:"multipart/raw; boundary=%@",boundary)
            request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
             //request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            var body = Data()
            
            for (field, value) in params {
                if let val = value as? Data
                {
                    body.append(NSString(format:"--%@\r\n",boundary).data(using: String.Encoding.utf8.rawValue)!)
                    
                    //rajji007 changes to JSON data
//                    body.append(NSString(format:"Content-Disposition: form-data; name=\"%@\";filename=\"media.png\"\r\n",(field as! String)).data(using: String.Encoding.utf8.rawValue)!)
                     body.append(NSString(format:"Content-Disposition: raw; name=\"%@\";filename=\"media.png\"\r\n",(field as! String)).data(using: String.Encoding.utf8.rawValue)!)
                    body.append(NSString(format:"Content-Type: application/octet-stream\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
                    body.append(val)
                    body.append(NSString(format:"\r\n--%@--\r\n",boundary).data(using: String.Encoding.utf8.rawValue)!)
                }
                if let val = value as? NSDictionary
                {
                    body.append(NSString(format:"--%@\r\n",boundary).data(using: String.Encoding.utf8.rawValue)!)
                        
                    body.append(NSString(format:"Content-Disposition: raw; name=\"%@\";filename=\"%@\"\r\n",(field as! String),val.object(forKey: "name") as! String).data(using: String.Encoding.utf8.rawValue)!)
                    body.append(NSString(format:"Content-Type: application/octet-stream\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
                    body.append(val.object(forKey: "data") as! Data)
                    body.append(NSString(format:"\r\n--%@--\r\n",boundary).data(using: String.Encoding.utf8.rawValue)!)
                    
                    
                }
                
                //[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];

                if let val = value as? String
                {
                    
//                    body.append(MyAppManager().convertencoding(NSString(format:"--%@\r\n",boundary) as String!))
//                    
//                     body.append(MyAppManager().convertencoding(NSString(format:"Content-Disposition: form-data;name=\"%@\"\r\n\r\n",field as! String) as String!))
//                    
//                     body.append(MyAppManager().convertencoding(NSString(format:"%@\r\n",val) as String!))
                    
                    body.append(NSString(format:"--%@\r\n",boundary).data(using: String.Encoding.utf8.rawValue)!)
//                    body.append(NSString(format:"Content-Disposition: form-data;name=\"%@\"\r\n\r\n",field as! String).data(using: String.Encoding.utf8.rawValue)!) // Changes to JSON formate

                    body.append(NSString(format:"Content-Disposition: raw;name=\"%@\"\r\n\r\n",field as! String).data(using: String.Encoding.utf8.rawValue)!)
                    body.append(NSString(format:"%@\r\n",val).data(using: String.Encoding.utf8.rawValue)!)
                    

                }
                
            }
            
            
            
            
           
            
            //let jsonData = try? JSONSerialization.data(withJSONObject: params)
            request.httpBody = body
            
            
            
            
            
//            if let tocken = strDeviceTocken{
//                request.setValue(tocken, forHTTPHeaderField: APPParamterConstant.kDeviceToken)
//            }
            
            //rajji007
//            if let token = UserDefaults.standard.object(forKey: APPParamterConstant.kDeviceToken) as? String{
//                request.setValue(token, forHTTPHeaderField: APPParamterConstant.kDeviceToken)
//            }
//            else
//            {
//                request.setValue(strDeviceTocken, forHTTPHeaderField: APPParamterConstant.kDeviceToken)
//            }
//            
//            request.setValue(AppCommonConstant.kAPPKEY, forHTTPHeaderField: APPParamterConstant.kAPPKEY)
//            if let device_id = UserDefaults.standard.object(forKey: APPUserDefaultConstant.kDeviceId) as? String{
//                request.setValue(device_id, forHTTPHeaderField: APPParamterConstant.kDeviceId)
//            }
//            else{
//                request.setValue("", forHTTPHeaderField: APPParamterConstant.kDeviceId)
//            }
//            request.setValue((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiom.pad) ? "ios": "ios", forHTTPHeaderField: APPParamterConstant.kDeviceType)
//            request.setValue(select_lang, forHTTPHeaderField: APPParamterConstant.kLanguage)
//            
//            request.setValue(appVersion, forHTTPHeaderField: APPParamterConstant.kAppVersion)
//            request.setValue("2", forHTTPHeaderField: APPParamterConstant.kApiVersion)
            
            
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        numOfAPIRequests += 1
        let queue:OperationQueue = OperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue) { (response, data, error) in
            self.numOfAPIRequests-=1
            if(self.numOfAPIRequests==0)
            {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            if (error != nil)
            {
                postCompleted(false, error!.localizedDescription, NSDictionary())
            }
            else
            {
                let outputString:NSString = NSString(data:data!, encoding:String.Encoding.utf8.rawValue)!
                
                // if (self.logEnabled)
                // {
               // print(((urlLogin as String)+(outputString as String)))
                // }
                
                var error: NSError?
                let jsonData: Any?
                do {
                    jsonData = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers )
                } catch let error1 as NSError {
                    error = error1
                    jsonData = nil
                } catch {
                    fatalError()
                }
                
                if (error != nil)
                {
                    postCompleted(false, "Server error. Please try again later.", NSDictionary())
                }
                else
                {
                    postCompleted(true,"SUCCESS",jsonData  as! NSDictionary)
                }
            }
        }
    }
    
    
    
    

    
}
