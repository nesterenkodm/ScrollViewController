//
//  ScrollViewController.swift
//  Megafon
//
//  Created by Dmitry Nesterenko on 12/08/15.
//  Copyright © 2015 E-Legion. All rights reserved.
//

import UIKit

/// Scroll View subclass to fix UIButtons touches behavior.
private class ScrollView : UIScrollView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delaysContentTouches = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delaysContentTouches = false
    }
    
    private override func touchesShouldCancelInContentView(view: UIView) -> Bool {
        if let _ = view as? UIControl {
            return true
        } else {
            return super.touchesShouldCancelInContentView(view)
        }
    }
    
}

public protocol ScrollableViewController : class {
    
    weak var scrollViewController: ScrollViewController? { get set }
    
}

/// View controller that manages content inside a scroll view.
public class ScrollViewController : UIViewController {
    
    public let scrollView: UIScrollView = ScrollView()
    private let scrollContentView = UIView()
    private var contentHeight: NSLayoutConstraint!
    
    // MARK: Content View Controller
    
    public var contentViewController: UIViewController? {
        willSet {
            if let viewController = self.contentViewController {
                viewController.willMoveToParentViewController(nil)
                viewController.view.removeFromSuperview()
                viewController.removeFromParentViewController()
                self.title = nil
                
                if let scrollableViewController = viewController as? ScrollableViewController {
                    scrollableViewController.scrollViewController = nil
                }
            }
        }
        didSet {
            if let viewController = self.contentViewController {
                if let scrollableViewController = viewController as? ScrollableViewController {
                    scrollableViewController.scrollViewController = self
                }
                if self.isViewLoaded() {
                    self.insertContentViewController(viewController)
                }
            }

        }
    }
    
    private func insertContentViewController(viewController: UIViewController) {
        self.addChildViewController(viewController)
        viewController.view.frame = self.scrollContentView.bounds
        viewController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.scrollContentView.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
        
        self.title = viewController.title
    }
    
    // MARK: Initialization
    
    public convenience init(contentViewController: UIViewController) {
        self.init(nibName: nil, bundle: nil)
        ({self.contentViewController = contentViewController}()) // wrapped in a closure to implicitly invoke willSet/didSet
    }
    
    // MARK: Navigation Interface
    
    /// Returns child view controllers navigation item if possible.
    public override var navigationItem: UINavigationItem {
        if let navigationItem = self.contentViewController?.navigationItem {
            return navigationItem
        }
        return super.navigationItem
    }
    
    // MARK: Managing the View
    
    public override func loadView() {
        let view = UIView(frame: UIScreen.mainScreen().bounds)
        self.view = view
        
        self.scrollView.frame = view.bounds
        self.scrollView.alwaysBounceVertical = true
        self.scrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.scrollView.layoutMargins = UIEdgeInsetsZero
        self.scrollView.keyboardDismissMode = .OnDrag
        view.addSubview(self.scrollView)
        
        self.scrollContentView.frame = view.bounds
        self.scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollContentView.layoutMargins = UIEdgeInsetsZero
        self.scrollView.addSubview(self.scrollContentView)
        
        // content view's edges are pinned to the superview's edges
        // content view's width must be equal to the superview's width
        // content view's height must be equal to the superview's height with a low priority
        let bindings = ["view": view, "scrollView": self.scrollView, "scrollContentView": self.scrollContentView]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[scrollContentView(==scrollView)]-|", options: [], metrics: nil, views: bindings))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[scrollContentView]-|", options: [], metrics: nil, views: bindings))
        self.contentHeight = NSLayoutConstraint(item: self.scrollContentView, attribute: .Height, relatedBy: .Equal, toItem: self.scrollView, attribute: .Height, multiplier: 1, constant: 0)
        self.contentHeight.priority = UILayoutPriorityDefaultLow
        view.addConstraint(self.contentHeight)
        
        if let viewController = self.contentViewController {
            self.insertContentViewController(viewController)
        }
    }
    
    // MARK: Responding to View Events
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.automaticallyAdjustsScrollViewInsets {
            let insets = self.topLayoutGuide.length + self.bottomLayoutGuide.length
            if self.contentHeight.constant != -insets {
                self.contentHeight.constant = -insets
            }
        }
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.scrollView.flashScrollIndicators()
    }
    
}