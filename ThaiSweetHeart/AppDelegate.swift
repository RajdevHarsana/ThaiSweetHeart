//
//  AppDelegate.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 30/10/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import UserNotifications
import CoreLocation
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import AVFoundation
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import FirebaseCore

var lat = Double()
var Long = Double()
var membershiptype = String()
var trial_limit = String()
var membership_limit = String()
var goldSwipeCountLimit = String()
var matchSwipeCountLimit = String()
var newSwipeCountLimit = String()
var suggestionSwipeCountLimit = String()
var language = String()

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate,UNUserNotificationCenterDelegate,CLLocationManagerDelegate {
    
    var window: UIWindow?
    var locationManager: CLLocationManager!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//            appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (credentialState, error) in
//                switch credentialState {
//                case .authorized:
//                    break // The Apple ID credential is valid.
//                case .revoked, .notFound:
//                    // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
//                    DispatchQueue.main.async {
//                        self.window?.rootViewController?.showLoginViewController()
//                    }
//                default:
//                    break
//                }
//            }
        UserDefaults.standard.removeObject(forKey: "PopUp")
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "NavigationBarImage")?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: .default)
        
//        UIApplication.shared.statusBarView?.backgroundColor = .red

        UIApplication.shared.statusBarStyle = .darkContent
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        let stackViewAppearance = UIStackView.appearance(whenContainedInInstancesOf: [UINavigationBar.self])
        stackViewAppearance.spacing = -10
        
        GMSServices.provideAPIKey("AIzaSyC4JU4fmfFQ8eHsksAF1GFbQePKev4Taak")
        GMSPlacesClient.provideAPIKey("AIzaSyD0tudEKZMvuqLW-cxqQ-qtSrHIZjzlFm8")
        
//        GMSServices.provideAPIKey("AIzaSyBszIcP5AH95xQiaVsmefl65wtvGAaGjYk")
//        GMSPlacesClient.provideAPIKey("AIzaSyB3F_B_YH0XuWy_EB-zK-w4hyNJ1vjEJqQ")
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            self.locationManager.startUpdatingLocation()
        }
        
        var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
        GIDSignIn.sharedInstance().clientID = "809030198048-majnh75ojs58gtdgtjnqt72640342at6.apps.googleusercontent.com"//Google Login
        FirebaseApp.configure()
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)//FaceBook Login
        Thread.sleep(forTimeInterval: 2.0)
        
        IQKeyboardManager.shared.enable = true
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {__, _  in })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
        }else{
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            Messaging.messaging().delegate = self
        }
        application.registerForRemoteNotifications()
        
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let google = GIDSignIn.sharedInstance().handle(url)
        return ApplicationDelegate.shared.application(app, open: url, options: options) || google
    }
    func application(_ application: UIApplication,open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let google = GIDSignIn.sharedInstance().handle(url)
        let facebook = ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        return google || facebook
    }
    
    func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return outputImage!
    }
    
    //MARK: - location delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        lat = userLocation.coordinate.latitude
        Long = userLocation.coordinate.longitude
        //        print("Current Lat",lat)
        //        print("Current Long",Long)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                //print("error in reverseGeocode")
            }
            if placemarks == nil{
                //print("Some Error Print")
            }else{
                let placemark = placemarks! as [CLPlacemark]
                if placemark.count>0{
                }
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
            }
            Messaging.messaging().apnsToken = deviceToken
            Messaging.messaging().isAutoInitEnabled = true
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
        let deafults = UserDefaults.standard
        deafults.set(fcmToken, forKey: "deviceToken")
        deafults.synchronize()
        print("Firebase registration token: \(fcmToken)")
    }
    
    func  application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("i am not available in simulator \(error)")
    }
    //MARK:- Click on notification
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let userInfo = userInfo as! [String: Any]
        print(userInfo)
        
    }
    private func userNotificationCenter(center: UNUserNotificationCenter, willPresentNotification notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        //Handle the notification
        completionHandler(
            [UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])
    }
    
    //MARK:- Function will call when application in active state
    func userNotificationCenter(_ center: UNUserNotificationCenter,willPresent notification: UNNotification,withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
        let userInfo = notification.request.content.userInfo as! [String: Any]
        print(userInfo)
    }
    func applicationWillResignActive(_ application: UIApplication) {
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    //MARK:-//Play Audio when device in silent mode
    func applicationDidBecomeActive(_ application: UIApplication) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
}

