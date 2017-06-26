//
//  ShowOrdeDetailsViewController.swift
//  Cirrb Agent
//
//  Created by Yuvasoft on 6/19/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
class orderDetailsCell: UITableViewCell {
    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var itemQuantityLabel: UILabel!
    
    @IBOutlet weak var itemPriceLabel: UILabel!
    
}
class ShowOrdeDetailsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var orderDetailsTableView: UITableView!
    
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var deliveryChargesLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var lblOrderdetails: UILabel!
    
    
    @IBOutlet weak var lblSubTotal: UILabel!
    
    @IBOutlet weak var lblDeliveryCharges: UILabel!
    
    @IBOutlet weak var lblReceivableCharges: UILabel!
    
    @IBOutlet weak var completeDeliveryButton: defaultButton!
    
    @IBOutlet weak var lblGrandTotal: UILabel!
    
    @IBOutlet weak var lblPayble: UILabel!
    
    
    
    var orderInfoDict = NSDictionary()
    var Order = NSArray()
    
    var acceptDict = NSDictionary()
    
    var appDel: AppDelegate! = (UIApplication.shared.delegate as! AppDelegate)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
              
        
        let subTotalAmt = UserDefaults.standard.object(forKey: "subTotalAmt") as! Float
        subTotalLabel.text = "SR " + String(subTotalAmt)
        
        let deliveryCharges = UserDefaults.standard.object(forKey: "deliveryFees") as! Float
        deliveryChargesLabel.text = "SR " + String(deliveryCharges)
        
        let totalAmt = UserDefaults.standard.object(forKey: "totalAmt") as! Float
        totalLabel.text = "SR " + String(totalAmt)
        
        let order_payable = UserDefaults.standard.object(forKey: "order_payable")as! Float
        
        lblPayble.text = "SR " + String(order_payable)
        
        let decoded  = UserDefaults.standard.object(forKey: "orderDetails") as! Data
        let decodedData = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! NSDictionary
        print("decodedTeams >>>",decodedData)
        
        Order = (((decodedData.value(forKey: "details")as AnyObject).value(forKey: "order")as AnyObject).value(forKey: "order_list") as AnyObject) as! NSArray
        print("Order>>>>",Order)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidDisappear(_ animated: Bool) {
           }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        
        if appDel.flagLanguage == 1{
            
            let path = Bundle.main.path(forResource: "ar-SA", ofType: "lproj")
            
            let bundal = Bundle.init(path: path!)! as Bundle
            
            let btn = bundal.localizedString(forKey: "COMPLETE DELIVERY", value: nil, table: nil)
            
            lblOrderdetails.text = bundal.localizedString(forKey: "ORDER DETAILS", value: nil, table: nil)
            
            lblSubTotal.text = bundal.localizedString(forKey: "Sub Total", value: nil, table: nil)
            
            lblDeliveryCharges.text = bundal.localizedString(forKey: "Delivery charges", value: nil, table: nil)
            
            lblReceivableCharges.text = bundal.localizedString(forKey: "Receivable Charges", value: nil, table: nil)
            
            lblGrandTotal.text = bundal.localizedString(forKey: "GRAND TOTAL", value: nil, table: nil)
            
            completeDeliveryButton.setTitle(btn, for: .normal)
            
        }else{
            
            let path = Bundle.main.path(forResource: "en", ofType: "lproj")
            
            let bundal = Bundle.init(path: path!)! as Bundle
            
            let btn = bundal.localizedString(forKey: "COMPLETE DELIVERY", value: nil, table: nil)
            
            lblOrderdetails.text = bundal.localizedString(forKey: "ORDER DETAILS", value: nil, table: nil)
            
            lblSubTotal.text = bundal.localizedString(forKey: "Sub Total", value: nil, table: nil)
            
            lblDeliveryCharges.text = bundal.localizedString(forKey: "Delivery charges", value: nil, table: nil)
            
            lblReceivableCharges.text = bundal.localizedString(forKey: "Receivable Charges", value: nil, table: nil)
            
            lblGrandTotal.text = bundal.localizedString(forKey: "GRAND TOTAL", value: nil, table: nil)
            
            completeDeliveryButton.setTitle(btn, for: .normal)
        }
    }
    var nameInfoArr = NSDictionary()
    
    func getUserNameList(_ notification: NSNotification) {
        
        if let name = notification.object as? NSDictionary
        {
            nameInfoArr = name
        }
        
        print("nameInfoArr is>>>",nameInfoArr)
    }
    @IBAction func clickCompleteDelivery(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowDetail_Payment", sender: self)
    }
    //MARK: Order details TableView:
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Order.count
       // return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = orderDetailsTableView.dequeueReusableCell(withIdentifier: "orderDetailsCell", for: indexPath) as! orderDetailsCell
        
        cell.itemNameLabel.text = (((Order.object(at: indexPath.row) as AnyObject).value(forKey: "name") as AnyObject) as! String)
        
        let cost = String(((Order.object(at: indexPath.row) as AnyObject).value(forKey: "per_menu_cost") as AnyObject) as! Float)
        
        cell.itemPriceLabel.text = "SR " + cost
        
        
        let quantity = String(((Order.object(at: indexPath.row) as AnyObject).value(forKey: "quantity") as AnyObject) as! Int)
        
        cell.itemQuantityLabel.text = quantity
        
        return cell
    }

}
