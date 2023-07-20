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
    
    // = PublishSubject<[String: Any]>()
    var weatherValues = PublishSubject<[Any]>()
    
    var mainDict = PublishSubject<[String: Any]>()
    var windDict = PublishSubject<[String: Any]>()
    // Subject 도 결국은 Observable 이다.
    // subject 로 observable 을 사용하면 값을 외부에서 넣어줄 수 있게 된다.
    var weatherDict = PublishSubject<[String: Any]>()
    var coordDict = PublishSubject<[String: Any]>()
    
    var dayName: [String] = ["월","화","수","목","금","토","일"]
    var dayIcon: [String] = ["10d","01d","02d","03d","04d","11d","13d"]
    
    
    func getWeatherDict(cityName: String) {
            
        Task {
            weatherInfo = try await api.getApi(cityName: cityName)
            
            if let weatherInfo = weatherInfo {
                for (_ , value) in weatherInfo {
                    // 배열 생성
                    var valuesArray: [Any] = []
                    valuesArray.append(value)
                    
                    weatherValues.onNext(valuesArray)
                }
            }
            
            if let dictionary = weatherInfo,
               let mainDictionary = dictionary["main"] as? [String: Any],
               let windDictionary = dictionary["wind"] as? [String: Any],
               let coordDictionary = dictionary["coord"] as? [String: Any],
               let weatherArray = dictionary["weather"] as? [Any],
               let weatherDictionary = weatherArray.first as? [String: Any] {

                mainDict.onNext(mainDictionary)
                windDict.onNext(windDictionary)
                coordDict.onNext(coordDictionary)
                
                var weatherValues: [String: Any] = [:]
                for (key, value) in weatherDictionary {
                    weatherValues[key] = value
                }
                weatherDict.onNext(weatherValues)
            }
        }
    }
}
