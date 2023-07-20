//
//  CollectionTableViewCell.swift
//  RealWeatherApp
//
//  Created by jhchoi on 2023/07/10.
//

import UIKit
import RxSwift
import RxCocoa

class CollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel = ViewModel()
    
    let disposebag = DisposeBag() 
    
    let titlesList = ["🌡️체감온도", "💧습도", "⬇️최저기온", "⬆️최고기온"]
    
    // BehaviorRelay는 RxSwift에서 값의 상태를 추적하고 옵저버블로 값을 방출하는 클래스
    // 값이 업데이트될 때마다 해당 값을 셀의 레이블에 바인딩
    var feelsLikeData = BehaviorRelay<String?>(value: nil)
    var humidityData = BehaviorRelay<String?>(value: nil)
    var minTempData = BehaviorRelay<String?>(value: nil)
    var maxTempData = BehaviorRelay<String?>(value: nil)
    
    var spacing: CGFloat = 10.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func mainData(with data: [String: Any]) {
        if let feelsLike = data["feels_like"] as? Double {
            // 변수에 값을 할당하려면 accept() 메서드를 사용
            feelsLikeData.accept(kToC(kelvin: feelsLike))
        }
        
        if let humidity = data["humidity"] as? Double {
            humidityData.accept(String(humidity) + "%")
        }
        
        if let minTemp = data["temp_min"] as? Double {
            minTempData.accept(kToC(kelvin: minTemp))
        }
        
        if let maxTemp = data["temp_max"] as? Double {
            maxTempData.accept(kToC(kelvin: maxTemp))
        }
    }
    
}

extension CollectionTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titlesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.titleLabel.text = titlesList[indexPath.row]
        
        if titlesList[indexPath.row] == "🌡️체감온도" {
            feelsLikeData
                .map { $0 ?? "" } // 옵셔널 해제
                .bind(to: cell.contentLabel.rx.text) // 해당 값들을 셀의 레이블에 바인딩하려면 bind(to:) 메서드를 사용
                .disposed(by: disposebag)
        }
        
        if titlesList[indexPath.row] == "💧습도" {
            humidityData
                .map { $0 ?? "" }
                .bind(to: cell.contentLabel.rx.text)
                .disposed(by: disposebag)
        }
        
        if titlesList[indexPath.row] == "⬇️최저기온" {
            minTempData
                .map { $0 ?? "" }
                .bind(to: cell.contentLabel.rx.text)
                .disposed(by: disposebag)
        }
        
        if titlesList[indexPath.row] == "⬆️최고기온" {
            maxTempData
                .map { $0 ?? "" }
                .bind(to: cell.contentLabel.rx.text)
                .disposed(by: disposebag)
        }
        
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.systemGray4.cgColor
        cell.layer.borderWidth = 2.0
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let width = (collectionView.bounds.width - spacing * 3) / 2        
        
        return CGSize(width: width, height: 150)
    }
}
