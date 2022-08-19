//
//  ViewModel.swift
//  UTCTime
//
//  Created by 김지민 on 2022/08/19.
//

import Foundation

class ViewModel {
    var dateTimeString: String = "Loading..."
    
    let service = Service()
    
    func viewDidLoad(){
        service.fetchNow{ [weak self] model in
//            let dateString = self?.dateToString(date: model.currentDateTime)
//            self?.dateTimeString = dateString
            guard let self = self else {return}
            let dateString = self.dateToString(date: model.currentDateTime)
            self.dateTimeString = dateString
        }
    }
    
    private func dateToString(date: Date)->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
        return formatter.string(from: date)
    }
}
