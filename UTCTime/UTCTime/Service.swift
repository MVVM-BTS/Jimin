//
//  Logic.swift
//  UTCTime
//
//  Created by 김지민 on 2022/08/19.
//

import Foundation

class Service {
    
    let repository = Repository()
    
    var currentModel = Model(currentDateTime: Date())
    
    //Entity -> Model
    func fetchNow(onCompleted: @escaping (Model) -> Void){
        //서비스에서는 모델을 전달, 레포지토리에서는 엔티티를 전달
        repository.fetchNow{[weak self] entity in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm'Z'"
            
            guard let now = formatter.date(from: entity.currentDateTime) else { return }

            let model = Model(currentDateTime: now)
            self?.currentModel = model
            onCompleted(model)
        }
    }
    
    func moveDay(day: Int){
        guard let movedDay = Calendar.current.date(byAdding: .day,
                                                    value: day,
                                                    to: currentModel.currentDateTime) else {
            return
        }
        currentModel.currentDateTime = movedDay
    }
}
