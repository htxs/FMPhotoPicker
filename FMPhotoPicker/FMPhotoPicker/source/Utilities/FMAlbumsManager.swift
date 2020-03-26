//
//  FMAlbumsManager.swift
//  FMPhotoPicker
//
//  Created by Jie Tian on 2020/3/26.
//  Copyright © 2020 Tribal Media House. All rights reserved.
//

import Foundation
import UIKit
import Photos

struct FMAlbum {
    var thumbnail: UIImage?
    var title: String = ""
    var numberOfItems: Int = 0
    var collection: PHAssetCollection?
}

class FMAlbumsManager {
    
    private var cachedAlbums: [FMAlbum]?
    let config: FMPhotoPickerConfig
    
    public init(config: FMPhotoPickerConfig) {
        self.config = config
    }
    
    func fetchAlbums() -> [FMAlbum] {
        if let cachedAlbums = cachedAlbums {
            return cachedAlbums
        }
        
        var albums = [FMAlbum]()
        let options = PHFetchOptions()
        
        let smartAlbumsResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                        subtype: .albumRegular,
                                                                        options: options)
        let albumsResult = PHAssetCollection.fetchAssetCollections(with: .album,
                                                                   subtype: .albumRegular,
                                                                   options: options)
        for result in [smartAlbumsResult, albumsResult] {
            result.enumerateObjects({ assetCollection, _, _ in
                var album = FMAlbum()
                album.title = assetCollection.localizedTitle ?? ""
                album.numberOfItems = self.mediaCountFor(collection: assetCollection)
                if album.numberOfItems > 0 {
                    let r = PHAsset.fetchKeyAssets(in: assetCollection, options: nil)
                    if let first = r?.firstObject {
                        let deviceScale = UIScreen.main.scale
                        let targetSize = CGSize(width: 78*deviceScale, height: 78*deviceScale)
                        let options = PHImageRequestOptions()
                        options.isSynchronous = true
                        options.deliveryMode = .opportunistic
                        PHImageManager.default().requestImage(for: first,
                                                              targetSize: targetSize,
                                                              contentMode: .aspectFill,
                                                              options: options,
                                                              resultHandler: { image, _ in
                                                                album.thumbnail = image
                        })
                    }
                    album.collection = assetCollection
                    
                    if self.config.mediaTypes.count == 1 && self.config.mediaTypes[0] == .image {
                        if !(assetCollection.assetCollectionSubtype == .smartAlbumSlomoVideos
                            || assetCollection.assetCollectionSubtype == .smartAlbumVideos) {
                            albums.append(album)
                        }
                    } else {
                        albums.append(album)
                    }
                }
            })
        }
        cachedAlbums = albums
        return albums
    }
    
    func mediaCountFor(collection: PHAssetCollection) -> Int {
        let options = PHFetchOptions()
        options.predicate = config.predicate()
        let result = PHAsset.fetchAssets(in: collection, options: options)
        return result.count
    }
    
}

extension FMPhotoPickerConfig {
    func predicate() -> NSPredicate {
        var hasImage = false
        var hasVideo = false
        for mediaType in mediaTypes {
            switch mediaType {
            case .image:
                hasImage = true
            case .video:
                hasVideo = true
            default:
                break
            }
        }
        if hasImage && hasVideo {
            return NSPredicate(format: "mediaType = %d || mediaType = %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
        } else if hasVideo {
            return NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
        } else {
            return NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        }
    }
}
