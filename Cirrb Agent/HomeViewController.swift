//
//  HomeViewController.swift
//  Cirrb Agent
//
//  Created by mac on 12/05/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import Kingfisher
import CoreLocation
import Alamofire

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    var appDel: AppDelegate! = (UIApplication.shared.delegate as! AppDelegate)
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var imgvwProfileHome: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblTotalLimit: UILabel!
    @IBOutlet weak var lblTotalRemainingLimit: UILabel!
    
    @IBOutlet weak var lblInHand: UILabel!
    @IBOutlet weak var lblLimit: UILabel!
    @IBOutlet weak var acceptButton: defaultButton!
    
    var timer: Timer?
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appDel.apiManager.setCurrentViewController(vc: self)
        
        UserDefaults.standard.set(true, forKey: "isLogin")
        
        //let auth_token = UserDefaults.standard.object(forKey: Constant.User.AUTH_TOKEN) as? String
        //print("auth_token",auth_token!)
                
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UIApplication.shared.statusBarStyle = .lightContent
        
        imgvwProfileHome.layer.cornerRadius = 75
        imgvwProfileHome.layer.masksToBounds = true
        self.imgvwProfileHome.layer.borderWidth = 3
        self.imgvwProfileHome.layer.borderColor = UIColor(red:0.90, green:0.47, blue:0.36, alpha:1.0).cgColor
        
        
        
        let imagePath = UserDefaults.standard.object(forKey: Constant.User.IMAGE_PATH) as? String
        
        let url = URL(string: imagePath!)
        self.imgvwProfileHome.kf.setImage(with: url)
        
        
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
        
        menuButton.tintColor = UIColor.white
        
        let fnameValue = UserDefaults.standard.object(forKey: Constant.User.FIRST_NAME)
        let lnameValue = UserDefaults.standard.object(forKey: Constant.User.LAST_NAME)
        
        if fnameValue != nil {
            let fname: String = UserDefaults.standard.object(forKey: Constant.User.FIRST_NAME) as! String
            self.lblUsername.text = fname
        }
        
        if lnameValue != nil {
            let lname: String = UserDefaults.standard.object(forKey: Constant.User.LAST_NAME) as! String
            self.lblUsername.text = String(describing: self.lblUsername.text!) + " " + lname
        }
        
        self.locationManager.delegate = self
        self.locationManager.distanceFilter  = kCLDistanceFilterNone
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        startTimer()
        getUserInfo()
        //getOrders()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        
        if appDel.flagLanguage == 1{
            
            let path = Bundle.main.path(forResource: "ar-SA", ofType: "lproj")
            
            let bundal = Bundle.init(path: path!)! as Bundle
            
            let btn = bundal.localizedString(forKey: "ACCEPT ORDER", value: nil, table: nil)
            
            lblInHand.text = bundal.localizedString(forKey: "In Hand", value: nil, table: nil)
            
            lblLimit.text = bundal.localizedString(forKey: "Limit", value: nil, table: nil)
            
            acceptButton.setTitle(btn, for: .normal)
           
        }else{
            
            let path = Bundle.main.path(forResource: "en", ofType: "lproj")
            
            let bundal = Bundle.init(path: path!)! as Bundle
            
            let btn = bundal.localizedString(forKey: "ACCEPT ORDER", value: nil, table: nil)

            lblInHand.text = bundal.localizedString(forKey: "In Hand", value: nil, table: nil)
            
            lblLimit.text = bundal.localizedString(forKey: "Limit", value: nil, table: nil)
            
            acceptButton.setTitle(btn, for: .normal)
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func clickAcceptOrderButton(_ sender: Any) {

        self.performSegue(withIdentifier: "Dashboard_SearchOrder", sender: self)
        //let partnerID = UserDefaults.standard.object(forKey: Constant.User.USER_ID) as! String
        //statusUpdate(partnerID: partnerID)
        statusUpdate()
    }
   /* private func statusUpdate(partnerID: String) {
        
        self.appDel.apiManager.updatePartnerStatus(partner_id: partnerID, partner_status: "free", onComplete: {
            (details, error) in
            if details != nil{
            let detailDict = details as! NSDictionary
            let status = detailDict.value(forKey: "status") as! String
            if status == "success" {
                      print("Status Updated")
            }
            else{
                print("Status is Not Updated")
            }
          }
        })
    }  */
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
           locationManager.stopUpdatingLocation()
            UserDefaults.standard.setValue(String(location.coordinate.latitude), forKey: Constant.User.CURRENT_LATITUDE)
            UserDefaults.standard.setValue(String(location.coordinate.longitude), forKey: Constant.User.CURRENT_LONGITUDE)
            
        }
        
    }
    private func getUserInfo() {
        self.appDel.apiManager.getUserBalanceDetails(onComplete: {
            (details, error) in
            if details != nil {
              //  print("Balance Details: ",details!)
                let detailDict = details as! NSDictionary
                
                let status = detailDict.value(forKey: "status") as! String
                
                if status == "success"{
                let balanceDict = detailDict.value(forKey: "details") as AnyObject
                let balance = balanceDict.value(forKey: "cash_in_hand") as! Float
                let order_limit = balanceDict.value(forKey: "order_limit") as! Float
                
                self.lblTotalRemainingLimit.text = "SR " + String(describing: balance)
        
                self.lblTotalLimit.text =  "SR " + String(order_limit)
                }else{
                    let message = detailDict.value(forKey: "message") as! String
                    let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
                        UserDefaults.standard.removeObject(forKey:"isLogin")
                        
                let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let desController = mainstoryboard.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
                        self.present(desController, animated: true, completion: nil)
                    }));
               alert.view.tintColor = UIColor.red
               self.present(alert, animated: true, completion: nil)

                }
            }
        })
    }

    func startTimer(){
        
        timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(UpdateUserCoordinates), userInfo: nil, repeats: true)
    }
    
    func stopTimer(){
        timer?.invalidate()
    }
    /*
    func coordinateReload(){
        
        let userId = UserDefaults.standard.object(forKey: Constant.User.USER_ID) as! String
        
        let tokenStr: String? = UserDefaults.standard.object(forKey: "deviceTokenKey") as? String
  
        let s_latitude = (UserDefaults.standard.object(forKey: Constant.User.CURRENT_LATITUDE) as? String)!
        print("s_latitude is :>",s_latitude)
        
        let s_longitude = (UserDefaults.standard.object(forKey: Constant.User.CURRENT_LONGITUDE) as? String)!
        print("s_longitude is :>",s_longitude)
        
        updateCoordinates(user_id: userId, lat: s_latitude, long: s_longitude)
        
        if tokenStr != nil {
            self.updateDeviceToken(user_id: userId, deviceToken: tokenStr!)
        }
    }
    private func updateCoordinates(user_id: String, lat: String, long: String) {
        self.appDel.apiManager.updateCoordinate(user_id: user_id, lat: lat, long: long, onComplete: {
            (details, error) in
            if details != nil {
                let detailDict = details as! NSDictionary
                let status = detailDict.value(forKey: "status") as! String
                
                if status == "success" {
               //     print("Coordinate is Updated")
                }
                else{
               // print("Not Updated")
                }
            }
        })
    }*/
    private func updateDeviceToken(user_id: String, deviceToken: String) {
        self.appDel.apiManager.updateDeviceToken(user_id: user_id, deviceToken: deviceToken, onComplete: {
            (details, error) in
            if details != nil {
                let detailDict = details as! NSDictionary
                let status = detailDict.value(forKey: "status") as! String
                if status == "success" {
                 //   print("Device Token is Updated")
                }
                else{
                   // print("Device Token is Not Updated")
                }
            }
        })
    }
    
    
    func UpdateUserCoordinates(){
        
        let urlSignIn: String = "http://api.cirrb.com/api/update-coordinates"
        
        let u_latitude = (UserDefaults.standard.object(forKey: Constant.User.CURRENT_LATITUDE) as? String)!
        print("u_latitude is :>",u_latitude)
        
        let u_longitude = (UserDefaults.standard.object(forKey: Constant.User.CURRENT_LONGITUDE) as? String)!
        //print("u_longitude is :>",u_longitude)
        
        let userId = UserDefaults.standard.object(forKey: Constant.User.USER_ID) as! String
        
        let tokenStr: String? = UserDefaults.standard.object(forKey: "deviceTokenKey") as? String
        
        if tokenStr != nil {
            self.updateDeviceToken(user_id: userId, deviceToken: tokenStr!)
        }
        
      //  if u_latitude != "" {
        
        let auth_token = UserDefaults.standard.object(forKey: Constant.User.AUTH_TOKEN) as? String
        print("auth_token",auth_token!)
        
        let Auth_header : HTTPHeaders = [ "Authorization" : auth_token! ]
        
        let userObject = ["user_id": userId , "lat": u_latitude, "long": u_longitude ];
        
        print("userObject",userObject)
        
        //Alamofire.request(urlSignIn, method: .post, parameters: userObject, encoding: JSONEncoding.default)
         //   .responseJSON { response in
        
         Alamofire.request(urlSignIn, method: .post, parameters: userObject, encoding: JSONEncoding.default, headers: Auth_header).responseJSON { response in
                
                print("response is: ",response)
                
                if response.result.isSuccess  && response.response?.statusCode == 200{
                    
                    print("Update User Coordinate")
                }
                else{
                    
                    print("Not Update User Coordinate")
                    
                }}
       // }
    }
    
    func statusUpdate() {
        
        let urlSignIn: String = "http://api.cirrb.com/api/updatePartnerStatus"
        
        let userId = UserDefaults.standard.object(forKey: Constant.User.USER_ID) as! String
        
        let userObject = ["partner_id": userId , "partner_status": "free" ];
        
        print("userObject",userObject)
        
        let auth_token = UserDefaults.standard.object(forKey: Constant.User.AUTH_TOKEN) as? String
        print("auth_token",auth_token!)
        
        let Auth_header : HTTPHeaders = [ "Authorization" : auth_token! ]
        
//        Alamofire.request(urlSignIn, method: .post, parameters: userObject, encoding: JSONEncoding.default)
//            .responseJSON { response in
        
        Alamofire.request(urlSignIn, method: .post, parameters: userObject, encoding: JSONEncoding.default, headers: Auth_header).responseJSON { response in
            
                print("response is: ",response)
                
                if response.result.isSuccess  && response.response?.statusCode == 200{
                    
                    print("Status Updated")
                }
                else{
                     print("Status is not Updated")
                }}
        
    }
    
}
