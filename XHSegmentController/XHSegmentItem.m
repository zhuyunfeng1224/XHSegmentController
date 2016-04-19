//
//  XHSegmentItem.m
//  ShouChouJin
//
//  Created by xihe on 15/9/17.
//  Copyright (c) 2015年 xihe. All rights reserved.
//

#import "XHSegmentItem.h"

@interface XHSegmentItem ()

@property(nonatomic, strong) CALayer  *contentLayer;

@end

@implementation XHSegmentItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentLayer = [[CALayer alloc] init];
        self.contentLayer.backgroundColor = self.backgroundColor.CGColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if ([XHSegmentItem isStringEmpty:self.title]) {
        return;
    }
    UIColor *titleColor = self.selected? self.highlightColor: self.titleColor;
    CGFloat x = (CGRectGetWidth(rect) - [XHSegmentItem caculateTextWidth:self.title withFont:self.titleFont])/2;
    CGFloat y = (CGRectGetHeight(self.frame) - self.titleFont.pointSize)/2;
    [self.title drawAtPoint:CGPointMake(x, y) withAttributes:@{NSFontAttributeName: self.titleFont, NSForegroundColorAttributeName: titleColor}];
}

+ (CGFloat)caculateWidthWithtitle:(NSString *)title titleFont:(UIFont *)titleFont
{
    CGFloat width = Item_Padding * 2 + [XHSegmentItem caculateTextWidth:title withFont:titleFont];
    
    return width;
}

- (void)refresh
{
    [self setNeedsDisplay];
}

+ (BOOL)isStringEmpty:(NSString *)text
{
    if (!text || [text isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

+ (CGFloat)caculateTextWidth:(NSString *)text withFont:(UIFont *)font
{
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([XHSegmentItem isStringEmpty:text]) {
        return 0;
    }
    
    NSDictionary *attribute = @{NSFontAttributeName:font};
    
    CGRect newRect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, font.pointSize) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    
    text = nil;
    return newRect.size.width;
}

@end
