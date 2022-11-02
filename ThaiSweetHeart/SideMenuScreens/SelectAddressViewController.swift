//
//  SelectAddressViewController.swift
//  ThaiSweetHeart
//
//  Created by MAC-27 on 13/07/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import CoreLocation
import GooglePlaces
//import SwiftToast


class SelectAddressViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var mapview: GMSMapView!
    private let locationManager = CLLocationManager()
    
    var loc : CLLocationCoordinate2D?
     var driverMarker: GMSMarker?
    var str_lat:String!
    var str_long:String!
    var lat = Double()
    var long = Double()
    var centerMapCoordinate:CLLocationCoordinate2D!
    var city:String!
    var state:String!
    var country:String!
    var zipcode:String!
    
    var myMarker : GMSMarker?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bar_title  = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        bar_title.textColor = UIColor.white
        bar_title.numberOfLines = 0
        bar_title.center = CGPoint(x: 0, y: 0)
        bar_title.textAlignment = .left
        bar_title.font = UIFont.boldSystemFont(ofSize: bar_title.font.pointSize)
        bar_title.text = "Search Your Location"
        self.navigationItem.titleView = bar_title
        
        //Your map initiation code
        view.endEditing(true)
        
       
//        mapview.delegate = self
//        mapview?.isMyLocationEnabled = true
//        mapview.settings.myLocationButton = true
//        mapview.padding = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 50)
        
        
//        determineMyCurrentLocation()
        //Location Manager code to fetch current location
       

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.startUpdatingLocation()
            mapview.delegate = self
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        loc = locValue
            
    //        let camera = GMSCameraPosition.camera(withLatitude: (locValue.latitude), longitude: (locValue.longitude), zoom: 14.0)
    //        self.mapview?.animate(to: camera)
    //
//        mapview.camera = GMSCameraPosition(target: locValue, zoom: 15)
//        myMarker = GMSMarker(position: locValue)
//        myMarker?.map = mapview
        
        self.myMarker = GMSMarker()
        self.myMarker?.position = CLLocationCoordinate2DMake(locValue.latitude, locValue.longitude)
        
        self.myMarker?.icon = UIImage(named: "test2")
        self.myMarker?.map = self.mapview
        self.myMarker?.title = "Tutor"
        self.myMarker?.snippet = "Location"
        self.myMarker?.isDraggable = true
        self.mapview.settings.consumesGesturesInView = false
        let BigMapupdatedCamera = GMSCameraUpdate.setTarget((self.myMarker?.position)!, zoom: 14.0)
        self.mapview.animate(with: BigMapupdatedCamera)
        
//        convertLatLongToAddress(latitude: locValue.latitude, longitude: locValue.longitude)
//        self.getAddressFromLatLon(pdblLatitude: "\(locValue.latitude)", withLongitude: "\(locValue.longitude)")
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
        
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String){
        
        self.addressLbl.text = ""
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon

        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)

        ceo.reverseGeocodeLocation(loc, completionHandler: {(placemarks, error) in
        if (error != nil){
        print("reverse geodcode fail: \(error!.localizedDescription)")
        }
         if placemarks != nil{
        let pm = placemarks! as [CLPlacemark]

        if pm.count > 0 {
        let pm = placemarks![0]
        var addressString : String = ""
        if pm.subLocality != nil {
        addressString = addressString + pm.subLocality! + ", "
        }
        if pm.thoroughfare != nil {
        addressString = addressString + pm.thoroughfare! + ", "
        }
        if pm.locality != nil {
        addressString = addressString + pm.locality! + ", "
        }
        if pm.country != nil {
        addressString = addressString + pm.country! + ", "
        }
        if pm.postalCode != nil {
        addressString = addressString + pm.postalCode! + " "
        }
        print(addressString)
            self.addressLbl.text = addressString
        }
        }
        else{
        print("Error is obtaining your location. Please try again later!!")
        }
        })
    }
        
    func convertLatLongToAddress(latitude:Double,longitude:Double){
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
       
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            if placemarks == nil{
                print("No Location Available")
                print(location)
            }else {
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                var addressString : String = ""
                // Location name
                if let locationName = placeMark.location {
                    print(locationName)
                }
                //
                if let sublocal = placeMark.subLocality {
                    addressString = addressString + sublocal + ", "
                    print(sublocal)
                    
                }
                // Street address
                if let street = placeMark.thoroughfare {
                    addressString = addressString + street + ", "
                    print(street)
                    
                }
                // City
                if let city = placeMark.subAdministrativeArea {
                    addressString = addressString + city + ", "
                    self.city = city
                    print(city)
                }
                // State
                if let state = placeMark.administrativeArea {
                    addressString = addressString + state + ", "
                    print(state)
                    self.state = state
                }
                // Country
                if let country = placeMark.country {
                    addressString = addressString + country + ", "
                    print(country)
                    self.country = country
                }
                // Zip code
                if let zip = placeMark.postalCode {
                    addressString = addressString + zip + ", "
                    print(zip)
                    self.zipcode = zip
                }
                self.addressLbl.text = addressString
                print(addressString)
            }
           
        })
        
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmBtnAction(_ sender: Any) {
//        self.dismissSwiftToast(true)
        
        if addressLbl.text == ""{
            
        }else{
            let defaults = UserDefaults.standard
            defaults.set(addressLbl.text, forKey: "ADDRESS")
            defaults.synchronize()
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name("USERUPDATE"), object: nil)
        }
    }
    
    @IBAction func selectLocatinBtnAction(_ sender: UIButton) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
}
extension SelectAddressViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController'
        // Then display the name in textField
        let lat = place.coordinate.latitude
        let lon = place.coordinate.longitude
        let CurrentLat = String(lat)
        let CurrentLong = String(lon)
        Config().AppUserDefaults.set(CurrentLat, forKey: "LAT")
        Config().AppUserDefaults.set(CurrentLong, forKey: "LONG")
        print("lat lon",lat,lon)
        let titleName = place.formattedAddress ?? ""
        self.addressLbl.text = titleName
        Config().AppUserDefaults.set(titleName, forKey: "TITLE")
        // Dismiss the GMSAutocompleteViewController when something is selected
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
}

