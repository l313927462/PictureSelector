//
//  PhotoListController.swift
//  PictureSelector
//
//  Created by liugq on 2021/8/6.
//

import Photos
import PhotosUI
import UIKit
import SnapKit
import SVProgressHUD

private var lineCount: CGFloat = 4
private var lineSpace: CGFloat = 2
fileprivate let observerKey_icloudDownloading = "isIcloudLoading"
fileprivate let observerKey_addedPhoto = "selectedArray"



private var itemWidth: CGFloat = (CGFloat(UIScreen.main.bounds.size.width) - lineSpace * (lineCount - 1)) / lineCount

class PhotoListController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate ,PHPhotoLibraryChangeObserver, DatasourceChangeDelegate{
    
    convenience init(_ config: SelectorConfiguration) {
        self.init()
        self.photoManager.config = config
    }
    /// 获取媒体库视频、照片资源
    private let photoManager = PhotoManager()
    /// 上一次添加的数据，再添加时传入
    public var lastAddedArray = [PhotoModel]()
    /// 点击 完成 闭包
    public var completeBlock: ((_ photos: [PhotoModel]) -> Void)?
    
    fileprivate let manager = PHCachingImageManager()
    fileprivate var thumbnailSize = CGSize(width: itemWidth, height: itemWidth)
    fileprivate var previousPreheatRect = CGRect.zero
    
    lazy var collectView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = CGFloat(lineSpace)
        layout.minimumInteritemSpacing = CGFloat(lineSpace)
        let collectView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectView.backgroundColor = .groupTableViewBackground
        collectView.delegate = self
        collectView.dataSource = self
        collectView.showsVerticalScrollIndicator = true
        collectView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseID())
        return collectView
    }()
    
    
    var assetCollection: PHAssetCollection!
    var availableWidth: CGFloat = 0
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configHUD()
        configUI()
        registerPHPhotoLibrary()
        configPhotoManager()
        refreshTitleView()
    }
    func configPhotoManager(){
        resetCachedAssets()
        photoManager.delegate = self
        photoManager.selectedArray = lastAddedArray
        photoManager.fetchAllPhotos()
        photoManager.addObserver(self, forKeyPath: observerKey_addedPhoto, options: .new, context: nil)
        photoManager.addObserver(self, forKeyPath: observerKey_icloudDownloading, options: .new, context: nil)
    }
    
    func configHUD(){
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setForegroundColor(.gray)
        SVProgressHUD.setMinimumDismissTimeInterval(2)
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setBackgroundColor(.groupTableViewBackground)
    }
    
    func registerPHPhotoLibrary() {
        PHPhotoLibrary.shared().register(self)
        if #available(iOS 14, *) {
            PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self)
        }
    }
    
    
    deinit {
        photoManager.removeObserver(self, forKeyPath: observerKey_addedPhoto)
        photoManager.removeObserver(self, forKeyPath: observerKey_icloudDownloading)
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func configUI(){
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: Util.image("ps_back"), style: .plain, target: self, action: #selector(backAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(completeAction))
        view.addSubview(collectView)
        view.backgroundColor = .groupTableViewBackground
        collectView.snp.makeConstraints { make in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
        
    }
    
    
    fileprivate func resetCachedAssets() {
        manager.stopCachingImagesForAllAssets()
        previousPreheatRect = .zero
    }
    
    
    func refreshTitleView(){
        DispatchQueue.main.async { [self] in
            self.title = "已选择(" + String.init(self.photoManager.selectedArray.count) + ")"
        }
    }
    
    
    // MARK: -完成
    @objc func completeAction() {
        completeBlock!(self.photoManager.selectedArray)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func backAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: -KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //        print("change![.newKey]   ====== \(change![.newKey] )")
        
        
        switch keyPath {
        case observerKey_addedPhoto:
            refreshTitleView()
        case observerKey_icloudDownloading:
            DispatchQueue.main.async {
                if change![.newKey] as? Bool == true {
                    SVProgressHUD.show(withStatus: "iCloud loading... ")
                } else {
                    SVProgressHUD.dismiss()
                }
            }
            
        default : break
        }
    }
}
// MARK: -UICollectionViewDelegate & DatsSource
extension PhotoListController {
    
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return photoManager.dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseID(), for: indexPath) as? PhotoCell ?? PhotoCell()
        cell.backgroundColor = UIColor.groupTableViewBackground
        cell.model = photoManager.dataSource[indexPath.row]
        cell.downloadBlock = {  [weak self] model  in
            self?.photoManager.downloadFormIcloud(model)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.photoManager.downloadFormIcloud(photoManager.dataSource[indexPath.row])
    }
}


// MARK: -PHPhotoLibraryChangeObserver
extension  PhotoListController {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        print("did  changed -------------")
        DispatchQueue.main.async {
            self.photoManager.libraryChanged(changeInstance)
        }
    }
}

// MARK: -DatasourceChangeDelegate
extension PhotoListController {
    func reloadAll() {
        DispatchQueue.main.async {
            self.collectView.reloadData()
        }
    }
    
    
    func reload(_ rows: [IndexPath]) {
        DispatchQueue.main.async {
            self.collectView.reloadItems(at: rows)
        }
    }
    
}
