//
//  ViewController.swift
//  PictureSelector
//
//  Created by 313927462@qq.com on 02/22/2022.
//  Copyright (c) 2022 313927462@qq.com. All rights reserved.
//

import UIKit
import Photos
import SnapKit
import PictureSelector


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configUI()
    }
    
    
    
    func configUI() {
        let photoView  = PhotoPickerView()
        view.addSubview(photoView)
        photoView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.equalTo(400)
            make.top.equalTo(80)
            make.trailing.equalToSuperview()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

