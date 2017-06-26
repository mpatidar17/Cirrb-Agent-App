//
//  SearchOrderViewController.swift
//  Cirrb Agent
//
//  Created by mac on 19/05/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import Alamofire

class SearchOrderViewController: UIViewController {
    
    @IBOutlet weak var lblLookingUp: UILabel!
    
    @IBOutlet weak var stopOrderButton: defaultButton!
    
    
    var orderSearch = NSDictionary()
    var searchCircle = Pulsator()
    var timer: Timer?
    var timerApi: Timer?

    var appDel: AppDelegate! = (UIApplication.shared.delegate as! AppDelegate)

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.appDel.apiManager.setCurrentViewController(vc: self)
       
        self.navigationController?.isNavigationBarHidden = true
        UIApplication.shared.statusBarStyle = .default
        
        searchCircle.position = view.center
        view.layer.addSublayer(searchCircle)
     
        searchCircle.start(  searchOrders()  )
        
        searchCircle.numPulse = 5;
        searchCircle.radius = 200
        searchCircle.backgroundColor = UIColor(red:0.90, green:0.47, blue:0.36, alpha:1.0).cgColor
        searchCircle.animationDuration = 7
        
         self.timerApi = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.searchOrders), userInfo: nil, repeats: true)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
          searchCircle.start(searchOrders())
        
        if appDel.flagLanguage == 1{
            
            let path = Bundle.main.path(forResource: "ar-SA", ofType: "lproj")
            
            let bundal = Bundle.init(path: path!)! as Bundle
            
            let btn = bundal.localizedString(forKey: "STOP ORDER", value: nil, table: nil)
            
            lblLookingUp.text = bundal.localizedString(forKey: "LOOKING UP,PLEASE WAIT....", value: nil, table: nil)
            
            stopOrderButton.setTitle(btn, for: .normal)
            
        }else{
            
            let path = Bundle.main.path(forResource: "en", ofType: "lproj")
            
            let bundal = Bundle.init(path: path!)! as Bundle
            
            let btn = bundal.localizedString(forKey: "STOP ORDER", value: nil, table: nil)
            
            lblLookingUp.text = bundal.localizedString(forKey: "LOOKING UP,PLEASE WAIT....", value: nil, table: nil)
            
            stopOrderButton.setTitle(btn, for: .normal)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        searchCircle.stop()
        stopTimer()
        
     //   UserDefaults.standard.set("searchingView", forKey: "Search_VC")
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        searchCircle.stop()
//        stopTimer()
//        timerApi?.invalidate()
//        timer?.invalidate()
//
//    }
    
    
    @IBAction func clickStopOrderButton(_ sender: Any) {
        
        searchCircle.stop()
        
        self.performSegue(withIdentifier: "SearchOrder_Dashboard", sender: self)
        
        statusUpdate()
    }
    @objc private func searchOrders() {
        
        self.appDel.apiManager.searchOrders(onComplete: {
            (details, error) in
        
            if details != nil {
        
               let detailDict = details as! NSDictionary
               // print("detailDict is:> ",detailDict)
                
                let status = detailDict.value(forKey: "status") as! String
                
                print("detailDict is>>",detailDict)
                
                print("status",status)
                
               if status == "success"{
                
               let detailArr = ((detailDict.value(forKey: "details") as AnyObject) as? NSArray)
              
                if detailArr?.count == 0{
                   
                    print("HELLO")
                    
                }else{
                let orderID = ((detailDict.value(forKey: "details") as AnyObject).value(forKey: "id") as AnyObject) as! Int
                
                UserDefaults.standard.set(orderID, forKey: "orderID")
                print("orderID is >> ", orderID)
                
                self.startTimer()
                    
                }
               }else if status == "fail"{
                
                let message = detailDict.value(forKey: "message") as! String
                print(message)
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
        
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(orderSearched), userInfo: nil, repeats: true)
        timerApi?.invalidate()
        timerApi = nil
    }
    func stopTimer(){
        timer?.invalidate()
        timerApi?.invalidate()
    }
    func orderSearched(){
        
         self.performSegue(withIdentifier: "SearchOrder_AcceptOrder", sender: self)
         timer?.invalidate()
    }
    func statusUpdate() {
        
        let urlSignIn: String = "http://api.cirrb.com/api/updatePartnerStatus"
        
        let userId = UserDefaults.standard.object(forKey: Constant.User.USER_ID) as! String
        
        let userObject = ["partner_id": userId , "partner_status": "busy" ];
        
       // print("userObject",userObject)
        
        let auth_token = UserDefaults.standard.object(forKey: Constant.User.AUTH_TOKEN) as? String
        print("auth_token",auth_token!)
        
        let Auth_header : HTTPHeaders = [ "Authorization" : auth_token! ]
        
        //        Alamofire.request(urlSignIn, method: .post, parameters: userObject, encoding: JSONEncoding.default)
        //            .responseJSON { response in
        
        Alamofire.request(urlSignIn, method: .post, parameters: userObject, encoding: JSONEncoding.default, headers: Auth_header).responseJSON { response in
        
               // print("response is: ",response)
                
                if response.result.isSuccess  && response.response?.statusCode == 200{
                    
                  //  print("Status Updated")
                }
                else{
                    //print("Status is not Updated")
                }}
        
    }
    
    
}
