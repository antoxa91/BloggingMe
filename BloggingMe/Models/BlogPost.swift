//
//  BlogPost.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 06.10.2022.
//

import Foundation

struct BlogPost: Comparable {
    let identifier: String
    let title: String
    let timestamp: TimeInterval
    let headerImageUrl: URL?
    let text: String
    
    static func < (lhs: BlogPost, rhs: BlogPost) -> Bool {
        return lhs.timestamp < rhs.timestamp
    }
}
