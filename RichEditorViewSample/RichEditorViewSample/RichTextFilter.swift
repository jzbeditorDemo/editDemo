//
//  RichTextFilter.swift
//  RichEditorViewSample
//  富文本标签过滤器，
//  Created by zhuzhanping on 2017/11/20.
//  Copyright © 2017年 Caesar Wirth. All rights reserved.
//

import UIKit

struct RichTextFilter{
    
    var html:String = ""//修正后的字符串
    
    //客户端展示时标签过滤
    mutating func displayFilter(html:String) -> String {
        self.html = html
        
        //p
        //1.清洗br样式
        self.html = self.pregReplace(pattern: TextQuoteFilter.newLine.pattens, with: TextQuoteFilter.newLine.replacedString)
        //2.给p标签增加样式
        self.html = self.pregReplace(pattern: TextQuoteFilter.diplay.pattens, with: TextQuoteFilter.diplay.replacedString)
        //3.clean span
        self.html = self.pregReplace(pattern: TextQuoteFilter.clearSpanStart.pattens, with: TextQuoteFilter.clearSpanStart.replacedString)
        self.html = self.pregReplace(pattern: TextQuoteFilter.clearSpanEnd.pattens, with: TextQuoteFilter.clearSpanEnd.replacedString)
        
        //blockquote
        //1.替换blockquote样式
        self.html = self.pregReplace(pattern: BlockquoteFilter.diplay.pattens, with: BlockquoteFilter.diplay.replacedString)
        //2.相邻的blockquote插入p标签增加间距
        self.html = self.pregReplace(pattern: BlockquoteFilter.newLine.pattens, with: BlockquoteFilter.newLine.replacedString)
        
        //list
        //1.清洗项目列表
        self.html = self.pregReplace(pattern: ListFilter.diplay.pattens, with: ListFilter.diplay.replacedString)
        return self.html
    }
    
    func pregReplace(pattern: String, with: String,
                     options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self.html, options: [],
                                              range: NSMakeRange(0, (self.html as NSString).length),
                                              withTemplate: with)
    }
}

private struct FilterPattens {
    var pattens:String
    var replacedString:String
}

//文本样式
private struct TextQuoteFilter {
    //显示样式
    static let diplay = FilterPattens(pattens: "<p[^>]*>",
                                      replacedString: "<p style='margin: 3px 0px 3px 0px;'>")
    //换行
    static let newLine = FilterPattens(pattens: "<p><br></p>", replacedString: "<br>")
    
    //clear span
    static let clearSpanStart = FilterPattens(pattens: "<span[^>]*>", replacedString: "")
    
    //clear span end
    static let clearSpanEnd = FilterPattens(pattens: "</span>", replacedString: "")
}

//引用样式
private struct BlockquoteFilter {
    //显示样式
    static let diplay = FilterPattens(pattens: "<blockquote[^>]*>",
                                       replacedString: "<blockquote style=\"background: rgb(247,247,247);padding: 20px 10px;margin: 0px 10px 10px 0px;border-left: 6px solid rgb(180,180,180);\">")
    //输入样式
    static let input = FilterPattens(pattens: "<blockquote[^/]*>", replacedString: "<blockquote>")
    //换行
    static let newLine = FilterPattens(pattens: "</blockquote><blockquote", replacedString: "</blockquote><p style=\"line-height:-12px;\"/><blockquote")
}

//列表样式
private struct ListFilter {
    //显示样式
    static let diplay = FilterPattens(pattens: "<p[^>]*><ul>",
                                      replacedString: "<p style=\'margin: -15px 0px 0px 0px;\'><ul>")
}