extension SelectAddressViewController : GMSMapViewDelegate{
    
//    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
//        myMarker?.map = nil
//        let coordinate = mapView.projection.coordinate(for: mapView.center)
//        myMarker = GMSMarker(position: coordinate)
//        myMarker?.map = mapview
//
//        self.getAddressFromLatLon(pdblLatitude: "\(coordinate.latitude)", withLongitude: "\(coordinate.longitude)")
//
//    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
            self.myMarker?.position = position.target
//            print(self.myMarker!.position)
        if self.myMarker?.position == nil{
            self.lat = Config().AppUserDefaults.value(forKey: "latti") as! Double
            self.long = Config().AppUserDefaults.value(forKey: "latti") as! Double
        }else{
            self.lat = (self.myMarker?.position.latitude)!
            self.long = (self.myMarker?.position.longitude)!
            Config().AppUserDefaults.setValue(self.lat, forKey: "latti")
            Config().AppUserDefaults.setValue(self.long, forKey: "longi")
        }
        
        let aGMSGeocoder: GMSGeocoder = GMSGeocoder()
        aGMSGeocoder.reverseGeocodeCoordinate(CLLocationCoordinate2DMake(self.lat, self.long), completionHandler: { gmsReverseGeocodeResponse,error in
                let gmsAddress = gmsReverseGeocodeResponse?.firstResult()
                let lines = gmsAddress?.lines
                let city = gmsAddress?.locality ?? ""
                let state = gmsAddress?.administrativeArea ?? ""
                let country = gmsAddress?.country ?? ""
                let zipeCode = gmsAddress?.postalCode ?? ""
                
                print("Response is = \(gmsAddress)")
                print("Response is = \(lines)")
                print("Response is = \(city)")
                print("Response is = \(state)")
                print("Response is = \(country)")
                print("Response is = \(zipeCode)")
            
                self.addressLbl.text = lines?.joined(separator: "\n")
                self.city = city
                self.state = state
                self.country = country
                self.zipcode = zipeCode
            
            })
            
//            let geocoder = GMSGeocoder()
//            let coordinate = CLLocationCoordinate2DMake(Double((self.myMarker?.position.latitude)!),Double((self.myMarker?.position.longitude)!))
//            self.lat = self.myMarker?.position.latitude as! Double
//            self.long = self.myMarker?.position.longitude as! Double
//            print("Drag latitude",self.lat)
//            print("Drag longitude",self.long)
//
//            geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
//                if let address = response?.firstResult() {
//                    let lines = gmsAddress.lines! as [String]
//                    let city = address.locality ?? ""
//                    let state = address.administrativeArea ?? ""
//                    let country = address.country ?? ""
//                    let zipeCode = address.postalCode ?? ""
//                    print("Response is = \(address)")
//                    print("Response is = \(lines)")
//                    print("Response is = \(city)")
//                    print("Response is = \(state)")
//                    print("Response is = \(country)")
//                    print("Response is = \(zipeCode)")
//
//                    self.addressLbl.text = lines.joined(separator: "\n")
//                    self.city = city
//
//                }
                self.myMarker?.title = self.addressLbl.text
                self.myMarker?.map = self.mapview
        }
    
        func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
            self.mapview.isMyLocationEnabled = true
            
            if (gesture) {
                self.mapview.selectedMarker = nil
            }
            
        }
}
