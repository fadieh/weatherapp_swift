//
//  ViewController.swift
//  WeatherApp
//
//  Created by Fadie on 09/02/2015.
//  Copyright (c) 2015 Fadie. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var cityText: UILabel!
    @IBOutlet weak var celTemp: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getJson()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getJson() {
        
        var jsonURL = "http://api.openweathermap.org/data/2.5/weather?q=London,uk"
        
        Alamofire.request(.GET, jsonURL).responseJSON {
            (request, response, json, error) in
            if (json != nil) {
                var jsonObj = JSON(json!)
                println(jsonObj)
                var location = jsonObj["name"].stringValue.capitalizedString
                var temp = jsonObj["main"]["temp"].intValue
                var celTemp = temp - 273
                self.setLocation(location, celTemp: celTemp)
            }
        }
        
        
    }
    
    func setLocation(location: String, celTemp: Int) {
        self.cityText.text = location
        self.celTemp.text = String(celTemp) + "°C"
        self.celTemp.layer.cornerRadius = 16.0
        self.celTemp.clipsToBounds = true
        println(NSDate())
    }
    
}

