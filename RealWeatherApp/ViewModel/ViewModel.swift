//
//  ViewModel.swift
//  RealWeatherApp
//
//  Created by jhchoi on 2023/07/19.
//

import Foundation
import RxSwift

class ViewModel {
    
    var api = Api() // Api 클래스의 인스턴스 생성
    
    var weatherInfo: [String:Any]?
    
    var weatherKeys: [String] = ["name","week","coord","main", "weather","wind"]
    var weatherValues: [Any] = []
    
    var mainDict : [String: Any] = [:]
    var windDict: [String: Any] = [:]
    var weatherDict: [String: Any] = [:]
    var coordDict: [String: Any] = [:]
    
    var dayName: [String] = ["월","화","수","목","금","토","일"]
    var dayIcon: [String] = ["10d","01d","02d","03d","04d","11d","13d"]
    
    
    func getWeatherDict(cityName: String) {
            
        Task {
            weatherInfo = try await api.getApi(cityName: cityName)
            
            if let weatherInfo = weatherInfo {
                for (_ , value) in weatherInfo {
                    weatherValues.append(value)
                    //print(value)
                }
            }
            if let dictionary = weatherInfo,
               let mainDictionary = dictionary["main"] as? [String: Any],
               let windDictionary = dictionary["wind"] as? [String: Any],
               let coordDictionary = dictionary["coord"] as? [String: Any],
               let weatherArray = dictionary["weather"] as? [Any],
               let weatherDictionary = weatherArray.first as? [String: Any] {

                mainDict = mainDictionary
                windDict = windDictionary
                coordDict = coordDictionary
                
                var weatherValues: [String: Any] = [:]
                for (key, value) in weatherDictionary {
                    weatherValues[key] = value
                }
                weatherDict = weatherValues
            }
        }
    }
}
