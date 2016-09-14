//
//  SpinnerView.swift
//  Todo
//
//  Created by Jesús Emilio Fernández de Frutos on 14/09/16.
//  Copyright © 2016 Jesús Emilio Fernández de Frutos. All rights reserved.
//

import UIKit

public class SpinnerView: UIView {
    
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    var loadingView: UIView = UIView()
    
    //
    // Access the singleton instance
    //
    public class var sharedInstance: SpinnerView {
        struct Singleton {
            static let instance = SpinnerView(frame: CGRect.zero)
        }
        return Singleton.instance
    }
    
    public func showActivityIndicator() {
        dispatch_async(dispatch_get_main_queue()) {
            self.loadingView = UIView()
            self.loadingView.frame = UIScreen.mainScreen().bounds//CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
            self.loadingView.backgroundColor =  UIColor.darkGrayColor()
            self.loadingView.alpha = 0.7
            self.loadingView.clipsToBounds = true
            self.loadingView.layer.cornerRadius = 10
            
            self.spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
            self.spinner.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
            self.spinner.center = CGPoint(x:self.loadingView.bounds.size.width / 2, y:self.loadingView.bounds.size.height / 2)
            self.loadingView.addSubview(self.spinner)
            UIApplication.sharedApplication().keyWindow?.addSubview(self.loadingView)
            
            //            self.view.addSubview(self.loadingView)
            //            self.view.bringSubviewToFront(self.loadingView)
            //            let window = UIWindow(frame: UIScreen.mainScreen().bounds)
            //            window.addSubview(self.loadingView)
            //
            //            window.bringSubviewToFront(self.loadingView)
            self.spinner.startAnimating()
        }
    }
    
    public func hideActivityIndicator() {
        dispatch_async(dispatch_get_main_queue()) {
            self.spinner.stopAnimating()
            self.loadingView.removeFromSuperview()
        }
    }

}
