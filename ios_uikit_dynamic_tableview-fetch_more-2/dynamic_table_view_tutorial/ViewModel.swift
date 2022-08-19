//
//  ViewModel.swift
//  dynamic_table_view_tutorial
//
//  Created by 김지민 on 2022/08/19.
//  Copyright © 2022 Tuentuenna. All rights reserved.
//

import Foundation

//데이터를 서로 묶어주는 것 : Binding. 이를 위해 Rx나 Combine을 사용.
import Combine

//ViewModel : MVVM의 ViewModel. 뷰와 관련된 모델 - 즉 데이터 상태 갖고 있음. 변경, 수정, 삭제. 비즈니스 로직.
// API 연결 경우에도 데이터 처리 뷰모델에서.(데이터 업데이트). 그리고 렌더링은 뷰컨에서
class ViewModel: ObservableObject {
    
    enum AddingType {
        case append, prepend, reset
    }
    //ViewController에 있던 사용할 데이터들을 복붙해서 가져옴
    var appendingCount: Int = 0
    var prependingCount: Int = 0
    var prependingArray = ["1 앞에 추가" , "2 앞에 추가", "3 앞에 추가", "4 앞에 추가", "5 앞에 추가", "6 앞에 추가", "7 앞에 추가", "8 앞에 추가"]
    
    var addingArray = ["1 뒤에 추가" , "2 뒤에 추가", "3 뒤에 추가", "4 뒤에 추가", "5 뒤에 추가", "6 뒤에 추가", "7 뒤에 추가", "8 뒤에 추가"]
    
    //변경될 데이터. @Published를 붙이면 데이터가 변경되는 것을 감지할 수 있음. Publisher로 나올 수 있게 됨.
    @Published var tempArray : [String] = []
    
    var dataUpdatedAction = PassthroughSubject<AddingType, Never>()
    //Combine은 데이터도 보내고, 에러 타입도 보냄.
    //에러 타입은 안 보내는 걸로 하려고 Never 붙임.
    
    //데이터가 변경이 됐을 때를 알려주기 위해(emit) Combine에서는 Publisher라고 부르며, Rx에서는 Observable이라고 부른다.
    init(){
        print("ViewModel - init()")
    }
}

//MARK: - 리스트 관련
extension ViewModel {
    
    //외부에서 쓸 것이기 때문에 fileprivate 삭제함.
    func prependData(){
        print(#fileID, #function, #line, "")
        
        prependingCount = prependingCount + 1
        
        let tempPrependingArray = prependingArray.map{ $0.appending(String(prependingCount)) }
        
        self.tempArray.insert(contentsOf: tempPrependingArray, at: 0)
        self.dataUpdatedAction.send(.prepend)
        //prepend니까 prepend로 보내주고
//        self.myTableView.reloadData()
//        self.myTableView.reloadDataAndKeepOffset()
    }
    
    func appendData(){
        print(#fileID, #function, #line, "")
        
        appendingCount = appendingCount + 1
        
        let tempAddingArray = addingArray.map{ $0.appending(String(appendingCount)) }
        
        self.tempArray += tempAddingArray
        self.dataUpdatedAction.send(.append)
        //append니까 append로 보내줌
//        self.myTableView.reloadData()
    }
    
    func resetData(){
        print(#fileID, #function, #line, "")
        appendingCount = 0
        prependingCount = 0
        tempArray = []
//        self.myTableView.reloadData()
        self.dataUpdatedAction.send(.reset)
    }
}
