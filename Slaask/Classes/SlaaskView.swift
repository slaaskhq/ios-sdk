//
//  SlaaskView.swift
//  Slaask
//
//  Created by Rémi Delhaye on 28/03/2019.
//  Copyright © 2019 Ask Technologies, Inc. All rights reserved.
//

import UIKit

internal protocol SLAASKViewDelegate {
    func closeButtonPressed()
    func webViewDidFinishLoad()
    func openLink(url: URL)
}

internal class SlaaskView: UIWebView {
    
    internal var slaaskDelegate : SLAASKViewDelegate?
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        setupWebView()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupWebView()
    }
    
    internal func setupWebView() {
        
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.scrollView.bounces = false
        self.delegate = self
    }
}

extension SlaaskView : UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        slaaskDelegate?.webViewDidFinishLoad()
    }
    
    internal func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        
        if request.url?.scheme == "slaask" {
            
            if request.url?.host == "closeButtonPressed" {
                
                slaaskDelegate?.closeButtonPressed()
                return false
            }
        }
        
        if navigationType == .linkClicked {
            
            if request.url != nil {
                
                slaaskDelegate?.openLink(url: request.url!)
            }
        }
        
        if navigationType == .other {
            
            return true
        }
        
        return false
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

