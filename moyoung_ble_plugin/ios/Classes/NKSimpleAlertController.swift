//
//  NKSimpleAlertController.swift
//  Nokia
//
//  Created by 魔样科技 on 2022/4/14.
//

import Foundation

struct NKSimpleAlertController {
    
    /// 简单封装一个alertController
    /// - Parameters:
    ///   - confirmBtn: confirmBtnTitle
    ///   - message: message
    ///   - title: title
    ///   - cancelBtn: cancelBtnTitle
    ///   - handler: confirmBtnAction
    ///   - viewController: presentFromViewController
    static func presentAlertVc(confirmBtn:String?, message:String, title:String, cancelBtn:String, handler:@escaping(UIAlertAction) ->Void, viewController:UIViewController) {
        let alertVc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelBtn, style: .cancel, handler:nil)
        alertVc.addAction(cancelAction)
        if confirmBtn != nil {
            let okAction = UIAlertAction(title: confirmBtn, style: .default, handler: { (action)in
                handler(action)
            })
            alertVc.addAction(okAction)
        }
        viewController.present(alertVc, animated:true, completion:nil)
    }
    
    static func getCurrentViewController(with rootViewController: UIViewController!)->UIViewController?{
        if nil == rootViewController{
            return nil
        }
        // UITabBarController就接着查找它当前显示的selectedViewController
        if rootViewController.isKind(of: UITabBarController.self){
            return self.getCurrentViewController(with: (rootViewController as! UITabBarController).selectedViewController)
            // UINavigationController就接着查找它当前显示的visibleViewController
        }else if rootViewController.isKind(of: UINavigationController.self){
            return self.getCurrentViewController(with: (rootViewController as! UINavigationController).visibleViewController)
            // 如果当前窗口有presentedViewController,就接着查找它的presentedViewController
        }else if nil != rootViewController.presentedViewController{
            return self.getCurrentViewController(with: rootViewController.presentedViewController)
        }
        // 否则就代表找到了当前显示的控制器
        return rootViewController
    }
    
    static func presentOnlyOKAlertVC (message: String) {
        NKSimpleAlertController.presentAlertVc(confirmBtn: nil, message: message, title: "", cancelBtn: "OK", handler: { result in
            
        }, viewController: NKSimpleAlertController.getCurrentViewController(with: UIApplication.shared.keyWindow?.rootViewController)!)
    }
    
}
