//
//  ViewController.m
//  YHAttributeString
//
//  Created by yh on 2018/1/19.
//  Copyright © 2018年 yh. All rights reserved.
//

#import "ViewController.h"
#import "NSMutableAttributedString+YH.h"
@interface ViewController ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.label];
    
 
    NSMutableAttributedString *attS = [NSMutableAttributedString AttributedStringWithString:@"Hello world!"];
    attS.whole.color([UIColor redColor]).font([UIFont boldSystemFontOfSize:14]).underLine(NSUnderlineStyleThick, [UIColor blueColor]).Strikethrough(NSUnderlineStyleSingle, [UIColor greenColor]);
    attS.range(1, 2).color([UIColor greenColor]).font([UIFont systemFontOfSize:38]);
    attS.joinWithSizeAtIndex([UIImage imageNamed:@"icon3"], 0, CGSizeMake(30, 30), 0);
   
    self.label.attributedText = attS;
    
}


- (UILabel *)label
{
    if(!_label) {
        _label = [[UILabel alloc] init];
        _label.backgroundColor = [UIColor lightGrayColor];
        _label.frame = CGRectMake(100, 100, 300, 300);
        _label.numberOfLines = 0;
    }
    return _label;
}

@end
