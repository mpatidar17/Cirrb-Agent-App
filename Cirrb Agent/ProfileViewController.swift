//
//  ProfileViewController.swift
//  cirrb app
//
//  Created by mac on 10/05/17.
//  Copyright © 2017 3WebBox, Inc. All rights reserved.
//

import UIKit
import Kingfisher
import MBProgressHUD

class ProfileViewController: BaseViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate,UITextFieldDelegate {
    var appDel: AppDelegate! = (UIApplication.shared.delegate as! AppDelegate)
    @IBOutlet weak var lblProfile: UILabel!

    @IBOutlet weak var txtFieldPhone: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldLName: UITextField!
    
    @IBOutlet weak var lblUName: UILabel!
    
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var lblLastOrderBalance: UILabel!
    @IBOutlet weak var lblOrderCount: UILabel!
    @IBOutlet weak var lblOrderLimit: UILabel!
    
    @IBOutlet weak var txtFieldFName: UITextField!
    @IBOutlet weak var imgvwProfilePic: UIImageView!
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    
    @IBOutlet weak var vwInfoAmt: UIView!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var languageView: UIView!
    
    @IBOutlet weak var languageViewHight: NSLayoutConstraint!
    
    @IBOutlet weak var topImageView: UIImageView!
    
    @IBOutlet weak var englishButton: UIButton!
    
    @IBOutlet weak var arabicButton: UIButton!
    
    @IBOutlet weak var lblInHand: UILabel!
    
    @IBOutlet weak var lblLastReceived: UILabel!
    
    @IBOutlet weak var lblTotalOrder: UILabel!
    
    @IBOutlet weak var lblLimit: UILabel!
    
   // @IBOutlet weak var saveButton: UIBarButtonItem!

    var picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDel.apiManager.setCurrentViewController(vc: self)
        
        englishButton.backgroundColor = UIColor(red:0.90, green:0.47, blue:0.36, alpha:1.0)
        englishButton.setTitleColor(UIColor.white, for: .normal)
        
        languageView.isHidden = true
        topImageView.isHidden = true
        
        // txtNameHight.constant = 50
        
        // languageView.layer.borderColor = UIColor(red:0.90, green:0.47, blue:0.36, alpha:1.0).cgColor
        // languageView.layer.borderWidth = 2
        languageView.layer.shadowRadius = 5
        //  languageViewHight.constant = 0
        languageView.layer.cornerRadius = 10
        languageView.layer.masksToBounds = true
        
