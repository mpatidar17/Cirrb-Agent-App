//
//  AcceptOrderViewController.swift
//  Cirrb Agent
//
//  Created by mac on 19/05/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class AcceptOrderViewController: UIViewController {
    
    @IBOutlet weak var lblTimeCounter: UILabel!
    
    @IBOutlet weak var lblIncoming: UILabel!
    
    @IBOutlet weak var denyButton: UIButton!
    
    @IBOutlet weak var acceptButton: UIButton!
    
    var userID = String()
    var authToken = String()
    var detailDict = NSDictionary()
    var order_ID = Int()
    var count = 15
    var timer = Timer()

    var appDel: AppDelegate! = (UIApplication.shared.delegate as! AppDelegate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDel.apiManager.setCurrentViewController(vc: self)
        
        self.navigationController?.isNavigationBarHidden = true
       UIApplication.shared.statusBarStyle = .default
        
       timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(AcceptOrderViewController.counter), userInfo: nil, repeats: true)
        
       order_ID = UserDefaults.standard.object(forKey: "orderID")as! Int
        
    }
    func counter() {
        count -= 1
   
        if count == 0{
            timer.invalidate()
            _ = self.navigationController?.popViewController(animated: true)
        }else{
            lblTimeCounter.text = "\(count)"            
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
        
        if appDel.flagLanguage == 1{
            
            let path = Bundle.main.path(forResource: "ar-SA", ofType: "lproj")
            
            let bundal = Bundle.init(path: path!)! as Bundle
            
            let btn = bundal.localizedString(forKey: "ACCEPT", value: nil, table: nil)
            
            let btn2 = bundal.localizedString(forKey: "DENY", value: nil, table: nil)
            
            lblIncoming.text = bundal.localizedString(forKey: "INCOMING ORDER", value: nil, table: nil)
            
            denyButton.setTitle(btn2, for: .normal)
            
            acceptButton.setTitle(btn, for: .normal)
            
        }else{
            
            let path = Bundle.main.path(forResource: "en", ofType: "lproj")
            
            let bundal = Bundle.init(path: path!)! as Bundle
            
            let btn = bundal.localizedString(forKey: "ACCEPT", value: nil, table: nil)
            
            let btn2 = bundal.localizedString(forKey: "DENY", value: nil, table: nil)
            
            lblIncoming.text = bundal.localizedString(forKey: "INCOMING ORDER", value: nil, table: nil)
            
            denyButton.setTitle(btn2, for: .normal)
            
            acceptButton.setTitle(btn, for: .normal)

        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AcceptOrder_ShowDetail"){
            let selectedvc = segue.destination as! NewOrderViewController
        }
    }
    @IBAction func clickAccept(_ sender: Any) {
        
        let partnerID = UserDefaults.standard.object(forKey: Constant.User.USER_ID) as! String
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.label.text = "Loading"
        orderAccpect(partnerID: partnerID)
    }
    private func orderAccpect(partnerID: String) {
        self.appDel.apiManager.accpectOrder(partner_id: partnerID,  order_id: order_ID, approval: "accept", onComplete: {
            (details, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if details != nil{
                
                self.detailDict = details as! NSDictionary
                let status = self.detailDict.value(forKey: "status") as! String
                
                if status == "success" {
                    
                    let encodedData = NSKeyedArchiver.archivedData(withRootObject: self.detailDict)
                    
                    UserDefaults.standard.set(encodedData, forKey: "orderDetails")
                    
                let subTotalAmt = (((self.detailDict.value(forKey: "details") as AnyObject).value(forKey: "order") as AnyObject).value(forKey: "sub_total") as AnyObject) as! Float
                
                UserDefaults.standard.set(subTotalAmt, forKey: "subTotalAmt")
                
                let totalAmt = (((self.detailDict.value(forKey: "details") as AnyObject).value(forKey: "order") as AnyObject).value(forKey: "total") as AnyObject) as! Float
                
                UserDefaults.standard.set(totalAmt, forKey: "totalAmt")
                
                let deliveryFees = (((self.detailDict.value(forKey: "details") as AnyObject).value(forKey: "order") as AnyObject).value(forKey: "delivery_fees") as AnyObject) as! Float
                
                UserDefaults.standard.set(deliveryFees, forKey: "deliveryFees")
                    
                    
                    let order_payable = (((self.detailDict.value(forKey: "details") as AnyObject).value(forKey: "order") as AnyObject).value(forKey: "order_payable") as AnyObject) as! Float
                    
                    UserDefaults.standard.set(order_payable, forKey: "order_payable")
                    
                    let branchLat = (((self.detailDict.value(forKey: "details") as AnyObject).value(forKey: "order") as AnyObject).value(forKey: "branch_lat") as AnyObject) as! Float
                    
                    UserDefaults.standard.set(branchLat, forKey: "branch_Lat")
                    
                    let branchLong = (((self.detailDict.value(forKey: "details") as AnyObject).value(forKey: "order") as AnyObject).value(forKey: "branch_long") as AnyObject) as! Float
                    
                    UserDefaults.standard.set(branchLong, forKey: "branch_Long")
                                       
                
                    self.performSegue(withIdentifier: "AcceptOrder_ShowDetail", sender: self)
                    
                
                }else{
                    
                    if self.appDel.flagLanguage == 1{
                        
                        let message = self.detailDict.value(forKey: "message") as! String

                        
                        let alert = UIAlertController(title: "محزر", message: message, preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "حسنا", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
                            
                            self.performSegue(withIdentifier: "Deny_Dashboard", sender: self)
                        }));
                        alert.view.tintColor = UIColor.red
                        self.present(alert, animated: true, completion: nil)
                    }else{
                    
                    let message = self.detailDict.value(forKey: "message") as! String
                        
                    let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
                        
                        self.performSegue(withIdentifier: "Deny_Dashboard", sender: self)
                    }));
                    alert.view.tintColor = UIColor.red
                   self.present(alert, animated: true, completion: nil)
                    }
                    
                }
            }else{
                
                let alert = UIAlertController(title: "Alert", message: "Please try again", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
                    
                }));
                alert.view.tintColor = UIColor.red
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    @IBAction func clickDeny(_ sender: Any) {
        
        let partnerID = UserDefaults.standard.object(forKey: Constant.User.USER_ID) as! String
        orderDeny(partnerID: partnerID)
    }
    private func orderDeny(partnerID: String) {
        self.appDel.apiManager.denyOrder(partner_id: partnerID,  order_id: order_ID, approval: "deny", onComplete: {
            (details, error) in
            if details != nil{
                
                self.detailDict = details as! NSDictionary
                let status = self.detailDict.value(forKey: "status") as! String
                
                if status == "success" {
                    
                    if self.appDel.flagLanguage == 1 {
                        
                        let alert = UIAlertController(title: "محزر", message: "تم رفض الطلب بنجاح", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "حسنا", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
                            
                            self.performSegue(withIdentifier: "Deny_Dashboard", sender: self)
                        }));
                        alert.view.tintColor = UIColor.red
                        self.present(alert, animated: true, completion: nil)

                        
                    }else{
                    
                    let alert = UIAlertController(title: "Alert", message: "Order Denial Successful", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
                        
                        self.performSegue(withIdentifier: "Deny_Dashboard", sender: self)
                    }));
                    alert.view.tintColor = UIColor.red
                    self.present(alert, animated: true, completion: nil)
                }
                }else{
                    
                    if self.appDel.flagLanguage == 1 {
                        
                        let alert = UIAlertController(title: "محزر", message: "الخادم ليست ريسبومدينغ، يرجى المحاولة بعد بعض الوقت", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "حسنا", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
                            
                            self.performSegue(withIdentifier: "Deny_Dashboard", sender: self)
                        }));
                        alert.view.tintColor = UIColor.red
                        self.present(alert, animated: true, completion: nil)
                    }else{
                    let alert = UIAlertController(title: "Alert", message: "Server is not respomding, please try after some time", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
                       
                        self.performSegue(withIdentifier: "Deny_Dashboard", sender: self)
                    }));
                    alert.view.tintColor = UIColor.red
                    self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        })
    }

    
}
