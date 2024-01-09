//
//  OthersProfile.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2024/01/08.
//

import Foundation

struct OthersProfile: Hashable {
    let id: String
    let nick: String
    let profileImageString: String?
    let followers: [Follower]?
    let following: [Following]?
    let hostID: String
}

extension OthersProfile {

    /// 내가 팔로잉하고 있는지
    var isFollowing: Bool {
        let followers = followers ?? []
        return followers.contains(where: { $0.id == hostID })
    }

    /// 상대가 나를 팔로잉하고 있는지
    var isFollowingToMe: Bool {
        let followings = following ?? []
        return followings.contains(where: { $0.id == hostID })
    }


    /// 로컬에서 팔로우 상태를 문자열로 리턴해줄 메서드
    /// - Parameter isSelected: 팔로우 버튼의 isSelected
    /// - Returns: 팔로우 상태 (문자열)
    func localFollowStateToString(isSelected: Bool) -> String {
        if isFollowingToMe {
            return isSelected ? "팔로잉" : "맞팔로우 하기"
        } else {
            return isSelected ? "팔로잉" : "팔로우"
        }
    }

    /// 로컬에서 팔로워 수를 문자열로 리턴해줄 메서드
    /// - Parameter isSelected: 팔로우 버튼의 isSelected
    /// - Returns: 팔로워 수 (문자열)
    func localFollowersCountToString(isSelected: Bool) -> String {
        let count = followers?.count ?? 0

        if isFollowing {
            return isSelected ? "팔로워 \(count)명" : "팔로워 \(count - 1)명"
        } else {
            return isSelected ? "팔로워 \(count + 1)명" : "팔로워 \(count)명"
        }
    }

    func followersCountToString() -> String {
        return "팔로워 \(followers?.count ?? 0)명"
    }

    func followingCountToString() -> String {
        return "팔로잉 \(following?.count ?? 0)명"
    }

    func followStateToString() -> String {
        guard let followers else {return "팔로우"}

        if followers.contains(where: { $0.id == hostID }) {
            return "팔로잉"
        } else {
            guard let following else {return "팔로우"}

            if following.contains(where: { $0.id == hostID }) {
                return "맞팔로우 하기"
            } else {
                return "팔로우"
            }
        }
    }

    func followStateToBool() -> Bool {
        guard let followers else {return false}

        if followers.contains(where: { $0.id == hostID }) {
            return true
        } else {
            return false
        }
    }

}
