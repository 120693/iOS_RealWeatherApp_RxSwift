//
//  ViewController.swift
//  RealWeatherApp
//
//  Created by jhchoi on 2023/07/10.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "실시간 날씨 정보"
        cityNameTextField.text = "Seoul"

    }
    
    @IBAction func resultButton(_ sender: UIButton) {
        if let cityNameTextField = self.cityNameTextField.text {
            self.getWeather(cityName: cityNameTextField)
        }
    }
    
    func getWeather(cityName: String) {
        
        let resultViewController = ResultViewController()
        // 얘를 전역으로 선언하면 네비게이션으로 뒤로 갔을 때, 새로운 ResultViewController를 가져오는게 아니라
        // 이전의 ResultViewController를 가져와서 데이터 업데이트가 안됨!!
        
        
        var components = URLComponents()
        
        let scheme = "https"
        let host = "api.openweathermap.org"
        let apiKey = "a8c1d55d8c112dbe5f0576f243f507ac"
        
        components.scheme = scheme
        components.host = host
        components.path = "/data/2.5/weather"
        components.queryItems = [URLQueryItem(name: "q", value: cityName), URLQueryItem(name: "appid", value: apiKey)]
        
        let url = components.url!
        
        let request = URLRequest(url: url)
        
        let session = URLSession(configuration: .default)
            
        session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            guard let weatherModel = try? decoder.decode(WeatherModel.self, from: data) else { return }
            // debugPrint(weatherModel)
            guard let weatherDictionary = self.encodeModelToDictionary(model: weatherModel) else { return }
            resultViewController.weatherInfo = weatherDictionary
            //debugPrint(weatherDictionary)
            // 메인 스레드에서 작업
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(resultViewController, animated: true)
            }
        }.resume()
    }
    
    func encodeModelToDictionary<T: Codable>(model: T) -> [String: Any]? {
        guard let jsonData = try? JSONEncoder().encode(model) else {
               return nil
           }
        guard let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] else {
               return nil
           }
        return dictionary
    }
}


 
