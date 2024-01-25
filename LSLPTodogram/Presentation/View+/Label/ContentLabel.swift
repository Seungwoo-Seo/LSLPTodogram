//
//  ContentLabel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/24.
//

import UIKit

final class ContentLabel: BaseLabel {

    var hashtagArr: [String]?

    override func initialAttributes() {
        super.initialAttributes()

        textColor = Color.black
        font = .systemFont(ofSize: 15, weight: .regular)
        numberOfLines = 0
    }

    func setHashTags(text: String) {
        let nsText: NSString = text as NSString
        let attrString = NSMutableAttributedString(string: nsText as String)
        attrString.addAttributes([.font: UIFont.systemFont(ofSize: 15, weight: .regular)], range: NSRange(location: 0, length: text.utf16.count))

        // 해시태그 패턴
        let hashtagDetector = try? NSRegularExpression(pattern: "#(\\w+)", options: .caseInsensitive)
        let results = hashtagDetector?.matches(in: text, options: [], range: NSMakeRange(0, text.utf16.count))

        hashtagArr = results?.map { nsText.substring(with: $0.range(at: 1)) }

        if let hashtags = hashtagArr, hashtags.count != 0 {
            for word in hashtags {
                let hashtag = "#" + word
                if hashtag.hasPrefix("#") {
                    let matchRange: NSRange = nsText.range(of: hashtag, options: .caseInsensitive)

                    // 폰트 크기 및 색상 설정
                    attrString.addAttribute(.foregroundColor, value: Color.systemBlue, range: matchRange)
                    attrString.addAttributes([.font: UIFont.systemFont(ofSize: 15, weight: .semibold)], range: matchRange)
                }
            }
        }

        self.attributedText = attrString
    }

}