        self.automaticallyAdjustsScrollViewInsets = false
        UINavigationBar.appearance().tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = UIColor(red:0.90, green:0.47, blue:0.36, alpha:1.0)
        
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage())
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //UIColor(red:0.00, green:1.00, blue:0.00, alpha:1.0)
        btnMenu.target = self.revealViewController()
        btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        vwInfoAmt.layer.shadowColor = UIColor(red:0.90, green:0.47, blue:0.36, alpha:1.0).cgColor
        vwInfoAmt.layer.shadowOpacity = 1
        vwInfoAmt.layer.shadowOffset = CGSize.zero
        vwInfoAmt.layer.shadowRadius = 2
        
        imgvwProfilePic.layer.cornerRadius = 65
        imgvwProfilePic.layer.masksToBounds = true
        self.imgvwProfilePic.layer.borderWidth = 3
        self.imgvwProfilePic.layer.borderColor = UIColor(red:0.90, green:0.47, blue:0.36, alpha:1.0).cgColor
        
        let paddingView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 15, height: self.txtFieldFName.frame.height))
        txtFieldFName.leftView = paddingView
        txtFieldFName.leftViewMode = UITextFieldViewMode.always
       
        let paddingView1 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 15, height: self.txtFieldLName.frame.height))
        txtFieldLName.leftView = paddingView1
        txtFieldLName.leftViewMode = UITextFieldViewMode.always
       
        
        let paddingView2 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 15, height: self.txtFieldEmail.frame.height))
        txtFieldEmail.leftView = paddingView2
        txtFieldEmail.leftViewMode = UITextFieldViewMode.always
       
        
        let paddingView3 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 15, height: self.txtFieldPhone.frame.height))
        txtFieldPhone.leftView = paddingView3
        txtFieldPhone.leftViewMode = UITextFieldViewMode.always
       
        let fnameValue = UserDefaults.standard.object(forKey: Constant.User.FIRST_NAME)
        let lnameValue = UserDefaults.standard.object(forKey: Constant.User.LAST_NAME)
        
        if fnameValue != nil {
            let fname: String = UserDefaults.standard.object(forKey: Constant.User.FIRST_NAME) as! String
            self.lblUName.text = fname
        }
        
        if lnameValue != nil {
            let lname: String = UserDefaults.standard.object(forKey: Constant.User.LAST_NAME) as! String
            self.lblUName.text = String(describing: self.lblUName.text!) + " " + lname
        }
        
        
        self.txtFieldEmail.isUserInteractionEnabled = false

        let firstName = UserDefaults.standard.object(forKey: Constant.User.FIRST_NAME) as? String
        
        if firstName != " "{
            self.txtFieldFName.text = UserDefaults.standard.object(forKey: Constant.User.FIRST_NAME) as? String
        }
        
        let lastName = UserDefaults.standard.object(forKey: Constant.User.LAST_NAME) as? String
        
        if lastName != " "{
            self.txtFieldLName.text = UserDefaults.standard.object(forKey: Constant.User.LAST_NAME) as? String
        }
        
        self.txtFieldEmail.text = UserDefaults.standard.object(forKey: Constant.User.EMAIL_USER) as? String
        
        self.txtFieldPhone.text = UserDefaults.standard.object(forKey: Constant.User.PHONE) as? String
        
        let phoneNo = UserDefaults.standard.object(forKey: Constant.User.PHONE) as? String

        if phoneNo != " "{
            
        self.txtFieldPhone.text = UserDefaults.standard.object(forKey: Constant.User.PHONE) as? String
        }
        
        let newImagePath = (UserDefaults.standard.object(forKey: Constant.User.IMAGE_PATH) as! String).replacingOccurrences(of: " ", with: "%20")
        print("newImagePath in profile is: ",newImagePath)
        let url = URL(string: newImagePath)
        imgvwProfilePic.kf.setImage(with: url)
        
        getUserInfo()
    }
    override func viewWillAppear(_ animated: Bool) {
        if appDel.flagLanguage == 1{
          
            clickArabicButton(self)
          }else{
            clickEnglishButton(self)
        }

    }

    @IBAction func clickSave(_ sender: Any) {
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        if appDel.flagLanguage == 1{
            loadingNotification.label.text = "أرجو الإنتظار..."
        }else{
            loadingNotification.label.text = "Please wait..."
        }
        let strFName = (txtFieldFName.text!.trimmingCharacters(in: .whitespaces))
        let strLName = (txtFieldLName.text!.trimmingCharacters(in: .whitespaces))
        let strEmailUser = (txtFieldEmail.text!.trimmingCharacters(in: .whitespaces))
        let strPhone = (txtFieldPhone.text!.trimmingCharacters(in: .whitespaces))
        
        UserDefaults.standard.setValue(strFName, forKey: Constant.User.FIRST_NAME)
        UserDefaults.standard.setValue(strLName, forKey: Constant.User.LAST_NAME)
        UserDefaults.standard.setValue(strPhone, forKey: Constant.User.PHONE)
        UserDefaults.standard.setValue(strEmailUser, forKey: Constant.User.EMAIL_USER)
        
        
        updateProfile()
    }
    
    private func updateProfile() {
        self.appDel.apiManager.updateProfile(onComplete: {
            (details, error) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if details != nil {
                let ProfileDict = details as! NSDictionary
                let status = ProfileDict.value(forKey: "status") as! String
                
                if status == "success"
                {

            if self.appDel.flagLanguage == 1{
                
                let alert = UIAlertController(title: "محزر", message: "لقد نجحت في تحديث ملفك الشخصي", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "حسنا", style: UIAlertActionStyle.default, handler: nil));
                
                alert.view.tintColor = UIColor.red
                self.present(alert, animated: true, completion: nil)
            }else{
            let alert = UIAlertController(title: "Alert", message: "You have successfully update your profile", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil));

            alert.view.tintColor = UIColor.red
            self.present(alert, animated: true, completion: nil)
            }
            
            print("Profile Updated Details: ",details!)
            let fname: String = UserDefaults.standard.object(forKey: Constant.User.FIRST_NAME) as! String
            let lname: String = UserDefaults.standard.object(forKey: Constant.User.LAST_NAME) as! String
            
            self.lblUName.text = fname + "  " + lname
                
                }
                else{
                    let message = ProfileDict.value(forKey: "message") as! String
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
    
    private func getUserInfo() {
        self.appDel.apiManager.getUserBalanceDetails(onComplete: {
            (details, error) in
            if details != nil {
                print("Balance Details: ",details!)
                let detailDict = details as! NSDictionary
                let status = detailDict.value(forKey: "status") as! String
                
                if status == "success"{

                let balanceDict = detailDict.value(forKey: "details") as AnyObject
                let balance = balanceDict.value(forKey: "cash_in_hand") as! Float
                let last_order = balanceDict.value(forKey: "last_order") as! Float
                let order_count = balanceDict.value(forKey: "order_count") as! Int
                let order_limit = balanceDict.value(forKey: "order_limit") as! Float
                
                self.lblBalance.text = "SR " + String(describing: balance)
                
                //if last_order != ""{
                
                    self.lblLastOrderBalance.text = "SR " + String(last_order)
             //   }
                self.lblOrderCount.text =  String(order_count)
                    self.lblOrderLimit.text =  "SR " + String(order_limit)
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
    
    @IBAction func clickPickImage(_ sender: Any) {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        
        picker.delegate = self
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker.sourceType = UIImagePickerControllerSourceType.camera
            self .present(picker, animated: true, completion: nil)
        }else{
            self.ShowAlert()
        }
    }
    
    func openGallary(){
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
   }
    
    
    private func uploadProfilePic(image: UIImage){
        self.appDel.apiManager.uploadImageAndData(data: image, onComplete: {
            (details, error) in
            print("details for profile pic; ",details!)
            
            let infoDict = details! as! NSDictionary
            let imagePath = (infoDict.value(forKey: "details")as AnyObject).value(forKey: "image")as! String
            
            print("imagePath = ",imagePath)
            
            UserDefaults.standard.setValue(imagePath, forKey: Constant.User.IMAGE_PATH)
            
        })
    }
    
    //MARK:UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imgvwProfilePic.image = pickedImage

  //        }
  //        else if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imgvwProfilePic.contentMode = .scaleAspectFill
            let newImage = resizeImage(image: pickedImage, newWidth: 500)
            
            imgvwProfilePic.image = newImage
            uploadProfilePic(image: newImage)
        }else{
            imgvwProfilePic.image = nil
        }
            self.dismiss(animated: true, completion: nil)
    }
    
    func ShowAlert() {
        let alert = UIAlertController(title: "Error", message: "Camera is not available in your device.", preferredStyle: UIAlertControllerStyle.alert)
        let cameraAction1 = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
        alert .addAction(cameraAction1)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func clickDropButton(_ sender: Any) {
        
        languageView.isHidden = false
        topImageView.isHidden = false
        
        //    languageViewHight.constant = 107
    }
    @IBAction func clickEnglishButton(_ sender: Any) {
        
        appDel.flagLanguage = 0
        
        if appDel.flagLanguage == 0 {
        
            UserDefaults.standard.set("false", forKey: "Language")
            
        languageLabel.text = "   English"
        languageView.isHidden = true
        topImageView.isHidden = true
        englishButton.backgroundColor = UIColor(red:0.90, green:0.47, blue:0.36, alpha:1.0)
        englishButton.setTitleColor(UIColor.white, for: .normal)
        arabicButton.backgroundColor = UIColor.white
        arabicButton.setTitleColor(UIColor.lightGray, for: .normal)
                
        let path = Bundle.main.path(forResource: "en", ofType: "lproj")
        
        let bundal = Bundle.init(path: path!)! as Bundle
        
        lblProfile.text = bundal.localizedString(forKey: "PROFILE", value: nil, table: nil)
        
        lblInHand.text = bundal.localizedString(forKey: "In Hand", value: nil, table: nil)
        
        lblLastReceived.text = bundal.localizedString(forKey: "Last Received", value: nil, table: nil)
        
        lblTotalOrder.text = bundal.localizedString(forKey: "Total Order", value: nil, table: nil)
        
        lblLimit.text = bundal.localizedString(forKey: "Limit", value: nil, table: nil)
        
       // saveButton.title = bundal.localizedString(forKey: "Save", value: nil, table: nil)
            
        let title = bundal.localizedString(forKey: "PROFILE", value: nil, table: nil)
            
        navigationItem.title = title
            
        txtFieldFName.placeholder = bundal.localizedString(forKey: "First Name", value: nil, table: nil)
            
        txtFieldLName.placeholder = bundal.localizedString(forKey: "Last Name", value: nil, table: nil)
            
        txtFieldPhone.placeholder = bundal.localizedString(forKey: "Mobile Number", value: nil, table: nil)
            
        txtFieldEmail.placeholder = bundal.localizedString(forKey: "Email", value: nil, table: nil)
        }
    }
    @IBAction func clickArabicButton(_ sender: Any) {
        
        appDel.flagLanguage = 1
        
        
        
        if appDel.flagLanguage == 1 {
            
            UserDefaults.standard.set("true", forKey: "Language")
            
            print(UserDefaults.standard.set("true", forKey: "Language"))
        
        languageLabel.text = "   Arabic"
        languageView.isHidden = true
        topImageView.isHidden = true
        arabicButton.backgroundColor = UIColor(red:0.90, green:0.47, blue:0.36, alpha:1.0)
        arabicButton.setTitleColor(UIColor.white, for: .normal)
        englishButton.backgroundColor = UIColor.white
        englishButton.setTitleColor(UIColor.lightGray, for: .normal)
        
        let path = Bundle.main.path(forResource: "ar-SA", ofType: "lproj")
        
        let bundal = Bundle.init(path: path!)! as Bundle
        
        lblProfile.text = bundal.localizedString(forKey: "PROFILE", value: nil, table: nil)
        
        lblInHand.text = bundal.localizedString(forKey: "In Hand", value: nil, table: nil)
        
        lblLastReceived.text = bundal.localizedString(forKey: "Last Received", value: nil, table: nil)
        
        lblTotalOrder.text = bundal.localizedString(forKey: "Total Order", value: nil, table: nil)
        
        lblLimit.text = bundal.localizedString(forKey: "Limit", value: nil, table: nil)
        
        //saveButton.title = bundal.localizedString(forKey: "Save", value: nil, table: nil)
            
        let title = bundal.localizedString(forKey: "PROFILE", value: nil, table: nil)
            
        navigationItem.title = title
            
        txtFieldFName.placeholder = bundal.localizedString(forKey: "First Name", value: nil, table: nil)
            
        txtFieldLName.placeholder = bundal.localizedString(forKey: "Last Name", value: nil, table: nil)
            
        txtFieldPhone.placeholder = bundal.localizedString(forKey: "Mobile Number", value: nil, table: nil)
            
        txtFieldEmail.placeholder = bundal.localizedString(forKey: "Email", value: nil, table: nil)
        }
    }
    
}
