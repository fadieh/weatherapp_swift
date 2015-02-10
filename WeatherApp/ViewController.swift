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
    
    var tempScore = 0
    var currentTemp = 0
    var windSpeed = 0
    var windSpeedEffectOnTemperature = 0
    var humidityPercent = 0
    var humidityEffectOnTemperature = 0
    

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
                var location = jsonObj["name"].stringValue.capitalizedString
                var weatherSum = jsonObj["weather"][0]["description"].stringValue
                self.currentTemp = jsonObj["main"]["temp"].intValue - 273
                self.windSpeed = jsonObj["wind"]["speed"].intValue
                self.humidityPercent = jsonObj["main"]["humidity"].intValue
                self.setData(location, weatherSum: weatherSum)
            }
        }
    }
    
    func setData(location: String, weatherSum: String) {
        setDataToText(location, weatherSum: weatherSum)
        determineTempScore()
        
        if (location == "London") {
            self.icons.image = UIImage(named: "london-01.png")
        } else {
            self.icons.image = nil
        }
        
    }
    
    func setDataToText(location: String, weatherSum: String) {
        self.cityText.text = location.uppercaseString
        self.weatherSummary.text = "(" + weatherSum.capitalizedString + ")"
        self.celTemp.text = String(self.currentTemp)
        self.windText.text = String(self.windSpeed) + "mph winds"
        self.humidText.text = String(self.humidityPercent) + "% humidity"
    }
    
    func determineTempScore() {
        
        self.tempScore = self.currentTemp
        
        if (self.humidityPercent >= 50) {
            self.tempScore += 2
        } else {
            self.tempScore -= 2
        }
        
        if (self.windSpeed < 6) {
            self.tempScore += 2
        } else {
            self.tempScore -= 2
        }
        
        setRecommendationText()
        
    }
    
    func setRecommendationText() {
        
        if (tempScore < 3) {
            self.weatherText.text = "Wear all the layers! Gloves, hat and scarf included"
        } else if (tempScore >= 3 && tempScore < 7) {
            self.weatherText.text = "Triple layer yourself! A hat would be nice too"
        } else if (tempScore >= 7 && tempScore < 18) {
            self.weatherText.text = "Double layer today. Wear a nice jumper"
        } else if (tempScore >= 18) {
            self.weatherText.text = "T-shirt time!"
        }
        
    }
    
    
    
    
}

