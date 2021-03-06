//
//  APIServiceManager.swift
//  cirrb app
//
//  Created by mac on 27/04/17.
//  Copyright © 2017 3WebBox, Inc. All rights reserved.
//

import UIKit
import Foundation
import Alamofire


typealias ServiceResponse = (Any?, NSError?) -> Void


class APIServiceManager: NSObject {
    var root_url: String!
    var authKey: String!
    var email: String!
    var session: SessionManager!
    var currentViewController: UIViewController?
    
    init(root_url: String!, vc: UIViewController?){
        self.root_url = root_url
        self.currentViewController = vc
        
    }
    
    func setCurrentViewController(vc: UIViewController?){
        self.currentViewController = vc
    }
    
    func login(email: String, password: String, device_token: String, onComplete: ServiceResponse?){
      
        let URL = root_url+Constant.Methods.LOGIN
        
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Content-Type"] = ("application/json")
        let configuration = URLSessionConfiguration.default
        // add the headers
        configuration.httpAdditionalHeaders = headers
        self.session = Alamofire.SessionManager(configuration: configuration)
        
        let params = [
            
            "email": email,
            "password": password,
            "device_type": "ios",
            "device_token": device_token,
            "remember":"true",
            "role":"partner"
        ]
        
        self.session.request(URL,
                             method: .post,
                             parameters: params
            ).responseJSON(completionHandler: {(response) in
                
                 print("statusCode Login is: ", response.result.isSuccess && ((response.response?.statusCode) != nil))
                
                if response.result.isSuccess && response.response?.statusCode == 200{
                    let details  = response.result.value!
                    let detailDict = details as! NSDictionary
                    
                    if detailDict["status"] != nil {
                        let status = detailDict.value(forKey: "status") as? String
                        if status == "fail" {
                            let message = detailDict.value(forKey: "message") as! String
                            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
                            }))
                            self.currentViewController?.present(alert, animated: true, completion: nil)
                            onComplete!(nil,nil )
                        }else{
                            onComplete!(details,nil)
                        }
                    }else{
                        onComplete!(details,nil)
                    }
                }else{
                    
                }
            })
    }
    
    func register(email: String, password: String, device_token: String, lat: String, long: String, onComplete: ServiceResponse?){
        
        let URL = root_url+Constant.Methods.REGISTER
        
        let configuration = URLSessionConfiguration.default
        self.session = Alamofire.SessionManager(configuration: configuration)
        
        let params = [
            "email": email,
            "password": password,
            "password_confirmation": password,
            "device_type": "ios",
            "device_token": device_token,
            "lat":lat,
            "long":long,
            "role":"partner"
        ]
        
        self.session.request(URL,
                             method: .post,
                             parameters: params
            ).responseJSON(completionHandler: {(response) in
                // debugPrint(response)
                if response.result.isSuccess && response.response?.statusCode == 200{
                    let details  = response.result.value!
                    let detailDict = details as! NSDictionary
                    print("Reg detailDict is: ",detailDict)
                    
                    if detailDict["status"] != nil {
                        
                         print("Reg detailDict inside nil status is: ",detailDict)
                         onComplete!(details,nil )
                    
                    }else if detailDict["email"] != nil {
                        print("Reg detailDict inside email is: ",detailDict)
                        let message = detailDict.value(forKey: "email") as! NSArray
                        let strMessage = message.object(at: 0) as! String
                        
                        let alert = UIAlertController(title: "Alert", message: strMessage, preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
                        }))
                        self.currentViewController?.present(alert, animated: true, completion: nil)
                       onComplete!(nil,nil )
                    }else {
                        let alert = UIAlertController(title: "Alert", message: "Server not responding.", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
                        }))
                        self.currentViewController?.present(alert, animated: true, completion: nil)
                        onComplete!(nil,nil )
                    }
                 }else{
                    
                 }
            })
    }
    
    
    func forgotPassword(email: String, onComplete: ServiceResponse?){
        
        let URL = root_url+Constant.Methods.FORGOT_PASSWORD
        
        let configuration = URLSessionConfiguration.default
        self.session = Alamofire.SessionManager(configuration: configuration)
        
        let params = [
            "email": email
        ]
        
        self.session.request(URL,
                             method: .post,
                             parameters: params
            ).responseJSON(completionHandler: {(response) in
                // debugPrint(response)
                if response.result.isSuccess && response.response?.statusCode == 200{
                    let details  = response.result.value!
                    let detailDict = details as! NSDictionary
                    if detailDict["status"] != nil {
                        let status = detailDict.value(forKey: "status") as! String
                        
                        if status == "fail" {
                            let message = detailDict.value(forKey: "message") as! String
                            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
                            }))
                            self.currentViewController?.present(alert, animated: true, completion: nil)
                            onComplete!(nil,nil )
                        }
                    }else{
                        onComplete!(details,nil )
                    }
                }else{
                    
                }
            })
    }
    
    func setPassword(code: String, email: String, new_password: String, onComplete: ServiceResponse?){
        
        let URL = root_url+Constant.Methods.SET_PASSWORD
        
        let configuration = URLSessionConfiguration.default
        self.session = Alamofire.SessionManager(configuration: configuration)
        
        
        let params = [
            "code": code,
            "email": email,
            "password": new_password,
            "password_confirmation": new_password
        ]
        
        self.session.request(URL,
                             method: .post,
                             parameters: params
            ).responseJSON(completionHandler: {(response) in
                // debugPrint(response)
                if response.result.isSuccess && response.response?.statusCode == 200{
                    let details  = response.result.value!
                    let detailDict = details as! NSDictionary
                    
                    if detailDict["status"] != nil {
                        let status = detailDict.value(forKey: "status") as! String
                        
                        if status == "success" {
                            
                            onComplete!(details , nil )
                            
                        }else{
                            let alert = UIAlertController(title: "Alert", message: "Invalid Code", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
                                
                            
                            }))
                            self.currentViewController?.present(alert, animated: true, completion: nil)
                            onComplete!(nil,nil )
                        }
                    }else{
                        onComplete!(details,nil )
                    }
                }else{
                    
                }
            })
    }
    
    
    func getBranches(latitude: String, longitude: String, distance: String, onComplete: ServiceResponse?){
        
        let URL = root_url+"restaurants?action=api&lat=\(latitude)&long=\(longitude)&distance=\(distance)&user_id=\((UserDefaults.standard.object(forKey: Constant.User.USER_ID) as? String)!)"
        print("URL for rest is: ", URL)
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Content-Type"] = ("application/json")
        headers["Authorization"] = UserDefaults.standard.object(forKey: Constant.User.AUTH_TOKEN) as? String
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        self.session = Alamofire.SessionManager(configuration: configuration)
        
        self.session.request(URL,
                             method: .get,
                             parameters: nil
            ).responseJSON(completionHandler: {(response) in
                // debugPrint(response)
                if response.result.isSuccess && response.response?.statusCode == 200{
                    let details  = response.result.value!
                    onComplete!(details,nil )
                }else{
                    
                }
            })
    }
    
    
    func getBranchMenu(restaurantId: String, onComplete: ServiceResponse?){
        
        let URL = root_url+"menus?action=api&restaurant_id=\(restaurantId)&user_id=\((UserDefaults.standard.object(forKey: Constant.User.USER_ID) as? String)!)"
        print("URL for menu is: ", URL)
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Content-Type"] = ("application/json")
        headers["Authorization"] = UserDefaults.standard.object(forKey: Constant.User.AUTH_TOKEN) as? String
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        self.session = Alamofire.SessionManager(configuration: configuration)
        
        self.session.request(URL,
                             method: .get,
                             parameters: nil
            ).responseJSON(completionHandler: {(response) in
                debugPrint(response)
                if response.result.isSuccess && response.response?.statusCode == 200{
                    let details  = response.result.value!
                    
                    onComplete!(details,nil )
                }else{
                    
                }
            })
    }
    
    func setOrder(sub_total: String, delivery_fees: String, total: String, orderDict: NSMutableArray ,onComplete: ServiceResponse?){
        
        
       let URL = root_url + "setOrderNew"
        
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Content-Type"] = ("application/json")
        headers["Authorization"] = UserDefaults.standard.object(forKey: Constant.User.AUTH_TOKEN) as? String
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers

        self.session = Alamofire.SessionManager(configuration: configuration)
        var idOrder: String = ""
        var branch_id: String = ""
        var resturent_id: String = ""
        var quantity: String = ""
        if orderDict.count > 0 {

            
            for i in 0..<orderDict.count {
               
                if idOrder.characters.count != 0 {
                    idOrder = idOrder + "," + String((((orderDict.object(at: i) as AnyObject).value(forKey: "id") as AnyObject) as? Int)!)
                }else{
                    idOrder = String((((orderDict.object(at: i) as AnyObject).value(forKey: "id") as AnyObject) as? Int)!)
                }
                
                if branch_id.characters.count != 0 {
                    branch_id = branch_id + "," + (UserDefaults.standard.object(forKey: "branch_id") as? String)!
                }else{
                    branch_id = (UserDefaults.standard.object(forKey: "branch_id") as? String)!
                }
                
                if resturent_id.characters.count != 0 {
                    resturent_id = resturent_id + "," + String((((orderDict.object(at: i) as AnyObject).value(forKey: "restaurant_id") as AnyObject) as? Int)!)
                }else{
                    resturent_id = String((((orderDict.object(at: i) as AnyObject).value(forKey: "restaurant_id") as AnyObject) as? Int)!)
                }
                
                if quantity.characters.count != 0 {
                    quantity = quantity + "," + String((((orderDict.object(at: i) as AnyObject).value(forKey: "quantity") as AnyObject) as? Int)!)
                }else{
                    quantity = String((((orderDict.object(at: i) as AnyObject).value(forKey: "quantity") as AnyObject) as? Int)!)
                }
            }
            
            print("id: ", idOrder)
            print("branch_id: ", branch_id)
            print("resturent_id: ", resturent_id)
            print("quantity: ", quantity)
        }
        
        
        let params = [
            "user_id" : (UserDefaults.standard.object(forKey: Constant.User.USER_ID) as? String)! ,
            "sub_total" : sub_total,
            "delivery_fees": delivery_fees,
            "total": total,
            "id": idOrder,
            "branch_id": branch_id,
            "resturent_id": resturent_id,
            "quantity": quantity
        ] as [String : Any]

        
        
        print("params is: ", params)
        
        self.session.request(URL,
                             method: .post,
                             parameters: params
            ).responseJSON(completionHandler: {(response) in
                if response.result.isSuccess && response.response?.statusCode == 200{
                    let details  = response.result.value!
                    onComplete!(details,nil )
                }else{
                    
                }
            })

    }

    
    func getOrderList(onComplete: ServiceResponse?){
        
        let URL = root_url+"getOrder"
        
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Content-Type"] = ("application/json")
        headers["Authorization"] = UserDefaults.standard.object(forKey: Constant.User.AUTH_TOKEN) as? String
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        self.session = Alamofire.SessionManager(configuration: configuration)
        
        let params = [
            "user_id" : (UserDefaults.standard.object(forKey: Constant.User.USER_ID) as? String)!
            ] as [String : Any]
        
        self.session.request(URL,
                             method: .post,
                             parameters: params
            ).responseJSON(completionHandler: {(response) in
                if response.result.isSuccess && response.response?.statusCode == 200{
                    let details  = response.result.value!
                    onComplete!(details,nil )
                }else{
                    
                }
            })
    }
    
    func getUserBalanceDetails(onComplete: ServiceResponse?){
        
        let URL = root_url+"customerDetails?user_id=\((UserDefaults.standard.object(forKey: Constant.User.USER_ID) as? String)!)"
        
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Content-Type"] = ("application/json")
        headers["Authorization"] = UserDefaults.standard.object(forKey: Constant.User.AUTH_TOKEN) as? String
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        self.session = Alamofire.SessionManager(configuration: configuration)
        
        
        self.session.request(URL,
                             method: .get,
                             parameters: nil
            ).responseJSON(completionHandler: {(response) in
                if response.result.isSuccess && response.response?.statusCode == 200{
                    let details  = response.result.value!
                    onComplete!(details,nil )
                }else{
                    
                }
            })
    }
    
    
    func getAllOrderList(onComplete: ServiceResponse?){
        
        let URL = root_url+"getPartnerOrder"
        
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Content-Type"] = ("application/json")
        headers["Authorization"] = UserDefaults.standard.object(forKey: Constant.User.AUTH_TOKEN) as? String
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        self.session = Alamofire.SessionManager(configuration: configuration)
        
        let params = [
            "user_id" : (UserDefaults.standard.object(forKey: Constant.User.USER_ID) as? String)!
            ] as [String : Any]
        
        self.session.request(URL,
                             method: .post,
                             parameters: params
            ).responseJSON(completionHandler: {(response) in
                debugPrint(response)
                if response.result.isSuccess && response.response?.statusCode == 200{
                    let details  = response.result.value!
                    onComplete!(details,nil )
                }else{
                    
                }
            })
    }

    func updateProfile(onComplete: ServiceResponse?){
        
        let URL = root_url+"updateCustomer"
        
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Content-Type"] = ("application/json")
        
        headers["Authorization"] = UserDefaults.standard.object(forKey: Constant.User.AUTH_TOKEN) as? String
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        self.session = Alamofire.SessionManager(configuration: configuration)
        
        let params = [
            "user_id" : (UserDefaults.standard.object(forKey: Constant.User.USER_ID) as? String)!,
            "first_name" : (UserDefaults.standard.object(forKey: Constant.User.FIRST_NAME) as? String)!,
            "last_name" : (UserDefaults.standard.object(forKey: Constant.User.LAST_NAME) as? String)!,
            "phone" : (UserDefaults.standard.object(forKey: Constant.User.PHONE) as? String)!
            ] as [String : Any]
        
        self.session.request(URL,
                             method: .post,
                             parameters: params
            ).responseJSON(completionHandler: {(response) in
                if response.result.isSuccess && response.response?.statusCode == 200{
                    let details  = response.result.value!
                    onComplete!(details,nil )
                }else{
                    
                }
            })
    }
    
    func uploadImageAndData(data: UIImage, onComplete: ServiceResponse?){
        let url = root_url+"updateCustomer"
        
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Content-Type"] = ("application/json")
        
        let parameters = [
            "user_id": (UserDefaults.standard.object(forKey: Constant.User.USER_ID) as? String)!
        ]
        print("pick image UIImage: ",data)
        
        let currentTime = getCurrentMillis()
        print("currentTime is: ",currentTime)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters {
                multipartFormData.append((UIImageJPEGRepresentation(data,1.0) as Data?)!, withName: "image", fileName: "\(currentTime).png", mimeType: "image/png")
                multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
            }
        }, to: url)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("progress is: ",progress)
                })
                
                upload.responseJSON { response in
                    print("response.result: ",response.result.value!)
                    onComplete!(response.result.value!,nil)
                }
                
            case .failure( _): break
            }
        }
        
    }
    func accpectOrder(partner_id: String, order_id: Int, approval: String,onComplete: ServiceResponse?){
        
        let URL = root_url+"partnerResponse"
        
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Content-Type"] = ("application/json")
        headers["Authorization"] = UserDefaults.standard.object(forKey: Constant.User.AUTH_TOKEN) as? String
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        self.session = Alamofire.SessionManager(configuration: configuration)
        
        let params = [
            "partner_id" : partner_id,
            "order_id" : order_id,
            "approval" :approval
            ] as [String : Any]
        
        self.session.request(URL,
                             method: .post,
                             parameters: params
            ).responseJSON(completionHandler: {(response) in
                debugPrint(response)
                if response.result.isSuccess && response.response?.statusCode == 200{
                    let details  = response.result.value!
                    onComplete!(details,nil )
                }else{
                    onComplete!(nil,nil )
                    
                }
            })
    }
    func denyOrder(partner_id: String, order_id: Int, approval: String,onComplete: ServiceResponse?){
        
        let URL = root_url+"partnerResponse"
        
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Content-Type"] = ("application/json")
        headers["Authorization"] = UserDefaults.standard.object(forKey: Constant.User.AUTH_TOKEN) as? String
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        self.session = Alamofire.SessionManager(configuration: configuration)
        
        let params = [
            "partner_id" : partner_id,
            "order_id" : order_id,
            "approval" :approval
            ] as [String : Any]
        
        self.session.request(URL,
                             method: .post,
                             parameters: params
            ).responseJSON(completionHandler: {(response) in
                debugPrint(response)
                if response.result.isSuccess && response.response?.statusCode == 200{
                    let details  = response.result.value!
                    onComplete!(details,nil )
                }else{
                    onComplete!(nil,nil )
                }
            })
    }
    func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    func searchOrders(onComplete: ServiceResponse?){
        
        let URL = root_url+"getnearestorder?partner_id=\((UserDefaults.standard.object(forKey: Constant.User.USER_ID) as? String)!)"
        
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Content-Type"] = ("application/json")
        headers["Authorization"] = UserDefaults.standard.object(forKey: Constant.User.AUTH_TOKEN) as? String
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        self.session = Alamofire.SessionManager(configuration: configuration)
        
        self.session.request(URL,
                             method: .get,
                             parameters: nil
            ).responseJSON(completionHandler: {(response) in
                debugPrint(response)
                if response.result.isSuccess && response.response?.statusCode == 200{
                    let details  = response.result.value!
                    onComplete!(details,nil )
                }else{
                    onComplete!(nil,nil )
                }
            })
    }
    func payment(order_id: String, partner_id: String, amount: String,onComplete: ServiceResponse?){
        
        let URL = root_url+"payment"
        
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Content-Type"] = ("application/json")
        headers["Authorization"] = UserDefaults.standard.object(forKey: Constant.User.AUTH_TOKEN) as? String
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        self.session = Alamofire.SessionManager(configuration: configuration)
        
        let params = [
            "order_id" : order_id,
            "partner_id" : partner_id,
            "amount" : amount
            ] as [String : Any]
       
        debugPrint(params)
        
        self.session.request(URL,
                             method: .post,
                             parameters: params
            ).responseJSON(completionHandler: {(response) in
                if response.result.isSuccess && response.response?.statusCode == 200{
                    let details  = response.result.value!
                    onComplete!(details,nil )
                }else{
                    onComplete!(nil,nil )
                }
            })
    }
    
    func updateCoordinate(user_id: String, lat: String, long: String,onComplete: ServiceResponse?){
        
        let strurl = root_url+"update-coordinates"
        print("strurl is: ",strurl)
        
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        
        headers["Content-Type"] = ("application/json")
        //headers["Authorization"] = UserDefaults.standard.object(forKey: Constant.User.AUTH_TOKEN) as? String
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        self.session = Alamofire.SessionManager(configuration: configuration)
        
        let params = [
            "user_id" : user_id,
            "lat" : lat,
            "long" :long
            ] as [String : Any]
        
        self.session.request(strurl,
                             method: .post,
                             parameters: params
            ).responseJSON(completionHandler: {(response) in
        
                   print("statusCode update Coordinate is: ", response.result.isSuccess && ((response.response?.statusCode) != nil))
                
                debugPrint(response)
                if response.result.isSuccess && response.response?.statusCode == 200{
                    let details  = response.result.value!
                    onComplete!(details,nil )
                }else{
                    onComplete!(nil,nil )
                }
            })
    }
    
    func updateDeviceToken(user_id: String, deviceToken: String, onComplete: ServiceResponse?){
        
        let URL = root_url+"update-devicetoken"
        
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Content-Type"] = ("application/json")
        headers["Authorization"] = UserDefaults.standard.object(forKey: Constant.User.AUTH_TOKEN) as? String
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        self.session = Alamofire.SessionManager(configuration: configuration)
        
        let params = [
            "user_id" : user_id,
            "device_token" : deviceToken,
            ] as [String : Any]
        
        self.session.request(URL,
                             method: .post,
                             parameters: params
            ).responseJSON(completionHandler: {(response) in
               //  print("statusCode Device is: ", response.result.isSuccess && ((response.response?.statusCode) != nil))
              //  debugPrint(response)
                if response.result.isSuccess && response.response?.statusCode == 200{
                    
                    let details  = response.result.value!
                    onComplete!(details,nil )
                }else{
                    onComplete!(nil,nil )
                }
            })
     }
