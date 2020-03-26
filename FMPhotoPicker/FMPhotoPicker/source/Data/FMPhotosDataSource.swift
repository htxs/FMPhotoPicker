//
//  FMPhotosDataSource.swift
//  FMPhotoPicker
//
//  Created by c-nguyen on 2018/02/01.
//  Copyright © 2018 Tribal Media House. All rights reserved.
//

import Foundation
import Photos

class FMPhotosDataSource {
    public private(set) var photoAssets: [FMPhotoAsset]
    public private(set) var selectedPhotoAssets: [FMPhotoAsset]
    
    init(photoAssets: [FMPhotoAsset], selectedPhotoAssets: [FMPhotoAsset]) {
        self.photoAssets = photoAssets
        self.selectedPhotoAssets = selectedPhotoAssets
    }
    
    public func setSeletedForPhoto(atIndex index: Int) {
        if let photo = photo(atIndex: index) {
            if selectedPhotoAssets.firstIndex(where: { $0.asset == photo.asset }) == nil {
                selectedPhotoAssets.append(photo)
            }
        }
    }
    
    public func unsetSeclectedForPhoto(atIndex index: Int) {
        if let photo = photo(atIndex: index) {
            if let indexInSelectedIndex = selectedPhotoAssets.firstIndex(where: { $0.asset == photo.asset }) {
                selectedPhotoAssets.remove(at: indexInSelectedIndex)
            }
        }
    }
    
    public func selectedIndexOfPhoto(atIndex index: Int) -> Int? {
        if let photo = photo(atIndex: index) {
            return selectedPhotoAssets.firstIndex(where: { $0.asset == photo.asset })
        } else {
            return nil
        }
    }
    
    public func numberOfSelectedPhoto() -> Int {
        return selectedPhotoAssets.count
    }
    
    public func mediaTypeForPhoto(atIndex index: Int) -> FMMediaType? {
        return photo(atIndex: index)?.mediaType
    }
    
    public func countSelectedPhoto(byType: FMMediaType) -> Int {
        return selectedPhotoAssets.filter { $0.mediaType == byType }.count
    }
    
    public var numberOfPhotos: Int {
        return self.photoAssets.count
    }
    
    public func photo(atIndex index: Int) -> FMPhotoAsset? {
        guard index < self.photoAssets.count, index >= 0 else { return nil }
        return self.photoAssets[index]
    }
    
    public func index(ofPhoto photo: FMPhotoAsset) -> Int? {
        return self.photoAssets.firstIndex(where: { $0 === photo })
    }
    
    public func contains(photo: FMPhotoAsset) -> Bool {
        return self.index(ofPhoto: photo) != nil
    }
    
    public func delete(photo: FMPhotoAsset) {
        if let index = self.index(ofPhoto: photo) {
            self.photoAssets.remove(at: index)
        }
    }
    
}
