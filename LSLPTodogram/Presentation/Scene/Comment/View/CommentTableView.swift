//
//  CommentTableView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/17.
//

import UIKit
import RxCocoa
import RxSwift

final class CommentTableView: BaseTableView {
    private let disposeBag = DisposeBag()

    func bind(_ viewModel: CommentTableViewModel) {
        let comment = PublishSubject<String>()

        let input = CommentTableViewModel.Input(
            comment: comment
        )
        let output = viewModel.transform(input: input)
        output.items
            .drive(self.rx.items) { tableView, row, item in
                switch item {
                case .commentOwner(let item):
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: CommentOwnerCell.identifier
                    ) as? CommentOwnerCell else {return UITableViewCell()}

                    cell.configure(item: item)

                    cell.imageUrls
                        .bind(to: cell.imageCollectionView.rx.items(cellIdentifier: ImageCell.identifier)) { index, string, cell in
                            guard let cell = cell as? ImageCell else {return}

                            cell.removeButton.isHidden = true

                            let token = KeychainManager.read(key: KeychainKey.token.rawValue) ?? ""
                            cell.imageView.requestModifier(with: string, token: token)
                        }
                        .disposed(by: cell.disposeBag)

                    return cell

                case .comment(let item):
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: CommentCell.identifier
                    ) as? CommentCell else {return UITableViewCell()}

                    cell.profileImageButton.updateImage(image: UIImage(named: "profile"))
                    cell.profileNicknameButton.updateTitle(title: item.nick)

//                    Observable.just(item)
//                        .bind(with: self) { owner, item in
//                            cell.profileImageView.image = UIImage(systemName: "person")
//                            cell.nicknameLabel.text = item.nick
//                        }
//                        .disposed(by: cell.disposeBag)

                    cell.commentTextView.rx.didBeginEditing
                        .bind(with: self) { owner, _ in
                            if cell.commentTextView.textColor == Color.lightGray {
                                cell.commentTextView.text = nil
                                cell.commentTextView.textColor = Color.black
                            }
                        }
                        .disposed(by: cell.disposeBag)

                    cell.commentTextView.rx.didChange
                        .bind(with: self) { owner, _ in
                            UIView.setAnimationsEnabled(false)
                            owner.performBatchUpdates(nil)
                            UIView.setAnimationsEnabled(true)
                        }
                        .disposed(by: cell.disposeBag)

                    cell.commentTextView.rx.didEndEditing
                        .bind(with: self) { owner, _ in
                            if cell.commentTextView.text.isEmpty {
                                cell.commentTextView.text = "답글 남기기..."
                                cell.commentTextView.textColor = Color.lightGray
                            }
                        }
                        .disposed(by: cell.disposeBag)

                    cell.commentTextView.rx.text
                        .orEmpty
                        .bind(to: comment)
                        .disposed(by: cell.disposeBag)

                    return cell
                }
            }
            .disposed(by: disposeBag)
    }

}
