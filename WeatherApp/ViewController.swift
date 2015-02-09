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
    @IBOutlet weak var weatherText: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getJson()
        self.celTemp.layer.cornerRadius = 5.0
        self.celTemp.clipsToBounds = true
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
                var weather = jsonObj["weather"][0]["main"].stringValue
                self.setLocation(location, celTemp: celTemp, weather: weather)
            }
        }
        
        
    }
    
    func setLocation(location: String, celTemp: Int, weather: String) {
        self.cityText.text = location
        self.celTemp.text = String(celTemp) + "°C"
        println(NSDate())
        self.weatherText.text = weather
    }
    
}

