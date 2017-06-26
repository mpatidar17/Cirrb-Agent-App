//
//  OrderHitoryViewController.swift
//  Cirrb Agent
//
//  Created by mac on 17/05/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import MBProgressHUD

class allOrderCell: UITableViewCell {
    @IBOutlet weak var lblOrderID: UILabel!
    @IBOutlet weak var lblOrderTotalAmt: UILabel!
    
    var orderHistoryDict = NSDictionary()
    var customerDetails = NSArray()
    
}

class AllOrderViewController: BaseViewController ,UITableViewDelegate, UITableViewDataSource {
    var appDel: AppDelegate! = (UIApplication.shared.delegate as! AppDelegate)
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    
    @IBOutlet weak var tblviewOrderLst: UITableView!
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    var orderList = NSArray()
    var orderListObject = NSDictionary()
    
    var customerDetailsDict = NSDictionary()
    var customerDetails = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDel.apiManager.setCurrentViewController(vc: self)
        
        
        self.automaticallyAdjustsScrollViewInsets = false
        UINavigationBar.appearance().tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = UIColor(red:0.90, green:0.47, blue:0.36, alpha:1.0)
        UIApplication.shared.statusBarStyle = .lightContent
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage())
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //UIColor(red:0.00, green:1.00, blue:0.00, alpha:1.0)
        btnMenu.target = self.revealViewController()
        btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.tblviewOrderLst.separatorStyle = .none
        
        if isInternetAvailable() {
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            if appDel.flagLanguage == 1{
                loadingNotification.label.text = "جار التحميل"
            }else{
                loadingNotification.label.text = "Loading"
            }
            getAllOrderList()
        }else {
            self.ShowAlert("Please check network connection");
        }
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

            let title = bundal.localizedString(forKey: "Orders", value: nil, table: nil)
            
            navigationItem.title = title
            
        }else{
            
            let path = Bundle.main.path(forResource: "en", ofType: "lproj")
            
            let bundal = Bundle.init(path: path!)! as Bundle
            
            let title = bundal.localizedString(forKey: "Orders", value: nil, table: nil)
            
            navigationItem.title = title
            
        }

        
    }
    
    private func getAllOrderList() {
        self.appDel.apiManager.getAllOrderList(onComplete: {
            (details, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if details != nil {
                let orderMenuDict = details as! NSDictionary
                let status = orderMenuDict.value(forKey: "status") as! String
                
                if status == "success"
                {
                    self.orderList = orderMenuDict.object(forKey: "orders") as! NSArray
                    print("self.orderList.count is: ", self.orderList.count)
                    
                    if self.orderList.count > 0 {
                        self.lblNoDataFound.isHidden = true
                        self.tblviewOrderLst.isHidden = false
                        self.tblviewOrderLst.reloadData()
                    }else {
                        self.tblviewOrderLst.isHidden = true
                        self.lblNoDataFound.isHidden = false
                    }
                    
                    for i in 0..<self.orderList.count {
                        
                        self.customerDetailsDict = (self.orderList.object(at: i) as AnyObject) as! NSDictionary
                        
                        print("partnerDetailsDict is >>",self.customerDetailsDict)
                        
                        self.customerDetails =  (self.orderList.object(at: i) as AnyObject).value(forKey: "user") as! NSArray
                        
                        print("customerDetails",self.customerDetails)
                    }
                }else{
                    let message = orderMenuDict.value(forKey: "message") as! String
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblviewOrderLst.dequeueReusableCell(withIdentifier: "allOrderCell", for: indexPath) as! allOrderCell
        
        cell.lblOrderID?.text = "#" + String(((orderList.object(at: indexPath.row) as AnyObject).value(forKey: "id") as AnyObject) as! Int)
        
        cell.lblOrderTotalAmt?.text = "SR " + String(((orderList.object(at: indexPath.row) as AnyObject).value(forKey: "total") as AnyObject) as! Float)
        
        cell.orderHistoryDict = (orderList.object(at: indexPath.row) as AnyObject) as! NSDictionary
        
        cell.customerDetails = (self.orderList.object(at: indexPath.row) as AnyObject).value(forKey: "user") as! NSArray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return orderList.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tblviewOrderLst.indexPathForSelectedRow;
        let currentCell = tblviewOrderLst.cellForRow(at: indexPath!) as! allOrderCell
        self.orderListObject = currentCell.orderHistoryDict
        self.customerDetails = currentCell.customerDetails
        currentCell.selectionStyle = .none
        self.performSegue(withIdentifier: "AllOrder_History", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "AllOrder_History") {
            let selectedvc = segue.destination as! OrderHistoryViewController
            selectedvc.orderHistoryDict = self.orderListObject
            selectedvc.customerDetails = self.customerDetails
        }
    }

    

    
    
    

}
