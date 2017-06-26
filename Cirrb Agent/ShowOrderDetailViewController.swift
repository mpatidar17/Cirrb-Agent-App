//
//  ShowOrderDetailViewController.swift
//  Cirrb Agent
//
//  Created by mac on 19/05/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import GoogleMaps

class ShowOrderDetailViewController: UIViewController, GMSMapViewDelegate,UITableViewDelegate,UITableViewDataSource {


    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var gmapView: GMSMapView!
    
    @IBOutlet weak var orderDetailsTableView: UITableView!
    
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var deliveryChargesLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    
    @IBOutlet weak var lblPickUpANdDrop: UILabel!
    
    @IBOutlet weak var lblOrderdetails: UILabel!
    
    
    @IBOutlet weak var lblSubTotal: UILabel!
    
    @IBOutlet weak var lblDeliveryCharges: UILabel!
    
    @IBOutlet weak var lblReceivableCharges: UILabel!
    
    @IBOutlet weak var completeDeliveryButton: defaultButton!
    
    
    var marker = GMSMarker()
    let locationManager = CLLocationManager()
    
    
    var orderInfoDict = NSDictionary()
    var Order = NSArray()
    
    var appDel: AppDelegate! = (UIApplication.shared.delegate as! AppDelegate)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        
        UINavigationBar.appearance().tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = UIColor(red:0.75, green:0.34, blue:0.25, alpha:1.0)
        //UIApplication.shared.statusBarStyle = .lightContent
        self.navigationItem.hidesBackButton = true;
        
        //self.baseView.layer.borderColor = UIColor.black.cgColor
        //self.baseView.layer.borderWidth = 2
        
        self.locationManager.delegate = self
        self.locationManager.distanceFilter  = kCLDistanceFilterNone
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        
        self.gmapView.isMyLocationEnabled = true
        self.gmapView.settings.compassButton = true
        self.gmapView.settings.myLocationButton = false
        self.locationManager.startUpdatingLocation()
        
        
        let subTotalAmt = UserDefaults.standard.object(forKey: "subTotalAmt") as! Float
        subTotalLabel.text = "SR" + String(subTotalAmt)
        
        let deliveryCharges = UserDefaults.standard.object(forKey: "deliveryFees") as! Float
        deliveryChargesLabel.text = "SR" + String(deliveryCharges)
        
        let totalAmt = UserDefaults.standard.object(forKey: "totalAmt") as! Float
        totalLabel.text = "SR" + String(totalAmt)
        
        print("orderInfoDict is>>>>",orderInfoDict)
        
        Order = (((orderInfoDict.value(forKey: "details")as AnyObject).value(forKey: "order")as AnyObject).value(forKey: "order_list") as AnyObject) as! NSArray
        print("Order>>>>",Order)
              
        let Branch_latitude = (((orderInfoDict.value(forKey: "details") as AnyObject).value(forKey: "order") as AnyObject).value(forKey: "branch_lat") as AnyObject) as! Float
        print("latitude is> ",Branch_latitude)
        
        let Branch_longitude = (((orderInfoDict.value(forKey: "details") as AnyObject).value(forKey: "order") as AnyObject).value(forKey: "branch_long") as AnyObject) as! Float
        print("longitude is> ",Branch_longitude)
        
