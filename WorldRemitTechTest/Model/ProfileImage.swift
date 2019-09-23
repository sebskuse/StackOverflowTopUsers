//
//  ProfileImage.swift
//  WorldRemitTechTest
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Foundation
import UIKit

struct ProfileImage {
    let url: URL
    let image: UIImage
}

extension ProfileImage: Parsable {
    static func parse(data: Data?, response: URLResponse?, error _: Error?) -> Result<ProfileImage, Error> {
        guard let data = data else {
            return .failure(SessionError.noData)
        }

        guard let response = response as? HTTPURLResponse,
            response.statusCode < 400,
            let url = response.url else {
            return .failure(SessionError.invalidResponse)
        }
        guard let image = UIImage(data: data) else {
            return .failure(ImageError.unableToCreateImage)
        }
        return .success(ProfileImage(url: url, image: image))
    }
}

enum ImageError: Error {
    case unableToCreateImage
}
