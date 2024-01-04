//
//  CommunicationButton.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/24.
//

import UIKit

enum CommunicationButtonStyle {
    case like
    case comment
    case repost
    case share
    case ellipsis
    case image
    case hashTag

    var baseForegroundColor: UIColor? {
        switch self {
        case .comment, .repost, .share, .ellipsis: return Color.black
        case .image, .hashTag: return Color.lightGray
        default: return nil
        }
    }

    var image: UIImage? {
        switch self {
        case .comment: return UIImage(systemName: "message")
        case .repost: return UIImage(systemName: "goforward")
        case .share: return UIImage(systemName: "square.and.arrow.up")
        case .ellipsis: return UIImage(systemName: "ellipsis")
        case .image: return UIImage(systemName: "photo.on.rectangle")
        case .hashTag: return UIImage(systemName: "number")
        default: return nil
        }
    }

    var configurationUpdateHandler: UIButton.ConfigurationUpdateHandler? {
        switch self {
        case .like:
            return { button in
                switch button.state {
                case .selected:
                    button.configuration?.baseForegroundColor = Color.red
                    button.configuration?.image = UIImage(systemName: "heart.fill")
                default:
                    button.configuration?.baseForegroundColor = Color.black
                    button.configuration?.image = UIImage(systemName: "heart")
                }
            }
        default: return nil
        }
    }
}

final class CommunicationButton: BaseButton {

    private let style: CommunicationButtonStyle

    init(style: CommunicationButtonStyle) {
        self.style = style
        super.init(frame: .zero)

        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = style.baseForegroundColor
        config.background.backgroundColor = Color.clear
        config.image = style.image
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 0, bottom: 0, trailing: 0
        )
        configuration = config
        configurationUpdateHandler = style.configurationUpdateHandler
    }

//    override func initialHierarchy() {
//        super.initialHierarchy()
//
//        snp.makeConstraints { make in
//            make.size.equalTo(14)
//        }
//    }

}
