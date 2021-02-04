//
//  APIService.swift
//  RXSwiftStudy
//
//  Created by BHJ on 2021/02/04.
//

import Foundation
import RxSwift

let FIX_URL  = "https://itunes.apple.com/search?entity=musicVideo&"

class APIService {
    static let shared = APIService()
    
    func apiRX(searchStr : String, contryStr : String) -> Observable<ResponseModel> {
        return Observable.create { emitter in
            self.getData(term: searchStr, country: contryStr) { (result) in
                switch result {
                case let .success(data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case let .failure(error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func getData(term:String , country : String , onComplete: @escaping (Result<ResponseModel,Error>)-> Void){
        
        var searchString = term.replacingOccurrences(of: " ", with: "")
        searchString = korStringEncoded(searchString)
        
        let countryString = country.replacingOccurrences(of: " ", with: "")
        
        let urlStirng = "\(FIX_URL)term=\(searchString)&country=\(countryString)"
        print(urlStirng)
        guard let url = URL(string: urlStirng)else {
            print("유효한 검색어를 입력하세요")
            return
        }
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            if let err = err{
                print(err)
                onComplete(.failure(err))
                return
            }
            do{
                let response = try JSONDecoder().decode(ResponseModel.self, from: data!)
                onComplete(.success(response))
            }
            catch let error{
                print(error)
                onComplete(.failure(error))
            }
        }.resume()
    }
    func korStringEncoded(_ string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? string
    }
}
