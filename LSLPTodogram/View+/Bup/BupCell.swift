//
//  BupCell.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/11.
//

import UIKit
import RxCocoa
import RxSwift

enum BupCellStyle {         // TODO: 커멘드 달 때 커뮤니케이션 뷰를 없애야함 여차하면 시발 걍 넘어가부러~
    case normal
    case noCommunication
}

final class BupCell: BaseTableViewCell {
    var disposeBag = DisposeBag()

    let profile = PublishRelay<Profile>()
    let bup = PublishRelay<Bup>()

    let bupView = BupView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        bup
            .bind(with: self) { owner, bup in
                owner.bupView.infoView.profileImageView.image = UIImage(systemName: "person")
                owner.bupView.infoView.nicknameLabel.text = bup.nick
                owner.bupView.infoView.titleLabel.text = bup.title

                owner.bupView.contentView0.bupContentLabel.text = bup.content0
                owner.bupView.contentView1.bupContentLabel.text = bup.content1
                owner.bupView.contentView2.bupContentLabel.text = bup.content2

                let contentStackView = owner.bupView.contentStackView
                for subview in contentStackView.arrangedSubviews {
                    if let contentView = subview as? BupContentView {
                        if !(contentView.bupContentLabel.text!.isEmpty) {
                            contentView.isHidden = false
                        } else {
                            contentView.isHidden = true
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
    }

    func configure(_ item: Bup) {

    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        contentView.addSubview(bupView)
    }

    override func initialLayout() {
        super.initialLayout()

        bupView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }

}
