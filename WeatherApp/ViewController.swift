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
    @IBOutlet weak var windText: UILabel!
    @IBOutlet weak var humidText: UILabel!
    @IBOutlet weak var icons: UIImageView!
    @IBOutlet weak var weatherSummary: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getJson()
        self.celTemp.layer.cornerRadius = 0.0
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
                var weatherSum = jsonObj["weather"][0]["description"].stringValue
                var windSum = jsonObj["wind"]["speed"].intValue
                var humidity = jsonObj["main"]["humidity"].intValue
                println(windSum)
                self.setData(location, celTemp: celTemp, weather: weather, weatherSum: weatherSum, windSum: windSum, humidity: humidity)
            }
        }
        
        
    }
    
    func setData(location: String, celTemp: Int, weather: String, weatherSum: String, windSum: Int, humidity: Int) {
        self.cityText.text = location.uppercaseString
        self.celTemp.text = String(celTemp) + "°C"
        self.weatherSummary.text = "(" + weatherSum.capitalizedString + ")"
        self.windText.text = "Wind speed: " + String(windSum) + " mph"
        self.humidText.text = String(humidity) + "% humidity"
        println(NSDate())
        if (weather == "Clouds" && celTemp < 10 && celTemp > 4) {
            self.weatherText.text = "At least triple layer it today."
        } else if (weather == "Clouds" && celTemp < 4 && celTemp > 0) {
            self.weatherText.text = "I'd wear some gloves if I were you..."
        } else if (weather == "Clouds" && celTemp <= 0) {
            self.weatherText.text = "Throw yourself in a fire, it's below freezing!"
        }
        
        if (location == "London") {
            self.icons.image = UIImage(named: "london-01.png")
        } else {
            self.icons.image = nil
        }
        
    }
    
    
    
    
}

