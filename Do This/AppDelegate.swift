//
//  AppDelegate.swift
//  Do This
//
//  Created by Luis M Gonzalez on 6/12/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        do {
            _ = try Realm()
        } catch {
            print("Error initializing realm, \(error)")
        }
        return true
    }

}
