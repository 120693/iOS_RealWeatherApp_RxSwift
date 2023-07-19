//
//  ResultViewController.swift
//  RealWeatherApp
//
//  Created by jhchoi on 2023/07/10.
//

import UIKit
import Kingfisher

public func kToC(kelvin: Double) -> String {
    let celsius: Double
    let result: String
    
    celsius = kelvin - 273.15
    
    result = String(format:"%.2f", celsius) + "°C"
    
    return result
}

class ResultViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
        
    var viewModel = ViewModel()
    
    var cityName:String
    
    init(cityName:String) {
        self.cityName = cityName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
            viewModel.getWeatherDict(cityName: cityName)
            
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.register(UINib(nibName: "HeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderView")
            tableView.register(UINib(nibName: "WeekTableViewCell", bundle: nil), forCellReuseIdentifier: "WeekTableViewCell")
            tableView.register(UINib(nibName: "CollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "CollectionTableViewCell")
            tableView.register(UINib(nibName: "FooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "FooterView")
        // Do any additional setup after loading the view.
    }
}

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return viewModel.dayName.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as! HeaderView
        
        if section == 0 {
            if let name = viewModel.weatherInfo?["name"] as? String {
                view.cityNameLabel.text = name
            }
            
            if let temp = viewModel.mainDict["temp"] as? Double {
                view.feelTempLabel.text = kToC(kelvin: temp)
            }
            
            if let icon = viewModel.weatherDict["icon"] as? String {
                guard let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") else { return nil }
                view.iconImageView.kf.setImage(with: url)
                view.iconImageView.contentMode = .scaleAspectFill
            }
            
            if let maxTemp = viewModel.mainDict["temp_max"] as? Double {
                view.maxTempLabel.text = "최고:" + kToC(kelvin: maxTemp)
            }
            
            if let minTemp = viewModel.mainDict["temp_min"] as? Double {
                view.minTempLabel.text = "최저:" + kToC(kelvin: minTemp)
            }
            
            return view
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "7일간의 일기예보"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        if section == 0 {
            return 250
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FooterView") as! FooterView
            
            return view
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        if section == 0 {
            
            return 160
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath) as! CollectionTableViewCell
            
            cell.mainData(with: viewModel.mainDict)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeekTableViewCell", for: indexPath) as! WeekTableViewCell
            
            cell.dayName.text = viewModel.dayName[indexPath.row]
            
            guard let url = URL(string: "https://openweathermap.org/img/wn/\(viewModel.dayIcon[indexPath.row])@2x.png") else { return cell}
            
            cell.dayIcon.kf.setImage(with: url)
            cell.dayIcon.contentMode = .scaleAspectFill

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        } else {
            return UITableView.automaticDimension
        }
    }
}
