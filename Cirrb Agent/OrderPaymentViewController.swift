//
//  OrderPaymentViewController.swift
//  Cirrb Agent
//
//  Created by mac on 19/05/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import MBProgressHUD

class OrderPaymentViewController: BaseViewController,UITextFieldDelegate {

    @IBOutlet weak var edtEnterAmount: UITextField!
    
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    @IBOutlet weak var lblReceiverdAmount: UILabel!
    
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var submitButton: defaultButton!
        
    var order_ID = String()
    var partnerID = String()
    var strTxtField = String()

     var appDel: AppDelegate! = (UIApplication.shared.delegate as! AppDelegate)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.appDel.apiManager.setCurrentViewController(vc: self)

        self.navigationController?.isNavigationBarHidden = false
        UINavigationBar.appearance().tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = UIColor(red:0.75, green:0.34, blue:0.25, alpha:1.0)
        self.navigationItem.hidesBackButton = true;
        
        let totalAmt = UserDefaults.standard.object(forKey: "totalAmt") as! Float
        
        let order_payable = UserDefaults.standard.object(forKey: "order_payable")as! Float
        
        totalAmountLabel.text = String(order_payable)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        
        if appDel.flagLanguage == 1{
            
            let path = Bundle.main.path(forResource: "ar-SA", ofType: "lproj")
            
            let bundal = Bundle.init(path: path!)! as Bundle
            
            let btn = bundal.localizedString(forKey: "SUBMIT", value: nil, table: nil)
            
            lblReceiverdAmount.text = bundal.localizedString(forKey: "RECEIVED AMOUNT", value: nil, table: nil)
            
            lblAmount.text = bundal.localizedString(forKey: "Received amount must be equal or more than the receivable total", value: nil, table: nil)
            
            submitButton.setTitle(btn, for: .normal)
            
            let title = bundal.localizedString(forKey: "COMPLETE DELIVERY", value: nil, table: nil)
            
            navigationItem.title = title
            
        }else{
            
            let path = Bundle.main.path(forResource: "en", ofType: "lproj")
            
            let bundal = Bundle.init(path: path!)! as Bundle
            
            let btn = bundal.localizedString(forKey: "SUBMIT", value: nil, table: nil)
            
            lblReceiverdAmount.text = bundal.localizedString(forKey: "RECEIVED AMOUNT", value: nil, table: nil)
            
            lblAmount.text = bundal.localizedString(forKey: "Received amount must be equal or more than the receivable total", value: nil, table: nil)
            
            submitButton.setTitle(btn, for: .normal)
            
            let title = bundal.localizedString(forKey: "COMPLETE DELIVERY", value: nil, table: nil)
            
            navigationItem.title = title
        }

        
    }
    @IBAction func clickPaymentSubmit(_ sender: Any) {
     
        order_ID = String(UserDefaults.standard.object(forKey: "orderID")as! Int)
        
        partnerID = UserDefaults.standard.object(forKey: Constant.User.USER_ID) as! String
        
        strTxtField = edtEnterAmount.text!
        let totalLabel:String?  = totalAmountLabel.text!
     
        let txtField = Float(strTxtField)
        let lbl = Float(totalLabel!)
        
        if strTxtField.characters.count == 0 {
            if appDel.flagLanguage == 1{
                self.ShowAlert("لا يمكن ترك الحقول فارغة");
            }else{
                self.ShowAlert("Fields can't be blank");
            }
        }else if (txtField?.isLess(than: lbl!))!{
            if appDel.flagLanguage == 1{
                self.ShowAlert("الرجاء إدخال المبلغ الصحيح");
            }else{
            self.ShowAlert("Please enter the correct amount");
            }
        }else{
            if isInternetAvailable() {
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
                if appDel.flagLanguage == 1{
                    loadingNotification.label.text = "جار التحميل"
                }else{
                     loadingNotification.label.text = "Loading"
                }
            paymentDone(order_id: order_ID, partner_id: partnerID, amount: strTxtField)
            }else {
                self.ShowAlert("Please check network connection");
            }
        }
    }
    private func paymentDone(order_id: String, partner_id: String, amount: String) {
        self.appDel.apiManager.payment(order_id: order_id, partner_id: partner_id, amount: amount, onComplete: {
            (details, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if details != nil {
                let detailDict = details as! NSDictionary
                let status = detailDict.value(forKey: "status") as! String
                let message = detailDict.value(forKey: "message") as! String
                if status == "success" {
                    self.performSegue(withIdentifier: "Payment_Congratulation", sender: self)
                }
                else{
                    
                    if self.appDel.flagLanguage == 1{
                        
                        let alert = UIAlertController(title: "محزر", message: "تم الدفع بالفعل", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "حسنا", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
                            
                            self.performSegue(withIdentifier: "Payment_Congratulation", sender: self)
                        }))
                        alert.view.tintColor = UIColor.red
                        self.present(alert, animated: true, completion: nil)
                        
                    }else{
                 
                    let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
                        
                        self.performSegue(withIdentifier: "Payment_Congratulation", sender: self)
                     }))
                    alert.view.tintColor = UIColor.red
                   self.present(alert, animated: true, completion: nil)
                    
                    print("FAil PAYMENT")
                    }
                }
            }
            
        })
    }


}
