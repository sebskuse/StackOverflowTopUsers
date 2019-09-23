//
//  ProfileImageContext.swift
//  StackOverflowTopUsers
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Foundation
import UIKit

protocol ProfileImageRetrieving {
    /// Retrieves a profile image for the specified user
    /// - Parameter user: The user to fetch the profile image for.
    /// - Parameter completion: A completion on success or failure.
    func profileImage(for user: User, completion: @escaping (Result<UIImage, Error>) -> Void) -> Cancellable
}

class ProfileImageContext: ProfileImageRetrieving {
    let session: Session

    init(session: Session = NetworkSession()) {
        self.session = session
    }

    func profileImage(for user: User, completion: @escaping (Result<UIImage, Error>) -> Void) -> Cancellable {
        let request = ProfileImageRequest(url: user.profileImage)
        return session.perform(request) { (res: Result<ProfileImage, Error>) in
            completion(res.map { $0.image })
        }
    }
}
