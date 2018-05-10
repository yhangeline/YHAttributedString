//
//  NSMutableAttributedString+YH.h
//  YHAttributeString
//
//  Created by yh on 2018/1/22.
//  Copyright © 2018年 yh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YHAttributeStringConfig.h"
@interface NSMutableAttributedString (YH)

+ (id)AttributedStringWithString:(NSString *)string;

@property (nonatomic, strong, readonly) NSMutableAttributedString* whole;

//正则匹配
@property (nonatomic, copy, readonly) YHMatchesBlock matches;

@property (nonatomic, copy, readonly) YHColorBlock color;
@property (nonatomic, copy, readonly) YHFontBlock  font;
@property (nonatomic, copy, readonly) YHRangeBlock range;
@property (nonatomic, copy, readonly) YHSpaceBlock textSpace;//字间距
@property (nonatomic, copy, readonly) YHParagraphStyleBlock paragraphStyle;
@property (nonatomic, copy, readonly) YHUnderLineBlock underLine;
@property (nonatomic, copy, readonly) YHStrikethroughBlock Strikethrough; //删除线
@property (nonatomic, copy, readonly) YHStrokeBlock stroke;
@property (nonatomic, copy, readonly) YHShadowBlock shadow;

//插入图片
@property (nonatomic, copy, readonly) YHJoinBlock join;
@property (nonatomic, copy, readonly) YHJoinIndexBlock joinAtIndex;
@property (nonatomic, copy, readonly) YHJoinSizeBlock  joinWithSize;
@property (nonatomic, copy, readonly) YHJoinSizeIndexBlock joinWithSizeAtIndex;

@property (nonatomic, copy, readonly) YHAppendBlock append;

//正则匹配替换
@property (nonatomic, copy, readonly) YHReplaceBlock replace;

@end
