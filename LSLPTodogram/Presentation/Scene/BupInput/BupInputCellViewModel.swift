//
//  BupInputCellViewModel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/26.
//

import Foundation
import UIKit.UIColor
import UIKit.UIImage
import RxCocoa
import RxSwift

final class BupInputCellViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    // MARK: - 상위에서 전달
    let baseImages: PublishSubject<[UIImage]> = PublishSubject()

    // MARK: - 여기서 사용
    let images: Driver<[UIImage]>

    // MARK: - 상위로
    let upper_contentText = PublishRelay<String>()
    let upper_textColor = PublishRelay<UIColor>()
    let upper_imageButtonTapped = PublishRelay<Void>()
    let upper_tableViewBatchUpdate = PublishRelay<Void>()
    let upper_removeImageIndex = PublishRelay<Int>()


    init() {
        self.images = baseImages
            .asDriver(onErrorJustReturn: [])
    }

    struct Input {
        let contentText: PublishRelay<String>
        let textColor: PublishRelay<UIColor>
        let imageButtonTapped: ControlEvent<Void>
        let tableViewBatchUpdate: PublishRelay<Void>
        let removeImageIndex: PublishRelay<Int>
    }

    struct Output {
        let images: Driver<[UIImage]>
    }

    func transform(input: Input) -> Output {
        input.contentText
            .bind(to: upper_contentText)
            .disposed(by: disposeBag)

        input.textColor
            .bind(to: upper_textColor)
            .disposed(by: disposeBag)

        input.imageButtonTapped
            .bind(to: upper_imageButtonTapped)
            .disposed(by: disposeBag)

        input.tableViewBatchUpdate
            .bind(to: upper_tableViewBatchUpdate)
            .disposed(by: disposeBag)
        
        input.removeImageIndex
            .bind(to: upper_removeImageIndex)
            .disposed(by: disposeBag)

        return Output(images: images)
    }
}
