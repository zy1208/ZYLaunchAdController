//
//  ViewController.swift
//  ZYLaunchAdController
//
//  Created by Palmpay on 2018/5/23.
//  Copyright © 2018年 palm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = UIButton.init(type: UIButtonType.custom)
        btn.frame = CGRect(x: 100, y:200, width: 200, height: 100)
        btn.addTarget(self, action: #selector(btnDidClick), for: UIControlEvents.touchUpInside)
        btn.backgroundColor = UIColor.blue
        btn.setTitle("wowoo", for: UIControlState.normal)
        self.view.addSubview(btn)
    }
    
    @objc func btnDidClick(button: UIButton) -> Void {
        self.test()
    }
    
    func test() -> Void {
        let image: UIImage = UIImage.init(named: "cm2_loading_logo_ver")!
        let adVC = ZYLaunchAdController().configInfo(launchImage: nil, adImageHandle: {(imageView: UIImageView) -> () in
            imageView.image = UIImage.init(named: "cm2_reward_gift")
        }, finishHandle: { (typeHandle:ZYLaunchAdCallBackHandle) -> () in
            switch typeHandle {
            case .ZYLaunchAdCallBackClickSkip :
                print("点击了跳过按钮")
            case .ZYLaunchAdCallBackClickAd :
                print("点击进入广告")
            case .ZYLaunchAdCallBackShowFinish :
                print("播放完成")
            }
        })
        adVC.countTime = 8
        self.present(adVC, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

