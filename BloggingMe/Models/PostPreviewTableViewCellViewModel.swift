//
//  PostPreviewTableViewCellViewModel.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 18.10.2022.
//

import Foundation

final class PostPreviewTableViewCellViewModel {
    let title: String
    let imageUrl: URL?
    var imageData: Data?

    init(title: String, imageUrl: URL?) {
        self.title = title
        self.imageUrl = imageUrl
    }
}
