//
//  ViewController.swift
//  RichEditorViewSample
//
//  Created by Caesar Wirth on 4/5/15.
//  Copyright (c) 2015 Caesar Wirth. All rights reserved.
//

import UIKit
import RichEditorView
import TZImagePickerController

class ViewController: UIViewController {
    
    fileprivate var selectedPhotoArray = NSMutableArray()
    fileprivate var uploadedPhotoArray = NSMutableDictionary()
    
    fileprivate let webViewInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)

    @IBOutlet var editorView: RichEditorView!
    
    fileprivate var initTitle:String?
    fileprivate var initBody:String?

    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        toolbar.options = RichEditorCustomOption.custom
        return toolbar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = self.navigationItem.title ?? ""
        if title == "标题非空编辑器" {
            customTitle()
        } else if title == "正文非空编辑器" {
            customBody()
        } else if title == "标题和正文非空编辑器" {
            customTitle()
            customBody()
        }
        
        editorView.delegate = self
        editorView.inputAccessoryView = toolbar
        editorView.webView.scrollView.contentInset = webViewInset
        
        toolbar.delegate = self
        toolbar.editor = editorView
        editorView.placeholder = "说点什么吧..."
        
        let btn = UIBarButtonItem(title: "内容", style: .plain, target: self, action: #selector(showHTML))
        let btn2 = UIBarButtonItem(title: "显示", style: .plain, target: self, action: #selector(showtableList))
        
        self.navigationItem.rightBarButtonItems = [btn,btn2]
        
        if initTitle != nil {
            self.editorView.title = self.initTitle!
        }
        
        if initBody != nil {
            editorView.html = initBody!
        }
    }
    
    @objc func showHTML() {
        print("😝😝\(editorView.html)")
    }
    
    @objc func showtableList() {
        let tableVC = ShowListViewController()
        tableVC.contentHTMl = editorView.html
        self.navigationController?.pushViewController(tableVC, animated: true)
    }
    
    private func customTitle() {
        self.initTitle = "标题非空标题非空标题非空标题非空标题非空标题非空标题非空标题非空标题非空"
    }
    
    private func customBody() {
        self.initBody = "内容测试，爱过你公司房间看电视了蛋糕发生房间里上的f第三方<b>发生发多少 发多少是</b><span style=\"font-size: 14pt;\">‌</span><blockquote style=\"background: rgb(247,247,247);padding: 15px 10px;margin: 10px 10px 10px 0px;border-left: 6px solid rgb(180,180,180);\">发生发多少分化解拉夫废旧塑料发废旧塑料发是记录附件了首付暗精灵说服力放假了是否放假了是</blockquote><ul><li>哈哈哈哈哈</li><li>哥哥哥哥哥哥</li><li>哈哈哈哈哈哈哈哈哈</li></ul><a href=\"http://www.baidu.com\">超链接测试</a><h3>哈发生的纠纷老师的就看电视了房间快乐发生的发&nbsp;</h3><p><img src='http://pic42.nipic.com/20140617/7003505_213800766156_2.jpg' width=\"360\" height=\"340\"><br></p><p>飞机上了发飞机上了飞机了飞机上了发了</p><p>房间里上</p><p><br></p><p>飞机开始了</p><br></p><p>就是发生了飞机上了发发生 end</p><p>end。。。。。</p></p><br>"
    }
    
    func after(_ time:Float,block:@escaping () -> Void) {
        let dtime = DispatchTime.now() + Double(Int64(Double(time) * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dtime) { () -> Void in
            block()
        }
    }
}

extension ViewController: RichEditorDelegate {
    
    func richEditor(_ editor: RichEditorView, handle action: String) {
        if action.hasPrefix("reUploadImage_") {
            let range = action.range(of: "reUploadImage_")!
            let id = action.replacingCharacters(in: range, with: "")
            let filePath = NSHomeDirectory() + "/Documents/" + id + ".jpg"
            self.uploadImage(filePath: filePath, imageId: id)
        }
    }
}

extension ViewController: RichEditorToolbarDelegate {

    fileprivate func randomColor() -> UIColor {
        let colors: [UIColor] = [
            .red,
            .orange,
            .yellow,
            .green,
            .blue,
            .purple
        ]
        
        let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        return color
    }

    func richEditorToolbarChangeTextColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextColor(color)
    }

    func richEditorToolbarChangeBackgroundColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextBackgroundColor(color)
    }

    func richEditorToolbarInsertImage(_ toolbar: RichEditorToolbar) {
        let imageVC = TZImagePickerController(maxImagesCount: 9, delegate: nil)
        imageVC?.allowPickingVideo = false
        imageVC?.sortAscendingByModificationDate = false 
        imageVC?.didFinishPickingPhotosHandle = {[weak self] (photos ,assets ,isSelectOriginalPhoto) in
            self?.insertImages(imgArr: photos, toolBar: toolbar)
        }
        imageVC?.imagePickerControllerDidCancelHandle = {[weak self] in
            self?.editorView.focus()
        }
        self.present(imageVC!, animated: true, completion: nil)
    }

    func richEditorToolbarInsertLink(_ toolbar: RichEditorToolbar) {
        insertLinkDialog(toolbar.editor?.selectedLinkTitle?.removingPercentEncoding, url: toolbar.editor?.selectedHref?.removingPercentEncoding)
    }
    
    //插入超链接弹框
    private func insertLinkDialog(_ title:String?,url:String?) {
        
        var alertTitle = "插入超链接"
        if title != nil {
            alertTitle = "更新超链接"
        }
        
        let alertVC = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        alertVC.addTextField { (textField) in
            textField.placeholder = "URL（必输）"
            if url != nil {
                textField.text = url!
            }
            textField.clearButtonMode = .whileEditing
        }
        
        alertVC.addTextField { (textField) in
            textField.placeholder = "超链接标题"
            if title != nil {
                textField.text = title!
            }
            textField.clearButtonMode = .whileEditing
        }
        
        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: {[weak self] (action) in
            self?.editorView.selectedLinkTitle = nil
            self?.editorView.selectedHref = nil
            self?.toolbar.editor?.focus()
        }))
        
        alertVC.addAction(UIAlertAction(title: "确定", style: .default, handler: {[weak self] (action) in
            let linkURL = alertVC.textFields?[0].text ?? ""
            let linkTitle = alertVC.textFields?[1].text ?? ""
            
            if linkURL == "" {
                self?.toolbar.editor?.focus()
                return
            }
            
            if self?.editorView.selectedHref != nil {
                self?.toolbar.editor?.updateLink(linkURL, title: (linkTitle == "" ? linkURL : linkTitle))
            } else {
                self?.toolbar.editor?.insertLink(linkURL, title: (linkTitle == "" ? linkURL : linkTitle))
            }
            self?.toolbar.editor?.focus()
        }))
        
        self.present(alertVC, animated: true) {
            
        }
    }
}