/*
    func updatePartnerStatus(partner_id: String, partner_status: String,onComplete: ServiceResponse?){
        
        let URL = root_url+"updatePartnerStatus"
        
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Content-Type"] = ("application/json")
        headers["Authorization"] = UserDefaults.standard.object(forKey: Constant.User.AUTH_TOKEN) as? String
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        self.session = Alamofire.SessionManager(configuration: configuration)
        
        let params = [
            "partner_id" : partner_id,
            "partner_status" :partner_status
            ] as [String : Any]
        
        print(params)
        
        self.session.request(URL,
                             method: .post,
                             parameters: params
            ).responseJSON(completionHandler: {(response) in
                debugPrint(response)
                if response.result.isSuccess && response.response?.statusCode == 200{
                    let details  = response.result.value!
                    onComplete!(details,nil )
                }else{
                    onComplete!(nil,nil )
                }
            })
    }
*/
    func logout(onComplete: ServiceResponse?){
        
        let URL = root_url+"logout?user_id=\((UserDefaults.standard.object(forKey: Constant.User.USER_ID) as? String)!)"
        
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Content-Type"] = ("application/json")
        headers["Authorization"] = UserDefaults.standard.object(forKey: Constant.User.AUTH_TOKEN) as? String
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        self.session = Alamofire.SessionManager(configuration: configuration)
        
        self.session.request(URL,
                             method: .get,
                             parameters: nil
            ).responseJSON(completionHandler: {(response) in
               // debugPrint(response)
                if response.result.isSuccess && response.response?.statusCode == 200{
                    let details  = response.result.value!
                    onComplete!(details,nil )
                }else{
                    onComplete!(nil,nil )
                }
            })
    }



}
