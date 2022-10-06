//
//  BlogPost.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 06.10.2022.
//

import Foundation

struct BlogPost {
    let identifier: String
    let title: String
    let timestamp: TimeInterval
    let headerImageUrl: URL?
    let text: String
}
