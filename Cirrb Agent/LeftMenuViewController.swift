//
//  LeftMenuViewController.swift
//  Cirrb Agent
//
//  Created by mac on 12/05/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class menuCell: UITableViewCell {
    
    @IBOutlet weak var menuNameLabel: UILabel!
    
    @IBOutlet weak var menuIconImageView: UIImageView!
    
}

class LeftMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var menuNameArr:Array = [String]()
    var menuIconArr:Array = [String]()
    
    var menuNameArabic:Array = [String]()
    var appDel: AppDelegate! = (UIApplication.shared.delegate as! AppDelegate)
    
    @IBOutlet weak var menuTableView: UITableView!
    var lastController = UINavigationController()
    //    var iconArray:Array = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuNameArr = ["Home","Order History","Profile","Logout"]
        
        menuIconArr = ["home","order","profile","logout"]
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if appDel.flagLanguage == 1{
            
            menuNameArabic = ["الصفحة الرئيسية","تاريخ الطلب","الملف الشخصي","الخروج"]
            
            menuIconArr = ["home","order","profile","logout"]
            
            menuTableView.reloadData()
            
        }else{
            
            menuNameArr = ["Home","Order History","Profile","Logout"]
            
            menuIconArr = ["home","order","profile","logout"]
            
            menuTableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.revealViewController().frontViewController.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuNameArr.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = menuTableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! menuCell
        if appDel.flagLanguage == 1{
        
            cell.menuNameLabel?.text! = menuNameArabic[indexPath.row]
        }else{
            cell.menuNameLabel?.text! = menuNameArr[indexPath.row]
        }
        cell.menuIconImageView.image = UIImage(named: menuIconArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        let revealviewcontroller:SWRevealViewController = self.revealViewController()
        
        let cell:menuCell = tableView.cellForRow(at: indexPath) as! menuCell
        print(cell.menuNameLabel.text!)
        
        if indexPath.row == 0
        {
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainstoryboard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
            let newFrontController = UINavigationController.init(rootViewController: desController)
            lastController = newFrontController
            revealViewController().pushFrontViewController(newFrontController, animated: true)
        }
        
        else if indexPath.row == 1
        {
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainstoryboard.instantiateViewController(withIdentifier: "orderHitoryViewController") as! AllOrderViewController
            let newFrontController = UINavigationController.init(rootViewController: desController)
            lastController = newFrontController
            revealViewController().pushFrontViewController(newFrontController, animated: true)
        }
        
        else if indexPath.row == 2
        {
            
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainstoryboard.instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
            let newFrontController = UINavigationController.init(rootViewController: desController)
            lastController = newFrontController
            revealViewController().pushFrontViewController(newFrontController, animated: true)
        }
        
        else if indexPath.row == 3
        {
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainstoryboard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
            let newFrontController = UINavigationController.init(rootViewController: desController)
            lastController = newFrontController
            
            revealViewController().pushFrontViewController(lastController, animated: true)
            
            if appDel.flagLanguage == 1{
                
                
                let alert = UIAlertController(title: "محزر", message: "هل أنت متأكد من تسجيل الخروج", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "لا", style: UIAlertActionStyle.cancel, handler: nil));
                //event handler with closure
                alert.addAction(UIAlertAction(title: "نعم", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
                    self.userLogout()
                UserDefaults.standard.removeObject(forKey:"isLogin")
                    self.dismiss(animated: true, completion: nil)
                }));
                alert.view.tintColor = UIColor.red
                present(alert, animated: true, completion: nil)
                
                
            }else{
            
            let alert = UIAlertController(title: "Alert", message: "Are you sure want to logout?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil));
            //event handler with closure
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
                self.userLogout()
            UserDefaults.standard.removeObject(forKey:"isLogin")
                self.dismiss(animated: true, completion: nil)
            }));
            alert.view.tintColor = UIColor.red
            present(alert, animated: true, completion: nil)
            
           }
        }
        
    }
    private func userLogout() {
        self.appDel.apiManager.logout(onComplete:{
            (details, error) in
            if details != nil {
                let orderMenuDict = details as! NSDictionary
                let status = orderMenuDict.value(forKey: "status") as! String
                if status == "success"
                {
                  print("Logout")
                }
            }else{
                print("Server Not Responding")
                
            }
        })
    }

    
}
