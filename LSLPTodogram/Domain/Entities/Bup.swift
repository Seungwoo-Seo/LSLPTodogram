//
//  Bup.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/11.
//

import Foundation

struct Bup: Hashable {
    let id: String
    let creator: Creator
    let content: String
    let time: String
    let width: CGFloat?
    let height: CGFloat?
    let image, hashTags: [String]?
    let likes: [String]?
    let comments: [Comment]?

    let hostID: String
}

extension Bup {
    /// 내가 좋아요를 한 게시글인지 판단할 수 있는 연산 프로퍼티
    var isIliked: Bool {
        let likes = likes ?? []
        return likes.contains(hostID)
    }

    /// 로컬에서 현재 좋아요 갯수를 문자열로 리턴해줄 메서드
    /// - Parameter isSelected: 좋아요버튼 선택 상태
    /// - Returns: 좋아요 갯수 문자열
    func localLikesCountString(isSelected: Bool) -> String {
        if let likes = likes {
            let count = likes.count
            if likes.contains(hostID) {
                return isSelected ? "\(count) 좋아요" : "\(count - 1) 좋아요"
            } else {
                return isSelected ? "\(count + 1) 좋아요" : "\(count) 좋아요"
            }
        } else {
            let count = isSelected ? 1 : 0
            return "\(count) 좋아요"
        }
    }


    /// 서버에서 전달 받은 좋아요 갯수를 문자열로 리턴해줄 메서드
    /// - Returns: 좋아요 갯수 문자열
    func serverLikesCountString() -> String {
        if let likes = likes {
            return "\(likes.count) 좋아요"
        } else {
            return "0 좋아요"
        }
    }

    /// 댓글 갯수를 문자열로 리턴해줄 메서드
    /// - Returns: 댓글 갯수 문자열
    func commentCountString() -> String {
        if let comments = comments {
            return "\(comments.count) 답글"
        } else {
            return "0 답글"
        }
    }
}

struct BupPage {
    let nextCursor: String
    let bups: [Bup]
}
