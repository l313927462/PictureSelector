//
//  PhotoPickerService.swift
//  PictureSelector
//
//  Created by liugq on 2022/1/13.
//

import Foundation
import Photos
import UIKit

public enum SelectMediaType {
    case photo
    case video
    case all
}

public struct SelectorConfiguration {
    
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



public struct PhotoPickerService {
    
    public typealias ResultBlock = ([PhotoModel])->(Void)
    
    public static  func toSelect(_ config: SelectorConfiguration, _ addedArray:[PhotoModel] = [], result:@escaping ResultBlock) {
        accessAuthorization({ status in
            DispatchQueue.main.async {
                if status {
                    let controller = PhotoListController.init(config)
                    let navController = UINavigationController(rootViewController: controller)
                    navController.modalPresentationStyle = .fullScreen
                    controller.modalPresentationStyle = .fullScreen
                    controller.completeBlock = { photos in
                        result(photos)
                    }
                    if let vc = ControllerHelper.currentController(){
                        
                        controller.lastAddedArray = addedArray
                        vc.present(navController, animated: true, completion: nil)
                    } else {
                        print("current controller is nil ... ")
                    }
                } else {
                    
                    let controller = AuthorizationController()
                    let navController = UINavigationController(rootViewController: controller)
                    navController.modalPresentationStyle = .fullScreen
                    
                    if let vc = ControllerHelper.currentController(){
                        vc.present(navController, animated: true, completion: nil)
                    } else {
                        print("current controller is nil ... ")
                    }
                }
            }
        })
    }
    
    
    
    
    static func accessAuthorization(_ status:@escaping (Bool)->Void) {
        if #available(iOS 14, *) {
            let requiredAccessLevel: PHAccessLevel = .readWrite
            PHPhotoLibrary.requestAuthorization(for: requiredAccessLevel) { (authorizationStatus) in
                switch authorizationStatus{
                case .limited,.authorized:
                    status(true)
                default:
                    status(false)
                }
            }
        } else {
            // Fallback on earlier versions
            let photoStatus = PHPhotoLibrary.authorizationStatus()
            if photoStatus == .authorized {
                status(true)
            } else {
                status(false)
            }
            
        }
    }
}
