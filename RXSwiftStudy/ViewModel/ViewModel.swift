//
//  ViewModel.swift
//  RXSwiftStudy
//
//  Created by BHJ on 2021/02/04.
//

import Foundation
import RxSwift

protocol ViewModelOutputs {
    var errorMessage: Observable<NSError> { get }
}

class ViewModel : ViewModelOutputs {
    
    var outputs: ViewModelOutputs { return self }
    
    var errorMessage: Observable<NSError>
    var error = PublishSubject<Error>()
    
    init() {
        errorMessage = error.map{ $0 as NSError}
    }
    
    var listObservable = BehaviorSubject<[Results]>(value: [])
    
    var results = [Results]()
    var disposeBag = DisposeBag()
    
    var errorCount = 0
    var taskCount = 0
    
    //1. SearchBar Text + Country1, SearchBar Text + Country2 두개의 입력값으로 동시에 2개의 API 처리 - 대한 조건 처리
    func callAPI(searchStr : String, contry1Str : String , contry2Str : String) {
        
        self.results.removeAll()
        
        let group = DispatchGroup()
        
        if contry1Str != "" && !contry1Str.isEmpty {
            group.enter()
            DispatchQueue.global().async {
                self.taskCount += 1
                let client = APIService.shared
                client.apiRX(searchStr : searchStr, contryStr : contry1Str)
                    .subscribe(
                        onNext: { (result) in
                            guard let result = result.results else{
                                return
                            }
                            self.removeDuplicate(result)
                        },
                        onError: { (err) in
                            print(err.localizedDescription)
                            self.errorCount += 1
                            group.leave()
                            
                        },
                        onCompleted: {
                            print("onCompleted")
                            group.leave()
                            
                        })
                    .disposed(by: self.disposeBag)
            }
        }
        
        if contry2Str != "" && !contry2Str.isEmpty{
            group.enter()
            DispatchQueue.global().async {
                
                let client = APIService.shared
                self.taskCount += 1
                client.apiRX(searchStr : searchStr, contryStr : contry2Str)
                    .subscribe(
                        onNext: { (result) in
                            guard let result = result.results else{
                                return
                            }
                            self.removeDuplicate(result)
                        },
                        onError: { (err) in
                            print(err.localizedDescription)
                            self.errorCount += 1
                            group.leave()
                        },
                        onCompleted: {
                            print("onCompleted")
                            group.leave()
                        })
                    .disposed(by: self.disposeBag)
            }
        }
        group.notify(queue: .main){
            print("모든 작업이 완료 되었습니다.\(self.results.count)")
            self.errorAlertCheck(taskCount: self.taskCount, errorCount: self.errorCount)
            if self.results.count == 0 {
                print("검색결과가 없습니다.")
            }
            self.listObservable.onNext(
                self.results
            )
        }
    }
    
    func errorAlertCheck(taskCount: Int, errorCount : Int ) {
        print("taskCount\(taskCount), errorCount\(errorCount)")
        if taskCount <= errorCount && taskCount != 0 {
            self.error.onNext(NSError(domain:"모든 API에 연결 할 수 없음", code: -999, userInfo: nil))
        }
        self.taskCount = 0
        self.errorCount = 0
    }
    
    // 중복요소 필터링
    func removeDuplicate (_ array: [Results]) {
        let arr = array.filter{!self.results.contains($0)}
        for a in arr {
            self.results.append(a)
        }
    }
}
