//
//  ViewController.swift
//  dynamic_table_view_tutorial
//
//  Created by Jeff Jeong on 2020/09/01.
//  Copyright © 2020 Tuentuenna. All rights reserved.
//

import UIKit
import Combine

//ViewController : MVVM의 View뷰. 렌더링
class ViewController: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet var prependButton: UIBarButtonItem!
    @IBOutlet var resetButton: UIBarButtonItem!
    @IBOutlet var appendButton: UIBarButtonItem!
    
    var viewModel: ViewModel = ViewModel() //ViewController가 생성이 될 때 viewModel도 같이 생성됨.
    
    var disposableBag = Set<AnyCancellable>()
    //Rx에서는 disposable Bag이라고 씀. 버리는 데이터를 메모리에서 날리는 역할.
    //담아주고 구독해서 남은 애들을~
    
    
    //ViewController에 있던 데이터들은 지우고 ViewModel 파일로 이동.
    //변경될 데이터만 남겨 둠. ViewModel에 있는 tempArray와 연동되게 사용될 것임.
    var tempArray : [String] = []
//    var tempArray : [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 쎌 리소스 파일 가져오기
        let myTableViewCellNib = UINib(nibName: String(describing: MyTableViewCell.self), bundle: nil)
        
        // 쏄에 리소스 등록
        self.myTableView.register(myTableViewCellNib, forCellReuseIdentifier: "myTableViewCellId")
        
        self.myTableView.rowHeight = UITableView.automaticDimension
        self.myTableView.estimatedRowHeight = 120
        
        // 아주 중요
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        
        // 뷰모델의 데이터 상태 연동
        self.setBindings()
    }

    
    @IBAction func barButtonAction(_ sender: UIBarButtonItem) {
        print(#function, #line, "")
        switch sender {
        case prependButton:
            print("앞에 추가 버튼 클릭!")
            self.viewModel.prependData()
            // 값 바꾸는 부분은 뷰모델에서 하는 거니까 변경
            
        case resetButton:
            print("데이터 리셋 버튼 클릭!")
            self.viewModel.resetData()
        case appendButton:
            print("뒤에 추가 버튼 클릭!")
            self.viewModel.appendData()
        default: break
        }
    }
    
} // ViewController

//MARK: - 테이블뷰 관련 메소드
extension ViewController {
 //비즈니스 로직 코드들 삭제 후 뷰모델 파일로 이동
}

//MARK: - 뷰모델 관련
extension ViewController {
    
    ///뷰 모델의 데이터를 뷰컨의 리스트 데이터와 연동
    fileprivate func setBindings(){
        print("ViewController - setBindings")
        
        //list에 대한 바인딩.
        self.viewModel.$tempArray.sink{ (updatedList : [String]) in
            //여기서 넘어오는 Publisher를 구독한다. 넘어오는 이벤트를 받는다.
            //Rx의 subscribe와 같은 뜻.
            print("ViewController - updatedList.count: \(updatedList.count)")
            self.tempArray = updatedList //변경된 데이터 받아오고
//            self.myTableView.reloadData() //변경된 데이터 적용.
        }.store(in: &disposableBag)
       // ~여기에 담아 줌.
        
        //action에 대한 바인딩.
        self.viewModel.dataUpdatedAction.sink{ (addingType :
            ViewModel.AddingType) in
            print("ViewController - dataUpdatedAction: \(addingType)")
            switch addingType {
//            case .append, reset:
//                self.myTableView.reloadData()
            case .prepend:
                self.myTableView.reloadDataAndKeepOffset()
            default:
                self.myTableView.reloadData()
            }
        }.store(in: &disposableBag)
    }
}
//MARK: - UITableViewDelegate 관련 메소드
extension ViewController: UITableViewDelegate {
    
}

//MARK: - UITableViewDataSource 관련 메소드
extension ViewController: UITableViewDataSource {
    
    // 테이블 뷰 쎌의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tempArray.count
      }
      
    // 각 쎌에 대한 설정
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = myTableView.dequeueReusableCell(withIdentifier: "myTableViewCellId", for: indexPath) as! MyTableViewCell
        
        cell.userContentLabel.text = tempArray[indexPath.row]
        
        return cell
        
      }
}

extension UITableView {
    func reloadDataAndKeepOffset() {
        // 스크롤링 멈추기
        setContentOffset(contentOffset, animated: false)
        
        // 데이터 추가전 컨텐트 사이즈
        let beforeContentSize = contentSize
        reloadData()
        layoutIfNeeded()
        
        // 데이터 추가후 커텐트 사이즈
        let afterContentSize = contentSize
        
        // 데이터가 변경되고 리로드 되고 나서 컨텐트 옵셋 계산
        let calculatedNewOffset = CGPoint(
            x: contentOffset.x + (afterContentSize.width - beforeContentSize.width),
            y: contentOffset.y + (afterContentSize.height - beforeContentSize.height)
        )
        
        // 변경된 옵셋 설정
        setContentOffset(calculatedNewOffset, animated: false)
    }
}
