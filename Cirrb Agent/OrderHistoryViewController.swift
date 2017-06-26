//
//  OrderHistoryViewController.swift
//  cirrb app
//
//  Created by mac on 02/05/17.
//  Copyright © 2017 3WebBox, Inc. All rights reserved.
//

import UIKit
import Kingfisher

class orderHistoryItemCell: UITableViewCell {
    @IBOutlet weak var lblMenuTitle: UILabel!
    @IBOutlet weak var lblMenuPrice: UILabel!
    @IBOutlet weak var lblMenuQuantity: UILabel!
    
}
class OrderHistoryViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var tblViewOrderHistory: UITableView!
    
    @IBOutlet weak var lblCustomerInfo: UILabel!
    
   
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblGrandTotal: UILabel!
    @IBOutlet weak var lblDeliveryCharge: UILabel!
    
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var driverPhoneLabel: UILabel!
    @IBOutlet weak var driverEmailLabel: UILabel!
    @IBOutlet weak var driverImageView: UIImageView!
    
    @IBOutlet weak var driverInfoView: UIView!
    @IBOutlet weak var driverInfoViewHight: NSLayoutConstraint!
    
    @IBOutlet weak var lblOrderTotal: UILabel!
    @IBOutlet weak var lbldeliveryCharges: UILabel!
    @IBOutlet weak var lblgrandTotal: UILabel!
    
    @IBOutlet weak var lblPayedTotal: UILabel!
        
    @IBOutlet weak var lblpayedByCustomer: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailIdLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    

    
    var orderHistoryDict = NSDictionary()
    var orderHistoryLst = NSArray()
    
    var customerDetails = NSArray()
    
    var appDel: AppDelegate! = (UIApplication.shared.delegate as! AppDelegate)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        UINavigationBar.appearance().tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.isNavigationBarHidden = false
        self.automaticallyAdjustsScrollViewInsets = false

        
        self.orderHistoryLst = orderHistoryDict.value(forKey: "order_list") as! NSArray
        
        self.lblTotalAmount.text = "SR " + String((orderHistoryDict.value(forKey: "sub_total") as AnyObject) as! Float)
        self.lblDeliveryCharge.text = "SR " + String((orderHistoryDict.value(forKey: "delivery_fees") as AnyObject) as! Float)
        self.lblGrandTotal.text = "SR " + String((orderHistoryDict.value(forKey: "total") as AnyObject) as! Float)
        
        let payedTotal = ((orderHistoryDict.value(forKey: "total") as AnyObject) as! Float) + ((orderHistoryDict.value(forKey: "remain_balance") as AnyObject) as! Float)
        
        let OrderStatus = ((orderHistoryDict.value(forKey: "status") as AnyObject) as! String)
        
        if OrderStatus == "closed"{
            lblPayedTotal.text = "SR " + String(payedTotal)
        }else{
            lblPayedTotal.isHidden = true
            lblpayedByCustomer.isHidden = true
        }
        self.tblViewOrderHistory.separatorStyle = .none
        
        customerDetails.adding("Hello")
        
        print("customerDetails is::>>>>",self.customerDetails)
        
        driverInformation()
        
       // driverInfoView.constant = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if appDel.flagLanguage == 1{
            
            let path = Bundle.main.path(forResource: "ar-SA", ofType: "lproj")
            
            let bundal = Bundle.init(path: path!)! as Bundle
            
            lblCustomerInfo.text = bundal.localizedString(forKey: "Customer Details", value: nil, table: nil)
            
            lblOrderTotal.text = bundal.localizedString(forKey: "Order total:", value: nil, table: nil)
            
            lbldeliveryCharges.text = bundal.localizedString(forKey: "Delivery charges:", value: nil, table: nil)
            
            lblgrandTotal.text = bundal.localizedString(forKey: "Grand total:", value: nil, table: nil)
            
            lblpayedByCustomer.text = bundal.localizedString(forKey: "Received amount", value: nil, table: nil)
            
            nameLabel.text = bundal.localizedString(forKey: "Name", value: nil, table: nil)
            