extension ViewController {
    
    func getRandomFileName() -> String {
        let fileName = "\(UUID().uuidString).jpg"
        let documentPath = NSHomeDirectory() + "/Documents"
        let filePath = documentPath + "/" + fileName
        return filePath
    }
    
    //插入图片
    func insertImages(imgArr:[UIImage]?,toolBar:RichEditorToolbar) {
        for image in (imgArr ?? []) {
            let data = UIImagePNGRepresentation(image)
            if data != nil {
                let filePath = getRandomFileName()
                let imgId = (filePath as NSString).lastPathComponent.replacingOccurrences(of: ".jpg", with: "")
                do {
                    try data?.write(to: URL(fileURLWithPath: filePath))
                    self.selectedPhotoArray.add(filePath)
                    toolbar.editor?.insertImage(filePath, alt: "", imageId: imgId)
                    self.uploadImage(filePath: filePath, imageId: imgId)
                } catch {}
            }
        }
    }
    
    func uploadImage(filePath:String,imageId:String) {
        var progress:Double = 0
        if #available(iOS 10.0, *) {
            let timer = Timer(timeInterval: 0.1, repeats: true, block: { (timer) in
                progress += 0.01
                print(progress)
//                if progress >= 0.5 {
//                    self.editorView.imageUploadFailed(imageId: imageId)
//                    timer.invalidate()
//                }
                if progress >= 1 {
                    self.editorView.imageUploadSuccess(imageId: imageId)
                    timer.invalidate()
                } else {
                    self.editorView.updateImageProgress(imageId: imageId, progress: progress)
                }
            })
            RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
            timer.fire()
        }
    }
}

extension ViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowOrHide(aNotification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowOrHide(aNotification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShowOrHide(aNotification:Notification) {
        let userInfo = aNotification.userInfo
//        let duration = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber ?? 0
        let keyboardEnd = userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue
        let sizeOfToolbar = toolbar.frame.size.height
        let keyboardHeight = keyboardEnd?.cgRectValue.size.height ?? 0
        if aNotification.name == NSNotification.Name.UIKeyboardWillShow {
//            UIView.animate(withDuration: duration.doubleValue, delay: 0, options: .curveEaseInOut, animations: {
                self.editorView.frame.size.height = self.view.frame.size.height - keyboardHeight - sizeOfToolbar - 25
                self.editorView.webView.frame.size.height = self.editorView.frame.size.height
                self.editorView.webView.scrollView.contentInset = self.webViewInset
                self.editorView.webView.scrollView.scrollIndicatorInsets = .zero
                self.editorView.runCustomJS(js: "RE.contentHeight=\(self.editorView.frame.size.height)")
//            }, completion: nil)
        } else if aNotification.name == NSNotification.Name.UIKeyboardWillHide {
//            UIView.animate(withDuration: duration.doubleValue, delay: 0, options: .curveEaseInOut, animations: {
//                self.toolbar.frame.origin.y = self.view.frame.size.height + keyboardHeight
//                self.editorView.frame.size.height = self.view.frame.size.height
//                self.editorView.webView.scrollView.contentInset = self.webViewInset
//                self.editorView.webView.scrollView.scrollIndicatorInsets = .zero
//                self.editorView.runCustomJS(js: "RE.contentHeight=\(self.editorView.frame.size.height)")
//            }, completion: nil)
        }
    }
}
