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
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var clothesIcon: UIImageView!
    
    var clothesScore = 0
    var currentTemp = 0
    var windSpeed = 0
    var windSpeedEffectOnTemperature = 0
    var humidityPercent = 0
    var humidityEffectOnTemperature = 0
    
    var weatherSum = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getJson()
        self.celTemp.layer.cornerRadius = 0.0
        self.celTemp.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getJson() {
        
        var jsonURL = "http://api.openweathermap.org/data/2.5/weather?q=London,uk"
        
        Alamofire.request(.GET, jsonURL).responseJSON {
            (request, response, json, error) in
            if (json != nil) {
                var jsonObj = JSON(json!)
                println(jsonObj)
                var location = jsonObj["name"].stringValue
                self.weatherSum = jsonObj["weather"][0]["description"].stringValue
                self.currentTemp = jsonObj["main"]["temp"].intValue - 273
                self.windSpeed = jsonObj["wind"]["speed"].intValue
                self.humidityPercent = jsonObj["main"]["humidity"].intValue
                self.setData(location, weatherSum: self.weatherSum)
            }
        }
        
    }
    
    func setData(location: String, weatherSum: String) {
        
        setDataToText(location, weatherSum: weatherSum)
        determineTempScore()
        setLocationImage(location)
        setWeatherIcon()
        
    }
    
    func setDataToText(location: String, weatherSum: String) {
        
        self.cityText.text = location.uppercaseString
        self.weatherSummary.text = "(" + weatherSum.capitalizedString + ")"
        self.celTemp.text = String(self.currentTemp)
        self.windText.text = String(self.windSpeed) + "mph winds"
        self.humidText.text = String(self.humidityPercent) + "% humidity"

    }
    
    func setWeatherIcon() {
        
        if (self.weatherSum == "broken clouds") {
            self.weatherIcon.image = UIImage(named: "london-01.png")
        }
        
    }
    
    func determineTempScore() {
        
        self.clothesScore = self.currentTemp
        
        if (self.humidityPercent >= 50) {
            self.clothesScore += 2
        } else {
            self.clothesScore -= 2
        }
        
        if (self.windSpeed < 6) {
            self.clothesScore += 2
        } else {
            self.clothesScore -= 2
        }
        
        setRecommendationText()
        
    }
    
    func setRecommendationText() {
        
        if (clothesScore < 3) {
            self.weatherText.text = "All the layers! Gloves, hat and scarf included"
        } else if (clothesScore >= 3 && clothesScore < 13) {
            self.weatherText.text = "Triple layer yourself! A hat would be nice too"
        } else if (clothesScore >= 13 && clothesScore < 20) {
            self.weatherText.text = "Double layer today. Wear a nice jumper"
        } else if (clothesScore >= 20) {
            self.weatherText.text = "T-shirt time!"
        }
        
    }
    
    func setLocationImage(location: String) {
        
        if (location == "London") {
            self.icons.image = UIImage(named: "london-01.png")
        } else {
            self.icons.image = nil
        }
    
    }
    
    func setClothingIcon() {
        
        if (self.clothesScore < 2) {
            self.clothesIcon.image = UIImage(named: "hat.png")
        } else {
            self.clothesIcon.image = nil
        }

    }
    
}

