//
//  YHAttributeStringConfig.h
//  YHAttributeString
//
//  Created by yh on 2018/1/22.
//  Copyright © 2018年 yh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//样式设置
typedef NSMutableAttributedString*(^YHColorBlock)(UIColor *);
typedef NSMutableAttributedString*(^YHFontBlock)(UIFont *);
typedef NSMutableAttributedString*(^YHRangeBlock)(NSInteger loc, NSInteger length);
typedef NSMutableAttributedString*(^YHParagraphStyleBlock)(NSParagraphStyle *);

//匹配正则
typedef NSMutableAttributedString*(^YHMatchesBlock)(NSString *);

//下划线删除线样式
typedef NSMutableAttributedString*(^YHUnderLineBlock)(NSUnderlineStyle, UIColor *);
typedef NSMutableAttributedString*(^YHStrikethroughBlock)(NSUnderlineStyle, UIColor *);

//插入图片
typedef NSMutableAttributedString*(^YHJoinBlock)(UIImage *, CGFloat offsetY);
typedef NSMutableAttributedString*(^YHJoinIndexBlock)(UIImage *, CGFloat offsetY, NSInteger index);
typedef NSMutableAttributedString*(^YHJoinSizeBlock)(UIImage *, CGFloat offsetY, CGSize size);
typedef NSMutableAttributedString*(^YHJoinSizeIndexBlock)(UIImage *, CGFloat offsetY, CGSize size, NSInteger index);

typedef NSMutableAttributedString*(^YHReplaceBlock)(NSString *, id);

typedef NSMutableAttributedString*(^YHAppendBlock)(NSAttributedString *);
