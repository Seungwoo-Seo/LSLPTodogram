//
//  BupInputCell.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/24.
//

import UIKit
import RxCocoa
import RxSwift

final class BupInputCell: BaseTableViewCell {
    var disposeBag = DisposeBag()

    private let profileImageButton = ProfileImageButton()
    private let profileNicknameButton = ProfileNicknameButton()
    let contentTextView = {
        let view = UITextView()
        view.text = "이슈 작성..."
        view.textColor = Color.lightGray
        view.font = .systemFont(ofSize: 15, weight: .semibold)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.isScrollEnabled = false
        view.sizeToFit()
        return view
    }()
    let imageCollectionView = ImageCollectionView(collectionViewLayout: .one(size: .zero))
    let buttonStackView = InputCommunicationButtonStackView()
    let lineView = LineView()

    func configure(_ item: Profile) {
        profileImageButton.updateImage(image: UIImage(named: "profile"))
        profileNicknameButton.updateTitle(title: item.nick)
    }

    func bind(_ viewModel: BupInputCellViewModel) {

        let contentText = PublishRelay<String>()
        let textColor = PublishRelay<UIColor>()
        let tableViewBatchUpdate = PublishRelay<Void>()
        let removeImageIndex = PublishRelay<Int>()

        let input = BupInputCellViewModel.Input(
            contentText: contentText,
            textColor: textColor,
            imageButtonTapped: buttonStackView.imageButton.rx.tap,
            tableViewBatchUpdate: tableViewBatchUpdate,
            removeImageIndex: removeImageIndex
        )
        let output = viewModel.transform(input: input)

        // MARK: - text

        contentTextView.rx.didBeginEditing
            .bind(to: contentTextView.rx.beginUpdate)
            .disposed(by: disposeBag)

        contentTextView.rx.didChange
            .bind(to: tableViewBatchUpdate)
            .disposed(by: disposeBag)

        contentTextView.rx.didEndEditing
            .bind(to: contentTextView.rx.endUpdate)
            .disposed(by: disposeBag)

        contentTextView.rx.text
            .orEmpty
            .bind(to: contentText)
            .disposed(by: disposeBag)

        contentTextView.rx.observe(\.textColor)
            .compactMap { $0 }
            .bind(to: textColor)
            .disposed(by: disposeBag)

        // MARK: - images

        output.images
            .debug()
            .drive(imageCollectionView.rx.items(cellIdentifier: ImageCell.identifier)) { index, image, cell in
                guard let cell = cell as? ImageCell else {return}
                cell.imageView.image = image

                cell.removeButton.rx.tap
                    .withLatestFrom(Observable.just(index))
                    .bind(to: removeImageIndex)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)

        output.images
            .drive(rx.test)
            .disposed(by: disposeBag)

        output.images
            .map { _ in Void() }
            .asObservable()
            .bind(to: tableViewBatchUpdate)
            .disposed(by: disposeBag)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            profileImageButton,
            profileNicknameButton,
            contentTextView,
            lineView,
            imageCollectionView,
            buttonStackView
        ].forEach { contentView.addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 16
        let inset = 8
        profileImageButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(offset)
            make.leading.equalToSuperview().inset(inset)
        }

        profileNicknameButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton)
            make.leading.equalTo(profileImageButton.snp.trailing).offset(offset/2)
            make.trailing.lessThanOrEqualToSuperview().inset(inset)
        }

        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(profileNicknameButton.snp.bottom).offset(offset/2)
            make.leading.equalTo(profileNicknameButton.snp.leading)
            make.trailing.equalToSuperview().inset(inset)
        }

        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(offset/2)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(0)
        }

        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(offset)
            make.leading.equalTo(contentTextView)
            make.trailing.lessThanOrEqualTo(contentTextView)
            make.bottom.equalToSuperview().inset(inset)
        }

        lineView.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(offset/2)
            make.centerX.equalTo(profileImageButton)
            make.bottom.equalTo(buttonStackView)
        }
    }

}

private extension Reactive where Base: UITextView {

    var beginUpdate: Binder<Void> {
        return Binder(base) { (textView, _) in
            if textView.textColor == Color.lightGray {
                textView.text = nil
                textView.textColor = Color.black
            }
        }
    }

    var endUpdate: Binder<Void> {
        return Binder(base) { (textView, _) in
            if textView.text.isEmpty {
                textView.text = "이슈 작성..."
                textView.textColor = Color.lightGray
            }
        }
    }

}

private extension Reactive where Base: BupInputCell {

    var test: Binder<[UIImage]> {
        return Binder(base) { (cell, images) in
            let size = images.first?.size ?? CGSize(width: 0, height: 0)

            let contentTextView = cell.contentTextView
            let imageCollectionView = cell.imageCollectionView
            let buttonStackView = cell.buttonStackView

            if images.count == 1 {
                imageCollectionView.snp.remakeConstraints { make in
                    make.top.equalTo(contentTextView.snp.bottom).offset(16/2)
                    make.horizontalEdges.equalTo(contentTextView)
                    make.height.equalTo(size.height/2)
                }

                buttonStackView.isHidden = true
                buttonStackView.snp.remakeConstraints { make in
                    make.top.equalTo(imageCollectionView.snp.bottom)
                    make.leading.equalTo(contentTextView)
                    make.trailing.lessThanOrEqualTo(contentTextView)
                    make.bottom.equalToSuperview().inset(16)
                    make.height.equalTo(0)
                }

                cell.layoutIfNeeded()

                imageCollectionView.collectionViewLayout = ImageCollectionViewLayout.one(
                    size: CGSize(width: imageCollectionView.bounds.width, height: size.height/2)
                ).layout

            } else if images.count > 1 {
                let height = (cell.window?.windowScene?.screen.bounds.height ?? 0) / 3

                imageCollectionView.snp.remakeConstraints { make in
                    make.top.equalTo(contentTextView.snp.bottom).offset(16/2)
                    make.horizontalEdges.equalToSuperview()
                    make.height.equalTo(height)
                }

                buttonStackView.isHidden = true
                buttonStackView.snp.remakeConstraints { make in
                    make.top.equalTo(imageCollectionView.snp.bottom)
                    make.leading.equalTo(contentTextView)
                    make.trailing.lessThanOrEqualTo(contentTextView)
                    make.bottom.equalToSuperview().inset(16)
                    make.height.equalTo(0)
                }

                cell.layoutIfNeeded()

                imageCollectionView.collectionViewLayout = ImageCollectionViewLayout.many(
                    size: CGSize(width: imageCollectionView.bounds.width / 2, height: height)
                ).layout
                
            } else {
                imageCollectionView.snp.remakeConstraints { make in
                    make.top.equalTo(contentTextView.snp.bottom).offset(16/2)
                    make.horizontalEdges.equalToSuperview()
                    make.height.equalTo(0)
                }

                buttonStackView.isHidden = false
                buttonStackView.snp.remakeConstraints { make in
                    make.top.equalTo(imageCollectionView.snp.bottom).offset(16)
                    make.leading.equalTo(contentTextView)
                    make.trailing.lessThanOrEqualTo(contentTextView)
                    make.bottom.equalToSuperview().inset(16)
                }

                cell.layoutIfNeeded()
            }
        }
    }

}