        let Branch_marker = GMSMarker()
        Branch_marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(Branch_latitude) , longitude: CLLocationDegrees(Branch_longitude))
        
        Branch_marker.icon = GMSMarker.markerImage(with: .yellow)
        
        Branch_marker.title = "Restaurant Name: " + ((((orderInfoDict.value(forKey: "details") as AnyObject).value(forKey: "order") as AnyObject).value(forKey: "restaurant_name") as AnyObject) as! String)
        
        let Branch_Phone = "Phone: " + String((((orderInfoDict.value(forKey: "details") as AnyObject).value(forKey: "order") as AnyObject).value(forKey: "restaurant_phone") as AnyObject) as! Int)
        
        Branch_marker.snippet = Branch_Phone
        Branch_marker.map = self.gmapView
        
        let User_latitude = ((((orderInfoDict.value(forKey: "details") as AnyObject).value(forKey: "order") as AnyObject).value(forKey: "user") as AnyObject).value(forKey: "lat") as AnyObject) as! Float
        print("User latitude is> ",User_latitude)

        let User_longitude = ((((orderInfoDict.value(forKey: "details") as AnyObject).value(forKey: "order") as AnyObject).value(forKey: "user") as AnyObject).value(forKey: "long") as AnyObject) as! Float
        print("User longitude is> ",User_longitude)
        
        
        let User_marker = GMSMarker()
        User_marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(User_latitude) , longitude: CLLocationDegrees(User_longitude))
        
        User_marker.icon = GMSMarker.markerImage(with: .orange)
        
        let userDict:String? = (((((orderInfoDict.value(forKey: "details") as AnyObject).value(forKey: "order") as AnyObject).value(forKey: "user") as AnyObject).value(forKey: "name") as AnyObject) as! String) + " " + (((((orderInfoDict.value(forKey: "details") as AnyObject).value(forKey: "order") as AnyObject).value(forKey: "user") as AnyObject).value(forKey: "last_name") as AnyObject) as! String)
        
        if userDict != nil{
            
            User_marker.title = "Customer Name: " + userDict!
        }
        
        let User_Phone = "Phone: " + String(describing: ((((orderInfoDict.value(forKey: "details") as AnyObject).value(forKey: "order") as AnyObject).value(forKey: "user") as AnyObject).value(forKey: "phone") as AnyObject) as? Int)
        
        User_marker.snippet = User_Phone
        User_marker.map = self.gmapView
        
        let s_latitude = UserDefaults.standard.object(forKey: Constant.User.CURRENT_LATITUDE) as! String
        
        let s_longitude = UserDefaults.standard.object(forKey: Constant.User.CURRENT_LONGITUDE) as! String
        
        print("s_latitude: ",s_latitude)
        print("s_longitude: ",s_longitude)
        
        
        let source: String! = "\(s_latitude),\(s_longitude)"
        let destination: String! = "\(Branch_latitude),\(Branch_longitude)"
        self.directionApi(source: source, destination: destination)
    }

    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        
        if appDel.flagLanguage == 1{
            
            let path = Bundle.main.path(forResource: "ar-SA", ofType: "lproj")
            
            let bundal = Bundle.init(path: path!)! as Bundle
            
            let btn = bundal.localizedString(forKey: "COMPLETE DELIVERY", value: nil, table: nil)
          
            lblPickUpANdDrop.text = bundal.localizedString(forKey: "PICKUP AND DROP OFF", value: nil, table: nil)
            
            lblOrderdetails.text = bundal.localizedString(forKey: "ORDER DETAILS", value: nil, table: nil)
            
            lblSubTotal.text = bundal.localizedString(forKey: "Sub Total", value: nil, table: nil)
            
            lblDeliveryCharges.text = bundal.localizedString(forKey: "Delivery charges", value: nil, table: nil)
            
            lblReceivableCharges.text = bundal.localizedString(forKey: "Receivable Charges", value: nil, table: nil)
            
            completeDeliveryButton.setTitle(btn, for: .normal)
            
        }else{
            
            let path = Bundle.main.path(forResource: "en", ofType: "lproj")
            
            let bundal = Bundle.init(path: path!)! as Bundle
            
            let btn = bundal.localizedString(forKey: "COMPLETE DELIVERY", value: nil, table: nil)
            
            lblPickUpANdDrop.text = bundal.localizedString(forKey: "PICKUP AND DROP OFF", value: nil, table: nil)
            
            lblOrderdetails.text = bundal.localizedString(forKey: "ORDER DETAILS", value: nil, table: nil)
            
            lblSubTotal.text = bundal.localizedString(forKey: "Sub Total", value: nil, table: nil)
            
            lblDeliveryCharges.text = bundal.localizedString(forKey: "Delivery charges", value: nil, table: nil)
            
            lblReceivableCharges.text = bundal.localizedString(forKey: "Receivable Charges", value: nil, table: nil)
            
            completeDeliveryButton.setTitle(btn, for: .normal)
            
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickCompleteDelivery(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowDetail_Payment", sender: self)
    }
 }
    extension ShowOrderDetailViewController: CLLocationManagerDelegate {
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse {
                locationManager.startUpdatingLocation()
                gmapView.isMyLocationEnabled = true
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.first {
                gmapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
                locationManager.stopUpdatingLocation()
            }
            
        }
        func creatMarker(_ coordinates: CLLocationCoordinate2D){
            
            marker.position = CLLocationCoordinate2DMake(coordinates.latitude, coordinates.longitude)
            marker.appearAnimation = .pop
            marker.map = gmapView
        }
        //MARK: Order details TableView:
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return Order.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = orderDetailsTableView.dequeueReusableCell(withIdentifier: "orderDetailsCell", for: indexPath) as! orderDetailsCell
            
            cell.itemNameLabel.text = (((Order.object(at: 0) as AnyObject).value(forKey: "name") as AnyObject) as! String)
            
            let cost = String(((Order.object(at: 0) as AnyObject).value(forKey: "per_menu_cost") as AnyObject) as! Float)
            
            cell.itemPriceLabel.text = "SR " + cost
            

            let quantity = String(((Order.object(at: 0) as AnyObject).value(forKey: "quantity") as AnyObject) as! Int)
            
            cell.itemQuantityLabel.text = quantity
            
            return cell
        }
        
        //MARK: Show the Path on Map:
        
        func directionApi(source:String, destination:String) {
            
            let directionsUrlString: String = "https://maps.googleapis.com/maps/api/directions/json?&origin=\(source)&destination=\(destination)&mode=driving"
            
            let url = URL(string: directionsUrlString)
            
            let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                DispatchQueue.main.async(execute: {
                    self.extractData(data!)
                })
            })
            task.resume()
        }
        
        func extractData(_ directionData: Data) {
            
            let json = try? JSONSerialization.jsonObject(with: directionData, options: []) as! NSDictionary
            
            let routesArray: [AnyObject] = (json!["routes"] as! [AnyObject])
            var polyline: GMSPolyline? = nil
            if routesArray.count > 0 {
                let routeDict: [AnyHashable: Any] = routesArray[0] as! [AnyHashable: Any]
                var routeOverviewPolyline: [AnyHashable: Any] = (routeDict["overview_polyline"] as! [AnyHashable: Any])
                let points: String = (routeOverviewPolyline["points"] as! String)
                let path: GMSPath = GMSPath(fromEncodedPath: points)!
                polyline = GMSPolyline(path: path)
                polyline!.strokeWidth = 4.0
                polyline?.strokeColor = UIColor.orange
                polyline!.map = gmapView
            }
        }
        
}
