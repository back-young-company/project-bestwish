//
//  UploadSupabase.swift
//  BestWish
//
//  Created by yimkeul on 6/12/25.
//

import Foundation

struct Onboarding: Encodable {
    let profileImageIndex: Int
    let nickname: String
    let gender: Int
    let birth: Date
    let role: String
// TODO: 추가하기
//    let platformSequence: [Int]

    enum CodingKeys: String, CodingKey {
        case profileImageIndex = "profile_image_code"
        case nickname, gender, birth, role
//        case platformSequence = "platform_sequence"
    }
}


extension SupabaseOAuthManager {
    func uploadUserInfo(to data: Onboarding) -> Bool {
        guard let userId = client.auth.currentSession?.user.id else { return false }

        let updates: Onboarding = Onboarding(profileImageIndex: data.profileImageIndex,
                                             nickname: data.nickname,
                                             gender: data.gender,
                                             birth: data.birth,
                                             role: "USER"
        )

        Task {
            do {
                let result = try await client
                    .from("UserInfo")
                    .update(updates)
                    .eq("id", value: userId)
                    .execute()

                print("전송성공 \(result.status)")

            } catch {
                print("전송실패 : \(error.localizedDescription)")
                return false
            }
            return true
        }
        return true
    }
}
