//
//  AppDelegate.swift
//  HealthyPlay
//
//  Created by john jozwiak on 6/27/20.
//  Copyright © 2020 john jozwiak. All rights reserved.
//

/*
 Attached is a csv file with 4 columns of data. The first column is an id column, and the remaining 3 are data columns.

 Please write an iOS app that:

     Processes the dataset and calculates mean and std deviation for each data column. Please optimize for performance and memory usage.
     Determines which samples for each column is more than 2 std deviations.
     Displays in UIKit or SwiftUI the mean and std deviation for each column. Display the column result immediately before processing the next column.
     Also displays the number of samples in each column are more than 2 std deviations.


 The spirit of this assignment is to spark a conversation with you about how you approached the assignment, and what choices you made.
 */
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // load the dataset here...from
        let (_,_,_) = loadCSV(fromPath:"")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

