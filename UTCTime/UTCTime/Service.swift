//
//  Logic.swift
//  UTCTime
//
//  Created by 김지민 on 2022/08/19.
//

import Foundation

class Service {
    
    let repository = Repository()
    
    func fetchNow(onCompleted: @escaping (Model) -> Void){
        //서비스에서는 모델을 전달, 레포지토리에서는 엔티티를 전달
        repository.fetchNow{entity in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm'Z'"
            
            guard let now = formatter.date(from: entity.currentDateTime) else { return }

            let model = Model(currentDateTime: Date)
            onCompleted(model)
        }
    }
    
    func onYesterday(now: Date)-> Date {
        guard let yesterday = Calendar.current.date(byAdding: .day,
                                                    value: -1,
                                                    to: now) else {
            return now
        }
        return yesterday
    }
    
    func onNow() {
        
    }
    
    func onTomorrow(now: Date)-> Date {
        guard let tomorrow = Calendar.current.date(byAdding: .day,
                                                   value: +1,
                                                   to: now) else {
            return now
        }
        return tomorrow
    }
}
