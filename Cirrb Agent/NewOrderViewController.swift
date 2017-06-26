//
//  NewOrderViewController.swift
//  Cirrb Agent
//
//  Created by Yuvasoft on 6/19/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class NewOrderViewController: UIViewController {
    
    
    @IBOutlet weak var directionButton: UIButton!
    
    @IBOutlet weak var orderDetailsButton: UIButton!
    
    var container: ContainerViewController!
   
    var appDel: AppDelegate! = (UIApplication.shared.delegate as! AppDelegate)


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        UINavigationBar.appearance().tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = UIColor(red:0.90, green:0.47, blue:0.36, alpha:1.0)
        //UIApplication.shared.statusBarStyle = .lightContent
        self.navigationItem.hidesBackButton = true;
        container!.segueIdentifierReceivedFromParent("NewOrder_Directions")
        
        
        directionButton.layer.cornerRadius = 3
        orderDetailsButton.layer.cornerRadius = 3
        
//        directionButton.backgroundColor = UIColor(red:0.75, green:0.34, blue:0.25, alpha:1.0)
//        orderDetailsButton.setTitleColor(UIColor.gray, for: .normal)
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
            
            let btn = bundal.localizedString(forKey: "MAP", value: nil, table: nil)
            
            let btn2 = bundal.localizedString(forKey: "ORDER DETAILS", value: nil, table: nil)
            
            directionButton.setTitle(btn, for: .normal)
            
            orderDetailsButton.setTitle(btn2, for: .normal)
            
            let title = bundal.localizedString(forKey: "New Order", value: nil, table: nil)
            
            navigationItem.title = title

            
        }else{
            
            let path = Bundle.main.path(forResource: "en", ofType: "lproj")
            
            let bundal = Bundle.init(path: path!)! as Bundle
            
            let btn = bundal.localizedString(forKey: "MAP", value: nil, table: nil)
            
            let btn2 = bundal.localizedString(forKey: "ORDER DETAILS", value: nil, table: nil)
            
            directionButton.setTitle(btn, for: .normal)
            
            orderDetailsButton.setTitle(btn2, for: .normal)
            
            let title = bundal.localizedString(forKey: "New Order", value: nil, table: nil)
            
            navigationItem.title = title
            
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "container"{
            
            container = segue.destination as! ContainerViewController
         }
    }
    @IBAction func clickDirection(_ sender: Any) {
        
        container!.segueIdentifierReceivedFromParent("NewOrder_Directions")
        
        
//        directionButton.setTitleColor(UIColor.white, for: .normal)
//        directionButton.backgroundColor = UIColor(red:0.75, green:0.34, blue:0.25, alpha:1.0)
//        
//        orderDetailsButton.setTitleColor(UIColor.gray, for: .normal)
//        orderDetailsButton.backgroundColor = UIColor(red:0.75, green:0.34, blue:0.25, alpha:1.0)
        
    }
    
    @IBAction func lickOrderDetails(_ sender: Any) {

        container!.segueIdentifierReceivedFromParent("NewOrder_OrderDetails")
        
//        directionButton.setTitleColor(UIColor.gray, for: .normal)
//        directionButton.backgroundColor = UIColor(red:0.75, green:0.34, blue:0.25, alpha:1.0)
//        
//        orderDetailsButton.setTitleColor(UIColor.white, for: .normal)
//        orderDetailsButton.backgroundColor = UIColor(red:0.75, green:0.34, blue:0.25, alpha:1.0)
    }

}
