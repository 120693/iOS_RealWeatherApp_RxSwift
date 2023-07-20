//
//  ResultViewController.swift
//  RealWeatherApp
//
//  Created by jhchoi on 2023/07/10.
//

import UIKit
import Kingfisher
import RxSwift

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
    
    let disposebag = DisposeBag() // dispose 를 할 일들이 생길 때마다 DisposeBag 에 담아두었다가 한꺼번에 종료할 수 있다.
    
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
                view.cityNameLabel.text = cityName
                        
            viewModel.weatherDict
                .observe(on: MainScheduler.instance) // UI 관련 작업은 메인 스레드에서 이벤트 처리
                .subscribe(onNext: { [weak view] weatherDict in // .subscribe(onNext:) 메서드를 사용하여 Observable을 구독합니다. 이렇게 하면 Observable에서 이벤트가 발생할 때마다 클로저가 실행
                        guard let view = view else { return }
                        if let icon = weatherDict["icon"] as? String {
                            let urlString = "https://openweathermap.org/img/wn/\(icon)@2x.png"
                            if let url = URL(string: urlString) {
                                view.iconImageView.kf.setImage(with: url)
                                view.iconImageView.contentMode = .scaleAspectFill
                            }
                        }
                    })
                .disposed(by: disposebag)
                        
            viewModel.mainDict
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak view] mainDict in
                    guard let view = view else { return }
                    if let maxTemp = mainDict["temp_max"] as? Double {
                        view.maxTempLabel.text = "최고:" + kToC(kelvin: maxTemp)
                    }
                    if let temp = mainDict["temp"] as? Double {
                        view.feelTempLabel.text = kToC(kelvin: temp)
                    }
                    if let minTemp = mainDict["temp_min"] as? Double {
                        view.minTempLabel.text = "최저:" + kToC(kelvin: minTemp)
                    }
                })
                .disposed(by: disposebag)
            
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
            
            viewModel.mainDict
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { mainDick in
                    cell.mainData(with: mainDick)
                })
                .disposed(by: disposebag)
            
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
