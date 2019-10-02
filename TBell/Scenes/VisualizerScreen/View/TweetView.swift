//
//  TweetView.swift
//  TBell
//
//  Created by Farhad on 2019-10-02.
//  Copyright © 2019 Farhad. All rights reserved.
//

import UIKit
import TwitterKit
import TwitterCore

class TweetView: UIView {
    
    //MARK: - Private Properties
    @IBOutlet weak var btnClose: UIButton!
    
    //MARK: - Actions
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        
        guard let superview = self.superview else {
            return
        }
        
        // dismiss the view
        UIView.transition(with: superview, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            
            self.isHidden = true
            
        }) { _ in
            
            self.removeFromSuperview()
        } // end completion
    } // end func
}

//MARK: - Public Methods
extension TweetView {
    
    /// Creates an instance of the view and shows it on the superview.
    class func show(onView superView : UIView, withTweetObject tweetObject : TWTRTweet) {
        
        // create view
        let view : TweetView = TweetView.loadFromNib()
        view.frame = superView.bounds
        
        // initially hide ourselve
        view.isHidden = true
        
        // create tweetview and add it as our subview
        let tweetView = TWTRTweetView(tweet: tweetObject, style: .regular)
        tweetView.showActionButtons = true
        view.addSubview(tweetView)
        
        // add constraints between tweetview and ourselve
        tweetView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tweetView.topAnchor.constraint(equalTo: view.btnClose.bottomAnchor),
            tweetView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tweetView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tweetView.heightAnchor.constraint(equalToConstant: tweetView.sizeThatFits(view.bounds.size).height)
        ])
        
        // add ourselve to superview
        superView.addSubview(view)
        view.layoutIfNeeded()
        
        // create tweetview and show it
        UIView.transition(with: superView, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            
            view.isHidden = false
        }, completion: nil)
        
    } // end func
}
