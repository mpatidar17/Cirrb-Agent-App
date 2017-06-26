//
//  CongratulationViewController.swift
//  Cirrb Agent
//
//  Created by mac on 19/05/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import Alamofire

class CongratulationViewController: UIViewController {
    
    
    @IBOutlet weak var lblGreatWork: UILabel!
    
    @IBOutlet weak var lblWhatWouldYouLike: UILabel!
    
    @IBOutlet weak var lblkeepthemComing: UILabel!
    
    @IBOutlet weak var lblThankYou: UILabel!
    
    
    //@IBOutlet weak var keepthemComingButton: UIButton!
    
   // @IBOutlet weak var thankYouButton: UIButton!

    
     var appDel: AppDelegate! = (UIApplication.shared.delegate as! AppDelegate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
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
            
            lblkeepthemComing.text = bundal.localizedString(forKey: "Keep them coming!", value: nil, table: nil)
            
            lblThankYou.text = bundal.localizedString(forKey: "Thank you!  I'm done for today", value: nil, table: nil)
            
            lblGreatWork.text = bundal.localizedString(forKey: "GREAT WORK!", value: nil, table: nil)
            
            lblWhatWouldYouLike.text = bundal.localizedString(forKey: "What would you like to do now?", value: nil, table: nil)
            
        }else{
            
            let path = Bundle.main.path(forResource: "en", ofType: "lproj")
            
            let bundal = Bundle.init(path: path!)! as Bundle
            
            lblGreatWork.text = bundal.localizedString(forKey: "GREAT WORK!", value: nil, table: nil)
            
            lblWhatWouldYouLike.text = bundal.localizedString(forKey: "What would you like to do now?", value: nil, table: nil)
            
            lblkeepthemComing.text = bundal.localizedString(forKey: "Keep them coming!", value: nil, table: nil)
            
            lblThankYou.text = bundal.localizedString(forKey: "Thank you!  I'm done for today", value: nil, table: nil)
        }

    }
    
    @IBAction func clickKeepThemComing(_ sender: Any) {
        
        self.performSegue(withIdentifier: "Congratulation_SearchOrder", sender: self)
        statusUpdateFree()
    }
    
    @IBAction func clickDoneForToday(_ sender: Any) {
        
         self.performSegue(withIdentifier: "Congratulation_Dashboard", sender: self)
        statusUpdate()
    }
    func statusUpdate() {
        
        let urlSignIn: String = "http://api.cirrb.com/api/updatePartnerStatus"
        
        let userId = UserDefaults.standard.object(forKey: Constant.User.USER_ID) as! String
        
        let userObject = ["partner_id": userId , "partner_status": "busy" ];
        
         print("userObject",userObject)
        
        let auth_token = UserDefaults.standard.object(forKey: Constant.User.AUTH_TOKEN) as? String
        print("auth_token",auth_token!)
        
        let Auth_header : HTTPHeaders = [ "Authorization" : auth_token! ]
        
        //        Alamofire.request(urlSignIn, method: .post, parameters: userObject, encoding: JSONEncoding.default)
        //            .responseJSON { response in
        
        Alamofire.request(urlSignIn, method: .post, parameters: userObject, encoding: JSONEncoding.default, headers: Auth_header).responseJSON { response in
                
                // print("response is: ",response)
                
                if response.result.isSuccess  && response.response?.statusCode == 200{
                    
                      print("Status Updated")
                }
                else{
                      print("Status is not Updated")
                }}
        
    }
    
    func statusUpdateFree() {
        
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
            
                // print("response is: ",response)
                
                if response.result.isSuccess  && response.response?.statusCode == 200{
                    
                     print("Status Updated")
                }
                else{
                    print("Status is not Updated")
                }}
        
    }


}
