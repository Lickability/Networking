//
//  Photo.swift
//  Networker
//
//  Created by Twig on 5/10/19.
//  Copyright © 2019 Lickability. All rights reserved.
//

import Foundation

struct Photo: Codable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}
