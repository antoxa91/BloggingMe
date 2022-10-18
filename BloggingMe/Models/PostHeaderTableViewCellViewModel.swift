//
//  PostHeaderTableViewCellViewModel.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 18.10.2022.
//

import Foundation

final class PostHeaderTableViewCellViewModel {
    let imageUrl: URL?
    var imageData: Data?
    
    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
    }
}
