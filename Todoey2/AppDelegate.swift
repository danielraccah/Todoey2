//
//  AppDelegate.swift
//  Todoey2
//
//  Created by Daniel Raccah on 14/02/18.
//  Copyright © 2018 Daniel Raccah. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
    
        
        do{
            
            _ = try Realm()

        }catch{

            print("Error initialisin new Realm, \(error)")
        }
        
        return true
    }

    
    

}

