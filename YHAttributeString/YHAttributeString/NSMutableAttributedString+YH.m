//
//  NSMutableAttributedString+YH.m
//  YHAttributeString
//
//  Created by yh on 2018/1/22.
//  Copyright © 2018年 yh. All rights reserved.
//

#import "NSMutableAttributedString+YH.h"
#import <objc/runtime.h>
#import <CoreText/CoreText.h>

@interface NSString (matches)

@end

@implementation NSString (matches)

- (NSArray<NSValue *> *)matches:(NSString *)expStr {
    NSError *err = nil;
    NSRegularExpression *exp = [NSRegularExpression regularExpressionWithPattern:expStr options:NSRegularExpressionCaseInsensitive error:&err];
    NSAssert(err == nil, err.localizedDescription);
    NSMutableArray *ranges = [NSMutableArray array];
    [exp enumerateMatchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        [ranges addObject:[NSValue valueWithRange:result.range]];
    }];
    return ranges;
}


@end

@interface NSMutableAttributedString (range)

@property (nonatomic, strong) NSArray *rangeArray;

@end

@implementation NSMutableAttributedString (range)

- (void)setRangeArray:(NSArray *)rangeArray
{
    objc_setAssociatedObject(self, "range",rangeArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)rangeArray
{
    return objc_getAssociatedObject(self, "range");
}

@end

@implementation NSMutableAttributedString (YH)

+ (id)AttributedStringWithString:(NSString *)string
{
    return [[NSMutableAttributedString alloc] initWithString:string];
}

- (void)addAttribute:(NSAttributedStringKey)name value:(id)value
{    
    if (!value) return;
    
    if (!self.rangeArray) {
        self.rangeArray = @[[NSValue valueWithRange:NSMakeRange(0, self.string.length)]];
    }
    for (NSValue *rangeValue in self.rangeArray) {
        [self addAttribute:name value:value range:rangeValue.rangeValue];
    }
}

- (void)joinRichText:(UIImage *)image Offset:(CGFloat)offset
{
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = image;
    attach.bounds = CGRectMake(0, offset, image.size.width, image.size.height);
    NSAttributedString *atts = [NSAttributedString attributedStringWithAttachment:attach];
    [self appendAttributedString:atts];
}

- (void)joinRichText:(UIImage *)image Offset:(CGFloat)offset atIndext:(NSInteger)index
{
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = image;
    attach.bounds = CGRectMake(0, offset, image.size.width, image.size.height);
    NSAttributedString *atts = [NSAttributedString attributedStringWithAttachment:attach];
    [self insertAttributedString:atts atIndex:index];
}


- (void)joinRichText:(UIImage *)image Offset:(CGFloat)offset size:(CGSize)size
{
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = image;
    attach.bounds = CGRectMake(0, offset, size.width, size.height);
    NSAttributedString *atts = [NSAttributedString attributedStringWithAttachment:attach];
    [self appendAttributedString:atts];
}

- (void)joinRichText:(UIImage *)image Offset:(CGFloat)offset atIndext:(NSInteger)index size:(CGSize)size
{
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = image;
    attach.bounds = CGRectMake(0, offset, size.width, size.height);
    NSAttributedString *atts = [NSAttributedString attributedStringWithAttachment:attach];
    [self insertAttributedString:atts atIndex:index];
}

- (void)replaceString:(NSString *)str with:(id)obj
{
    NSArray *rangeArr = [self.string matches:str];
    
     if ([obj isKindOfClass:[NSString class]]) {
         for (NSValue *value in rangeArr) {
             if (value.rangeValue.length == 0) continue;
             [self replaceCharactersInRange:value.rangeValue withString:obj];
         }
     } else if ([obj isKindOfClass:[UIImage class]]) {
         for (NSInteger i = rangeArr.count -1; i >= 0; i--) { //图片从后往前替换 防止崩溃
             NSRange range;
             [rangeArr[i] getValue:&range];
             if (range.length == 0) continue;
             NSTextAttachment *attach = [[NSTextAttachment alloc] init];
             attach.image = obj;
             attach.bounds = CGRectMake(0, 0, attach.image.size.width, attach.image.size.height);
             NSAttributedString *atts = [NSAttributedString attributedStringWithAttachment:attach];
             [self replaceCharactersInRange:range withAttributedString:atts];
         }
     }
}

- (YHReplaceBlock)replace
{
    return ^(NSString *str, id obj) {
        
        [self replaceString:str with:obj];
        return self;
    };
}

- (YHJoinBlock)join
{
    return  ^(UIImage *obj, CGFloat offsetY){
        [self joinRichText:obj Offset:offsetY];
        return self;
    };
}

- (YHJoinIndexBlock)joinAtIndex
{
    return  ^(UIImage *obj, CGFloat offsetY, NSInteger index){
        [self joinRichText:obj Offset:offsetY atIndext:index];
        return self;
    };
}

- (YHJoinSizeBlock)joinWithSize
{
    return  ^(UIImage *obj, CGFloat offsetY, CGSize size){
        [self joinRichText:obj Offset:offsetY size:size];
        return self;
    };
}

- (YHJoinSizeIndexBlock)joinWithSizeAtIndex
{
    return  ^(UIImage *obj, CGFloat offsetY, CGSize size ,NSInteger index){
        [self joinRichText:obj Offset:offsetY atIndext:index size:size];
        return self;
    };
}

- (YHAppendBlock)append
{
    return ^(NSAttributedString *atts) {
        [self appendAttributedString:atts];
        return self;
    };
}

- (NSMutableAttributedString *)whole
{
    self.rangeArray = @[[NSValue valueWithRange:NSMakeRange(0, self.string.length)]];
    return self;
}

- (YHColorBlock)color
{
    return ^(UIColor *aColor){
        [self addAttribute:NSForegroundColorAttributeName value:aColor];
        return self;
    };
}

- (YHFontBlock)font
{
    return ^(UIFont *aFont){
        [self addAttribute:NSFontAttributeName value:aFont];
        return self;
    };
}

- (YHSpaceBlock)textSpace
{
    return  ^(NSInteger space) {
        // 调整字间距
        long number = space;
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
        [self addAttribute:(id)kCTKernAttributeName value:(__bridge id)num];
        return self;
    };
}

- (YHStrokeBlock)stroke
{
    return ^(NSInteger width) {
        [self addAttribute:NSStrokeWidthAttributeName value:@(width)];
        return self;
    };
}

- (YHShadowBlock)shadow
{
    return ^(NSShadow *shadow) {
        [self addAttribute:NSShadowAttributeName value:shadow];
        return self;
    };
}

- (YHParagraphStyleBlock)paragraphStyle
{
    return ^(NSParagraphStyle *style){
        [self addAttribute:NSParagraphStyleAttributeName value:style];
        return self;
    };
}

- (YHRangeBlock)range
{
    return ^(NSInteger loc, NSInteger length) {
        self.rangeArray = @[[NSValue valueWithRange:NSMakeRange(loc, length)]];
        return self;
    };
}

- (YHMatchesBlock)matches
{
    return ^(NSString *str){
        self.rangeArray = [self.string matches:str];
        return self;
    };
}


- (YHUnderLineBlock)underLine
{
    return ^(NSUnderlineStyle style, UIColor *color){
         [self addAttribute:NSUnderlineStyleAttributeName value:@(style)];
         [self addAttribute:NSUnderlineColorAttributeName value:color];
        return self;
    };
}

- (YHStrikethroughBlock)Strikethrough
{
    return ^(NSUnderlineStyle style, UIColor *color){
        [self addAttribute:NSStrikethroughStyleAttributeName value:@(style)];
        [self addAttribute:NSStrikethroughColorAttributeName value:color];
        return self;
    };
}

@end
