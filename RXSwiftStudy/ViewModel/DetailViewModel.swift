//
//  DetailViewModel.swift
//  RXSwiftStudy
//
//  Created by BHJ on 2021/02/04.
//

import RxCocoa
import RxSwift


protocol DetailViewModelType {
    var outputs: DetailViewModelOutputs { get }
}

protocol DetailViewModelOutputs {
    var artistName: Observable<String> { get }
    var trackName: Observable<String> { get }
    var imgUrlStr: Observable<String> { get }
}

final class DetailViewModel: DetailViewModelOutputs,DetailViewModelType {
    
    var outputs: DetailViewModelOutputs { return self }
    var artistName: Observable<String>
    var trackName: Observable<String>
    var imgUrlStr: Observable<String>
    
    init(res: Results) {
        self.artistName = Observable.just(res.artistName)
        self.trackName = Observable.just(res.trackName)
        self.imgUrlStr = Observable.just(res.artworkUrl100)
    }
}
