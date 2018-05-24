//
//  ZYLaunchAdController.swift
//  ZYLaunchAdController
//
//  Created by Palmpay on 2018/5/23.
//  Copyright © 2018年 palm. All rights reserved.
//

import UIKit

enum ZYLaunchAdCallBackHandle {
    case ZYLaunchAdCallBackClickSkip
    case ZYLaunchAdCallBackClickAd
    case ZYLaunchAdCallBackShowFinish
}

typealias ZYLaunchAdImageHandle = (UIImageView) -> ()

typealias ZYLaunchAdClickHandle = (ZYLaunchAdCallBackHandle) -> ()

class ZYLaunchAdController: UIViewController {
    
    var launchImageView: UIImageView = UIImageView()
    var adImageView: UIImageView = UIImageView()
    var adImageFrame: CGRect? = nil
    var adImageHandle: ZYLaunchAdImageHandle? = nil
    var clickHandle: ZYLaunchAdClickHandle? = nil
    var launchImagei: UIImage? = nil
    var timer: Timer? = nil
    var isBegin: Bool = false
    

    lazy var skipBtn: UIButton = {
        () -> UIButton in
        let skipBtn: UIButton = UIButton.init(type: UIButtonType.custom)
        skipBtn.backgroundColor = UIColor.orange
        skipBtn.addTarget(self, action: #selector(skipBtnDidClick), for: UIControlEvents.touchUpInside)
        return skipBtn
    }()
    
    var countTime: Int = 5 {
        willSet{
            print("super new \(newValue)")
        }
        didSet{
           skipBtn.setTitle("\(countTime)s跳过", for: UIControlState.normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //添加手势
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapAdImageView))
        tapGR.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGR)
        
        self.view.backgroundColor = UIColor.cyan
        //MARK: 添加控件
        self.commonInit()
        //开启定时器
        self.startTimer()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //MARK: 布局
        self.setLayout()
    }
    
    func configInfo(launchImage: UIImage?, adImageHandle: ((UIImageView) -> ()), finishHandle: @escaping ((ZYLaunchAdCallBackHandle) -> ())) -> ZYLaunchAdController {
        if launchImage != nil {
            launchImagei = launchImage
            launchImageView.image = launchImage
            adImageFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight*(2/3))
        } else {
            adImageFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        }
        adImageHandle(adImageView)
        clickHandle = finishHandle
        return self
    }
    
    func commonInit() -> Void {
        self.view.addSubview(launchImageView)
        self.view.addSubview(adImageView)
        self.view.addSubview(skipBtn)
        
        adImageView.backgroundColor = UIColor.cyan
    }
    
    func setLayout() -> Void {
        if launchImagei != nil {
            launchImageView.frame = CGRect(x: 0, y:0, width: kScreenWidth, height: kScreenHeight)
        }
        adImageView.frame = adImageFrame!
        //跳过按钮
        skipBtn.sizeToFit()
        let margin: CGFloat = 27
        let skipX = kScreenWidth - margin - skipBtn.bounds.width
        let skipFrame: CGRect = self.skipBtn.bounds
        let skipWidth: CGFloat =  skipFrame.size.width + CGFloat(16)
        let skipHeight: CGFloat = skipFrame.size.height + CGFloat(8)
        skipBtn.frame = CGRect(x: skipX, y: margin, width: skipWidth, height: skipHeight)
    }
    
    //MARK: 跳过按钮点击事件
    @objc func skipBtnDidClick(sender: UIButton) -> Void {
        if clickHandle != nil {
            clickHandle!(.ZYLaunchAdCallBackClickSkip)
        }
    }
    
    //MARK: 点击广告图片
    @objc func tapAdImageView() -> Void {
        if clickHandle != nil {
            clickHandle!(.ZYLaunchAdCallBackClickAd)
        }
    }
    
    //MARK: 添加定时器
    func startTimer() -> Void {
        timer = Timer.init(timeInterval: 1, target: self, selector: #selector(setSkipInfo), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
        timer?.fire()
    }
    
    @objc func setSkipInfo() -> Void {
        if !isBegin {
            isBegin = true
            return
        }
        if countTime > 0 {
            countTime = countTime-1
        } else {
            guard countTime == 0 else {
                return
            }
            if clickHandle != nil {
                clickHandle!(.ZYLaunchAdCallBackShowFinish)
            }
            self.removeTimer()
        }
    }
    
    //MARK: 移除定时器
    func removeTimer() -> Void {
        timer?.invalidate()
        timer = nil
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //移除定时器
        self.removeTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
