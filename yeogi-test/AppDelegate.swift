import Foundation
import Appier
import AppTrackingTransparency
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Override point for customization after application launch
        let QG = QGSdk.getSharedInstance()
        
        //display App ID
        print("userId: \(QG.getAppierId())")
        
        //set email
        QG.setEmail("jerry.kim@appier.com")
        
        #if DEBUG
        QG.onStart("2ec115a94e2e1cfe21aa", withAppGroup: "group.com.kimjerry.yeogi-test.notification", setDevProfile: true)
        #else
        QG.onStart("2ec115a94e2e1cfe21aa", withAppGroup: "group.com.kimjerry.yeogi-test.notification", setDevProfile: false)
        #endif
        
        // Check and request ATT permission
        if #available(iOS 14, *) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Adding delay to ensure app is fully launched
                self.requestTrackingPermission()
                
                /* retrieve data permission settings */
                
                //current settings for IDFA
                print("isCollectIDFA: \(QG.dataTrackingConfig.isCollectIDFA)")

                //current settings for location data
                print("isCollectingLocation: \(QG.dataTrackingConfig.isCollectLocation)")
                
                //permission settings
                print("permission settings: \(QG.dataTrackingConfig)")
                
            }
        }
        
        return true
        
    }
    
    @available(iOS 14, *)
    func requestTrackingPermission() {
        let status = ATTrackingManager.trackingAuthorizationStatus
        switch status {
        case .authorized:
            print("Tracking already authorized")
        case .denied:
            print("Tracking already denied")
        case .restricted:
            print("Tracking restricted")
        case .notDetermined:
            print("Tracking not determined, requesting authorization")
            DispatchQueue.main.async {
                ATTrackingManager.requestTrackingAuthorization { status in
                    switch status {
                    case .authorized:
                        print("Tracking authorized")
                    case .denied:
                        print("Tracking denied")
                    case .restricted:
                        print("Tracking restricted")
                    case .notDetermined:
                        print("Tracking not determined")
                    @unknown default:
                        print("Unknown tracking status")
                    }
                }
            }
        @unknown default:
            print("Unknown tracking status")
        }
    }
    
}

