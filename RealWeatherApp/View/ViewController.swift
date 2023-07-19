//
//  ViewController.swift
//  RealWeatherApp
//
//  Created by jhchoi on 2023/07/10.
//

import UIKit

class ViewController: UIViewController {

    var viewModel = ViewModel()
    
    @IBOutlet weak var cityNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "실시간 날씨 정보"
        cityNameTextField.text = "Seoul"

    }
    
    @IBAction func resultButton(_ sender: UIButton) {
        if let cityNameTextField = self.cityNameTextField.text {
            self.getResult(cityName: cityNameTextField)
        }
    }
    
    func getResult(cityName: String) {
        
        let resultViewController = ResultViewController(cityName: cityName)
        // 얘를 전역으로 선언하면 네비게이션으로 뒤로 갔을 때, 새로운 ResultViewController를 가져오는게 아니라
        // 이전의 ResultViewController를 가져와서 데이터 업데이트가 안됨!!

        self.navigationController?.pushViewController(resultViewController, animated: true)
    }
}


 