//            emailIdLabel.text = bundal.localizedString(forKey: "Email:", value: nil, table: nil)
//            
//            phoneLabel.text = bundal.localizedString(forKey: "Phone", value: nil, table: nil)

            
            let title = bundal.localizedString(forKey: "Order History", value: nil, table: nil)
            
            navigationItem.title = title
            
            
        }else{
            
            let path = Bundle.main.path(forResource: "en", ofType: "lproj")
            
            let bundal = Bundle.init(path: path!)! as Bundle
            
            lblCustomerInfo.text = bundal.localizedString(forKey: "Customer Details", value: nil, table: nil)
            
            lblOrderTotal.text = bundal.localizedString(forKey: "Order total:", value: nil, table: nil)
            
            lbldeliveryCharges.text = bundal.localizedString(forKey: "Delivery charges:", value: nil, table: nil)
            
            lblgrandTotal.text = bundal.localizedString(forKey: "Grand total:", value: nil, table: nil)
            
            lblpayedByCustomer.text = bundal.localizedString(forKey: "Received amount", value: nil, table: nil)
            
            nameLabel.text = bundal.localizedString(forKey: "Name", value: nil, table: nil)
//            
//            emailIdLabel.text = bundal.localizedString(forKey: "Email:", value: nil, table: nil)
//            
//            phoneLabel.text = bundal.localizedString(forKey: "Phone", value: nil, table: nil)
            
            let title = bundal.localizedString(forKey: "Order History", value: nil, table: nil)
            
            navigationItem.title = title
        }
    }
    func driverInformation(){
        
        if (self.customerDetails.count) > 0{
            
            
            driverNameLabel.text = (((self.customerDetails.object(at: 0) as AnyObject).value(forKey: "name") as AnyObject) as! String) + " " + (((self.customerDetails.object(at: 0) as AnyObject).value(forKey: "last_name") as AnyObject) as! String)
            
//            driverPhoneLabel.text = String(((self.customerDetails.object(at: 0) as AnyObject).value(forKey: "phone") as AnyObject) as! Int)
//            
//            driverEmailLabel.text = (((self.customerDetails.object(at: 0) as AnyObject).value(forKey: "email") as AnyObject) as! String)
//            
//            let driverImage = (((self.customerDetails.object(at: 0) as AnyObject).value(forKey: "image") as AnyObject) as! String)
//            let url = URL(string: driverImage)
//            
//            driverImageView.kf.setImage(with: url)
//            driverImageView.layer.cornerRadius = 30
//            driverImageView.layer.masksToBounds = true
//            self.driverImageView.layer.borderWidth = 3
//            self.driverImageView.layer.borderColor = UIColor(red:0.95, green:0.53, blue:0.42, alpha:1.0).cgColor
            driverInfoView.isHidden = false

        }else{
            print("NO DATA FOUND")
            driverNameLabel.isHidden = true
//            driverPhoneLabel.isHidden = true
            driverInfoView.isHidden = true
            driverInfoViewHight.constant = 0
        }
       
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblViewOrderHistory.dequeueReusableCell(withIdentifier: "orderHistoryItemCell", for: indexPath) as! orderHistoryItemCell
        
    
        cell.lblMenuTitle?.text = (((orderHistoryLst.object(at: indexPath.row) as AnyObject).value(forKey: "name") as AnyObject) as! String)
        
        cell.lblMenuPrice?.text = "SR " + String((((orderHistoryLst.object(at: indexPath.row) as AnyObject).value(forKey: "per_menu_cost") as AnyObject) as! Float))
        
        cell.lblMenuQuantity?.text = String((((orderHistoryLst.object(at: indexPath.row) as AnyObject).value(forKey: "quantity") as AnyObject) as! Int))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow;
        let currentCell = tableView.cellForRow(at: indexPath!) as! orderHistoryItemCell
        currentCell.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return orderHistoryLst.count
    }

}
