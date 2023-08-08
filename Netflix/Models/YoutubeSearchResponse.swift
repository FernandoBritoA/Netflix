//
//  YoutubeSearchResponse.swift
//  Netflix
//
//  Created by Fernando Brito on 08/08/23.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: VideoID
}

struct VideoID: Codable {
    let kind: String
    let videoId: String?
    let channelId: String?
}
