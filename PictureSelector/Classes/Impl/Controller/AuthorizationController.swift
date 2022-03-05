//
//  AuthorizationController.swift
//  PictureSelector
//
//  Created by 刘国强 on 2022/3/5.
//

import UIKit
import SnapKit
private let appDisplayName: String = Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String ?? "" //App 名称
class AuthorizationController: UIViewController {

    
    
    let titleLabel = UILabel()
    let detailLabel = UILabel()
    let setButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .groupTableViewBackground
        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: Util.image("ps_back"), style: .plain, target: self, action: #selector(backAction))
        
        configUI()
    }
    
    
    func configUI(){
        self.view.addSubview(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.text = "无法访问相册中照片"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.top.equalTo(120)
        
        }
        
        self.view.addSubview(detailLabel)
        detailLabel.textAlignment = .center
        detailLabel.textColor = .gray
        detailLabel.numberOfLines = 0
        detailLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        detailLabel.text = "您已关闭”\(appDisplayName)“照片访问权限，建议允许访问[所有照片]"
        detailLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
        }
        
        
        
        self.view.addSubview(setButton)
        setButton.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        setButton.setTitle("前往系统设置", for: .normal)
        setButton.setTitleColor(.blue, for: .normal)
        setButton.addTarget(self, action: #selector(toSetting), for: .touchUpInside)
        setButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.bottom.equalTo(-100)
            make.centerX.equalToSuperview()
        }
    }
    

    
    @objc func toSetting(){
        let url = URL(string: UIApplication.openSettingsURLString)
        if UIApplication.shared.canOpenURL(url!){
            UIApplication.shared.open(url!)
        }
    }
    @objc func backAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
