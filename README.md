# PictureSelector

[![CI Status](https://img.shields.io/travis/313927462@qq.com/PictureSelector.svg?style=flat)](https://travis-ci.org/313927462@qq.com/PictureSelector)
[![Version](https://img.shields.io/cocoapods/v/PictureSelector.svg?style=flat)](https://cocoapods.org/pods/PictureSelector)
[![License](https://img.shields.io/cocoapods/l/PictureSelector.svg?style=flat)](https://cocoapods.org/pods/PictureSelector)
[![Platform](https://img.shields.io/cocoapods/p/PictureSelector.svg?style=flat)](https://cocoapods.org/pods/PictureSelector)


## Function
- Support single selection, multiple selection, video and picture mix selection
- You can limit the format, size, and duration of a video or photo
- Supports iCloud image and video selection
- Multiple languages will be supported
- Icon customization will be supported

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
```swift
import PictureSelector

PictureSelectorService.toSelect(config, []) { resultArray in
            
}
```

## Configration
You can customize the configuration according to your goals
```swift
public struct SelectorConfiguration {
    /// 
    public var selctType: SelectMediaType = .photo
    
    public var maxSelectCount: UInt = 4
    /// unit: MB
    public var singlePhotoMaxSize: CGFloat?
    /// unit: MB
    public var sigleVideoMaxSize: CGFloat?
    /// unit: Second
    public var singleVideoMaxDuration: Int?
    /// Which format is supported，such as  : [PNG, JPEG, MP4, ....]
    public var availableFormats = [String]()
    
    /// The number of columns per row in the  selector
    public var numberOfColumnsInSelector: UInt = 4
    
    public init() {
        
    }
}
```

## Requirements
Add a item for the Info.plist
```swift
<key>PHPhotoLibraryPreventAutomaticLimitedAccessAlert</key> <true/>
```

## Installation

PictureSelector is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PictureSelector'
```

## Author

313927462@qq.com

## License

PictureSelector is available under the MIT license. See the LICENSE file for more info.
