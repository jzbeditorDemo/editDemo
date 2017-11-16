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
            imageView.contentView = attributedTextContentView
            return imageView
        } else if attachment is BlockquoteAttachment {
            print("--------")
            let v = UIView(frame: frame)
            v.frame.size.width = 300
            v.frame.size.height = 160
            v.backgroundColor = UIColor.red
            return v
        }
        
        return nil;
    }

}
