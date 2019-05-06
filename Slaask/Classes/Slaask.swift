//
//  Slaask.swift
//  Slaask
//
//  Created by Rémi Delhaye on 28/03/2019.
//  Copyright © 2019 Ask Technologies, Inc. All rights reserved.
//

import UIKit
import SafariServices

public final class Slaask: NSObject {
    
    // MARK: Public Var
    
    public static let sharedInstance : Slaask = {
        let instance = Slaask()
        return instance
    }()
    
    public var identity : Dictionary<String, String>?
    
    public var apiKey : String = ""
    
    public var containerViewColor =  UIColor.gray
    
    public var previousBarColor = UIApplication.shared.statusBarView?.backgroundColor
    public var currentStatusBarColorHex : String?
    
    internal override init() {
        self.identity = ["id": UIDevice.current.identifierForVendor!.uuidString, "name": "Unknown", "kind": "lead"]
    }
    
    public func prepare(apiKey: String, identity: Dictionary<String, String>? = nil) {
        self.apiKey = apiKey
        if (identity != nil) {
            self.identity = identity
        }
    }
    
    // MARK: Private Var
    
    private var slaaskView : SlaaskView?
    
    private var containerView : UIView?
    
    private var _chatData : NSData?
    
    // MARK: Public Methods
    
    public func show() {
        
        let url     = URL(string: "https://slaask.com/api/mobile_loader?key=\(self.apiKey)")!
        let session = URLSession(configuration: .default)
        let task    = session.dataTask(with: url) { data, response, error in
            
            guard let data = data else { return }
            self.currentStatusBarColorHex = String(data: data, encoding: .utf8)!
            
            DispatchQueue.main.async {
                UIApplication.shared.statusBarView?.backgroundColor = UIColor(hexString: self.currentStatusBarColorHex!)
                
                if self.slaaskView == nil || self.containerView == nil {
                    self.createSlaaskView()
                }
                
                self.view()?.addSubview(self.containerView!)
                self.containerView?.addSubview(self.slaaskView!)
                self.loadSlaaskView()
            }
            
        };
        
        task.resume()
    }
    
    public func dismiss() {
        
        containerView?.removeFromSuperview()
        slaaskView?.removeFromSuperview()
        slaaskView = nil
    }
    
    public func reload() {
        
        slaaskView?.reload()
        self.loadSlaaskView()
    }
    
    // MARK: Private Methods
    
    private func createSlaaskView() {
        
        self.containerView = UIView.init(frame: (CGRect(x: 0, y: 0, width: (self.view()?.bounds.size.width)!, height: (self.view()?.bounds.size.height)!)))
        self.containerView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.containerView?.backgroundColor = containerViewColor
        
        slaaskView = SlaaskView.init(frame: (CGRect(x: 0, y: 0, width: (self.view()?.bounds.size.width)!, height: (self.view()?.bounds.size.height)! - 0)))
        slaaskView?.setupWebView()
        slaaskView?.slaaskDelegate = self
    }
    
    private func loadSlaaskView() {
        var identifyString = ""
        
        if let identity = identity {
            
            identifyString = ",identify: function() {return {"
            
            var optionsString = ""
            
            for (key, value) in (identity) {
                optionsString = optionsString.appending("\(key): \"\(value)\",")
            }
            
            if optionsString.count > 2 {
                optionsString = String(optionsString[..<optionsString.index(optionsString.endIndex, offsetBy: -1)])
            }
            
            identifyString = identifyString.appending(optionsString)
            
            identifyString = identifyString.appending("}}")
        }
        
        slaaskView?.loadHTMLString("<!DOCTYPE html><html><head>" +
            "</head><style>.slaask-button { display: none !important; }</style>" +
            
            "<script>" +
            "document.addEventListener('slaask.ready', function()  {" +
            "window._slaask.show();" +
            "document.getElementById('ios-lds-dual-ring').remove()" +
            "}, false);" +
            
            "window._slaaskSettings = {key: '\(apiKey)', options: { native_sdk: true }" +
            "\(identifyString)" +
            "};" +
            "</script>" +
            "<script src=\"https://cdn.slaask.com/chat_loader.js\"></script><body><style>.lds-dual-ring {display: inline-block;width: 100%;height: 100%;}.lds-dual-ring:after {content: ' ';display: block;width: 100px;height: 100px;margin: calc(100% - 100px) auto auto auto;border-radius: 50%;border: 5px solid \(currentStatusBarColorHex!);border-color: \(currentStatusBarColorHex!) transparent \(currentStatusBarColorHex!) transparent;animation: lds-dual-ring 1.2s linear infinite;}@keyframes lds-dual-ring {0% {transform: rotate(0deg);}100% {transform: rotate(360deg);}}</style><div id=\"ios-lds-dual-ring\" class=\"lds-dual-ring\"></div></body></html>", baseURL: nil)
        
    }
    
    private func view() -> UIView? {
        
        return topViewController()?.view
    }
    
    internal func topViewController() -> UIViewController? {
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            return topController
        }
        
        return nil
    }
}

// MARK: SLAASKViewDelegate

extension Slaask : SLAASKViewDelegate {
    
    func webViewDidFinishLoad() {
        //        UIApplication.shared.statusBarView?.backgroundColor = currentStatusBarColor
    }
    
    
    internal func closeButtonPressed() {
        
        UIApplication.shared.statusBarView?.backgroundColor = previousBarColor
        
        dismiss()
    }
    
    internal func openLink(url: URL) {
        let svc = SFSafariViewController(url: url)
        self.topViewController()?.present(svc, animated: true, completion: nil)
    }
}

extension UIColor {
    convenience init(hexString: String, alpha:CGFloat? = 1.0) {
        var hexInt: UInt32 = 0
        let scanner = Scanner(string: hexString)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt32(&hexInt)
        
        let red = CGFloat((hexInt & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexInt & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexInt & 0xff) >> 0) / 255.0
        let alpha = alpha!
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

