//
//  PreviewController.swift
//  PictureSelector
//
//  Created by liugq on 2021/8/7.
//

import UIKit

class PreviewController: UIViewController {
    public var index: NSInteger = 0
    public var dataSource = [PhotoModel]()
    private let imageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: ""), style: .plain, target: self, action: #selector(selectAcion))
        // Do any additional setup after loading the view.
    }

    @objc func selectAcion() {}
}
