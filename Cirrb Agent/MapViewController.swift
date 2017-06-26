//
//  MapViewController.swift
//  Cirrb Agent
//
//  Created by Yuvasoft on 6/19/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import GoogleMaps


class MapViewController: UIViewController,GMSMapViewDelegate {

    @IBOutlet weak var gmapView: GMSMapView!
    
    @IBOutlet weak var lblPickUpANdDrop: UILabel!

    
    var marker = GMSMarker()
    let locationManager = CLLocationManager()
    
    var appDel: AppDelegate! = (UIApplication.shared.delegate as! AppDelegate)

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
             
        self.locationManager.delegate = self
        self.locationManager.distanceFilter  = kCLDistanceFilterNone
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        
        self.gmapView.isMyLocationEnabled = true
        self.gmapView.settings.compassButton = true
        self.gmapView.settings.myLocationButton = false
        self.locationManager.startUpdatingLocation()
        
        let decoded  = UserDefaults.standard.object(forKey: "orderDetails") as! Data
        let decodedData = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! NSDictionary
        print("decodedTeams >>>",decodedData)
        
        let Branch_latitude = (((decodedData.value(forKey: "details") as AnyObject).value(forKey: "order") as AnyObject).value(forKey: "branch_lat") as AnyObject) as! Float
        print("latitude is> ",Branch_latitude)
        
        let Branch_longitude = (((decodedData.value(forKey: "details") as AnyObject).value(forKey: "order") as AnyObject).value(forKey: "branch_long") as AnyObject) as! Float
        print("longitude is> ",Branch_longitude)
        
        let Branch_marker = GMSMarker()
        Branch_marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(Branch_latitude) , longitude: CLLocationDegrees(Branch_longitude))
        
        Branch_marker.icon = GMSMarker.markerImage(with: .yellow)
        
        Branch_marker.title = "Restaurant Name: " + ((((decodedData.value(forKey: "details") as AnyObject).value(forKey: "order") as AnyObject).value(forKey: "restaurant_name") as AnyObject) as! String)
        
        let Branch_Phone = "Phone: " + String((((decodedData.value(forKey: "details") as AnyObject).value(forKey: "order") as AnyObject).value(forKey: "restaurant_phone") as AnyObject) as! Int)
        
        Branch_marker.snippet = Branch_Phone
        Branch_marker.map = self.gmapView
        
        let User_latitude = ((((decodedData.value(forKey: "details") as AnyObject).value(forKey: "order") as AnyObject).value(forKey: "user") as AnyObject).value(forKey: "lat") as AnyObject) as! Float
        print("User latitude is> ",User_latitude)
        
        let User_longitude = ((((decodedData.value(forKey: "details") as AnyObject).value(forKey: "order") as AnyObject).value(forKey: "user") as AnyObject).value(forKey: "long") as AnyObject) as! Float
        print("User longitude is> ",User_longitude)
        
        
        let User_marker = GMSMarker()
        User_marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(User_latitude) , longitude: CLLocationDegrees(User_longitude))
        
        User_marker.icon = GMSMarker.markerImage(with: .orange)
        
        let userDict:String? = (((((decodedData.value(forKey: "details") as AnyObject).value(forKey: "order") as AnyObject).value(forKey: "user") as AnyObject).value(forKey: "name") as AnyObject) as! String) + " " + (((((decodedData.value(forKey: "details") as AnyObject).value(forKey: "order") as AnyObject).value(forKey: "user") as AnyObject).value(forKey: "last_name") as AnyObject) as! String)
        
        if userDict != nil{
            
            User_marker.title = "Customer Name: " + userDict!
        }
        
        let User_Phone: String? = "Phone: " + String(describing: ((((decodedData.value(forKey: "details") as AnyObject).value(forKey: "order") as AnyObject).value(forKey: "user") as AnyObject).value(forKey: "phone") as AnyObject) as! Int)
        
        let phoneNo = (((((decodedData.value(forKey: "details") as AnyObject).value(forKey: "order") as AnyObject).value(forKey: "user") as AnyObject).value(forKey: "phone") as AnyObject) as! Int)
        
        if phoneNo == 0 {
            User_marker.snippet = "Phone: " + "Not Available"
        }else{
            User_marker.snippet = "Phone: " + String(phoneNo)
        }

        
       // User_marker.snippet = User_Phone
        User_marker.map = self.gmapView
        
        let s_latitude = UserDefaults.standard.object(forKey: Constant.User.CURRENT_LATITUDE) as! String
        
        let s_longitude = UserDefaults.standard.object(forKey: Constant.User.CURRENT_LONGITUDE) as! String
        
        print("s_latitude: ",s_latitude)
        print("s_longitude: ",s_longitude)
        
        
        let source: String! = "\(s_latitude),\(s_longitude)"
        let destination: String! = "\(Branch_latitude),\(Branch_longitude)"
        self.directionApi(source: source, destination: destination)


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
            
            lblPickUpANdDrop.text = bundal.localizedString(forKey: "PICKUP AND DROP OFF", value: nil, table: nil)
            
            
        }else{
            
            let path = Bundle.main.path(forResource: "en", ofType: "lproj")
            
            let bundal = Bundle.init(path: path!)! as Bundle
            
            lblPickUpANdDrop.text = bundal.localizedString(forKey: "PICKUP AND DROP OFF", value: nil, table: nil)
            
           }
    }
}
extension MapViewController: CLLocationManagerDelegate {
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

