//
//  ShowListViewController.swift
//  RichEditorViewSample
//
//  Created by zhuzhanping on 2017/11/15.
//  Copyright © 2017年 Caesar Wirth. All rights reserved.
//

import UIKit
import DTCoreText

class ShowListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,DTAttributedTextContentViewDelegate,DTLazyImageViewDelegate {
    
    var contentHTMl:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let table = UITableView(frame: self.view.bounds)
        table.delegate = self
        table.dataSource = self
        self.view.addSubview(table)
        
        self.title = "native 排版"
        
//        DTTextAttachment.registerClass(BlockquoteAttachment.self, forTagName: "blockquote")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "displayCell") as? DTAttributedTextCell
        if cell == nil {
            cell = DTAttributedTextCell(style: .default, reuseIdentifier: "displayCell")
            cell?.attributedTextContextView.shouldDrawLinks = true
            cell?.attributedTextContextView.shouldDrawImages = true
            cell?.attributedTextContextView.delegate = self
            cell?.attributedTextContextView.backgroundColor = UIColor.white
        }
        cell?.setHTMLString(contentHTMl ?? "", options: [DTDefaultFontSize:17])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = DTAttributedTextCell(style: .default, reuseIdentifier: "displayCell")
        cell.setHTMLString(contentHTMl ?? "", options: [DTDefaultFontSize:17])
        let height =  cell.requiredRowHeight(in: tableView)
        print(height)
        return height
    }
    
    func attributedTextContentView(_ attributedTextContentView: DTAttributedTextContentView!, viewFor attachment: DTTextAttachment!, frame: CGRect) -> UIView! {
        if attachment is DTImageTextAttachment {//图片
            let imageView = DTLazyImageView(frame: frame)
            imageView.delegate = self
            imageView.image = (attachment as! DTImageTextAttachment).image
            imageView.url = attachment.contentURL
            imageView.isUserInteractionEnabled = true
            let btn = UIButton(type: .custom)
            btn.backgroundColor = UIColor.clear
            btn.frame = imageView.bounds
            btn.addTarget(self, action: #selector(imageViewTaped(button:)), for: .touchUpInside)
            imageView.addSubview(btn)
            return imageView
        }
        
        return nil;
    }
    
    func attributedTextContentView(_ attributedTextContentView: DTAttributedTextContentView!, viewFor string: NSAttributedString!, frame: CGRect) -> UIView! {
       
        let attributes = string.attributes(at: 0, effectiveRange: nil)
        let url = attributes[DTLinkAttribute] as? URL
        let identifier = attributes[DTGUIDAttribute] as? String
        if url != nil {
            let linkBtn = DTLinkButton(frame: frame)
            linkBtn.url = url!
            linkBtn.minimumHitSize = CGSize(width: 25, height: 25)
            linkBtn.guid = identifier ?? ""
            
            let normalImage = attributedTextContentView.contentImage(withBounds: frame, options: .default)
            linkBtn.setImage(normalImage, for: .normal)
            let hilightedImage = attributedTextContentView.contentImage(withBounds: frame, options: .drawLinksHighlighted)
            linkBtn.setImage(hilightedImage, for: .highlighted)
            linkBtn.addTarget(self, action: #selector(linkPushed(button:)), for: .touchUpInside)
            return linkBtn
        }
        return nil
    }

    func imageViewTaped(button:UIButton) {
        let view = button.superview as? DTLazyImageView
        print(view?.url.absoluteString ?? "")
    }
    
    func linkPushed(button:DTLinkButton) {
        print(button.url.absoluteString)
    }
}
