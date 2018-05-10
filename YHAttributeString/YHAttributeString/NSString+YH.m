//
//  NSString+YH.m
//  YHAttributeString
//
//  Created by yh on 2018/5/9.
//  Copyright © 2018年 yh. All rights reserved.
//

#import "NSString+YH.h"

@implementation NSString (YH)

- (NSMutableAttributedString *)attributedString
{
    return [[NSMutableAttributedString alloc] initWithString:self];
}

@end
