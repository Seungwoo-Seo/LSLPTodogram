//
//  BupInputViewModel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/30.
//

import Foundation
import UIKit.UIColor
import UIKit.UIImage
import PhotosUI.PHPicker
import RxCocoa
import RxSwift

final class BupInputViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    // MARK: - SubViewModel
    let bupInputCellViewModel = BupInputCellViewModel()

    private var baseItems: [Profile] = []
    private let items: BehaviorRelay<[Profile]> = BehaviorRelay(value: [])

    var contentText: String?

    let imageResults = PublishRelay<[PHPickerResult]>()
    let selection: BehaviorRelay<[String: PHPickerResult]> = BehaviorRelay(value: [:])
    var baseImages: [UIImage] = []
    let images: BehaviorRelay<[UIImage]> = BehaviorRelay(value: [])
    var selectedAssetIdentifiers: [String] = []
    var width: CGFloat?
    var height: CGFloat?

    struct Input {
        let cancelBarButtonItemTapped: ControlEvent<Void>
        let postingButtonTapped: ControlEvent<Void>
    }

    struct Output {
        let items: BehaviorRelay<[Profile]>
        let isModalInPresentState: BehaviorRelay<Bool>
        let unwindState: PublishRelay<Bool>
        let imageButtonTapped: Signal<Void>
        let imagesUpdated: Signal<Void>
        let postingDone: PublishRelay<Void>
    }

    func transform(input: Input) -> Output {
        // Base
        let token = BehaviorRelay(value: KeychainManager.read(key: KeychainKey.token.rawValue) ?? "")

        // Output
        let isModalInPresentState = BehaviorRelay(value: false)
        let unwindState = PublishRelay<Bool>()
        let postingDone = PublishRelay<Void>()

        token
            .flatMapLatest { _ in
                return NetworkManager.shared.request(
                    type: ProfileResponseDTO.self,
                    api: ProfileRouter.read
                )
                .catch { error in
                    print("❌", error.localizedDescription)
                    return Single.never()
                }
            }
            .map { $0.toDomain() }
            .bind(with: self) { owner, profile in
                owner.baseItems = [profile]
                owner.items.accept(owner.baseItems)
            }
            .disposed(by: disposeBag)

        let unwindCheckList = Observable
            .combineLatest(
                bupInputCellViewModel.upper_contentText,
                bupInputCellViewModel.upper_textColor
            )

        unwindCheckList
            // 비었다면 false
            // 내용이 있는데 색깔이 lightgray이면 false
            // 내용이 있다면 true
            .map {
                if $0.0.isEmpty {
                    return false
                } else if !$0.0.isEmpty && $0.1 == Color.lightGray {
                    return false
                } else {
                    return true
                }
            }
            .bind(to: isModalInPresentState)    // true가 전달되면 화면이 내려가지 않음
            .disposed(by: disposeBag)

        input.cancelBarButtonItemTapped
            .withLatestFrom(unwindCheckList)
            .debug()
            .map { $0.0.isEmpty || $0.1 == Color.lightGray }
            .bind(to: unwindState)
            .disposed(by: disposeBag)

        input.postingButtonTapped
            .flatMapLatest { [unowned self] in
                return NetworkManager.shared.upload(
                    type: PostCreateResponse.self,
                    api: PostRouter.create(body: self.makeRequest())
                )
                .catch { error in
                    print("❌", error.localizedDescription)
                    return Single.never()
                }
            }
            .debug()
            .bind(with: self) { owner, _ in
                postingDone.accept(Void())
            }
            .disposed(by: disposeBag)


        // MARK: - bupInputCellViewModel
        bupInputCellViewModel.upper_contentText
            .bind(with: self) { owner, text in
                owner.contentText = text
            }
            .disposed(by: disposeBag)

        imageResults
            .withLatestFrom(selection) { (selection: $1, results: $0) }
            .bind(with: self) { owner, value in

                let existingSelection = value.selection
                var newSelection = [String: PHPickerResult]()
                for result in value.results {
                    let identifier = result.assetIdentifier!
                    newSelection[identifier] = existingSelection[identifier] ?? result
                }

                owner.selection.accept(newSelection)
            }
            .disposed(by: disposeBag)

        selection
            .bind(with: self) { owner, dic in
                let group = DispatchGroup()

                for (identifier, result) in dic {
                    let itemProvider = result.itemProvider
                    if itemProvider.canLoadObject(ofClass: UIImage.self) {
                        group.enter()
                        itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                            guard error == nil else {return}
                            guard let uiImage = image as? UIImage else {return}
                            owner.selectedAssetIdentifiers.append(identifier)
                            owner.baseImages.append(uiImage)
                            group.leave()
                        }
                    }
                }

                group.notify(queue: .main) {
                    if let image = owner.baseImages.first {
                        owner.width = image.size.width
                        owner.height = image.size.height
                    }

                    owner.images.accept(owner.baseImages)
                }
            }
            .disposed(by: disposeBag)

        images
            .bind(to: bupInputCellViewModel.baseImages)
            .disposed(by: disposeBag)

        bupInputCellViewModel.upper_removeImageIndex
            .bind(with: self) { owner, index in
                owner.selectedAssetIdentifiers.remove(at: index)
                owner.baseImages.remove(at: index)
                owner.images.accept(owner.baseImages)
            }
            .disposed(by: disposeBag)


        return Output(
            items: items,
            isModalInPresentState: isModalInPresentState,
            unwindState: unwindState,
            imageButtonTapped: bupInputCellViewModel.upper_imageButtonTapped.asSignal(),
            imagesUpdated: bupInputCellViewModel.upper_tableViewBatchUpdate.asSignal(),
            postingDone: postingDone
        )
    }

}

extension BupInputViewModel {

    func makeRequest() -> PostCreateRequest {
        return PostCreateRequest(
            content: contentText,
            files: baseImages,
            product_id: "PersonalTodo",
            width: width,
            height: height
        )
    }

}
