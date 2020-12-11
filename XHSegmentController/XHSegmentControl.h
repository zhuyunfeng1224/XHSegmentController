//
//  XHSegmentControl.h
//
//  Created by xihe on 15-9-17.
//  Copyright (c) 2015年 xihe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHSegmentItem.h"

#define Default_Width           80
#define Default_Line_Width      2
#define Default_Color           [UIColor grayColor]
#define Default_Highlight_Color [UIColor redColor]
#define Default_Title_font      [UIFont systemFontOfSize:15]
#define Default_corner_enabled    FALSE
#define Default_inset           0


#define Key_Title           @"title"
#define Key_Title_Detail    @"titleDetail"
#define Key_Image           @"image"

#define Item_Spacing     10

typedef NS_ENUM(NSInteger, XHSegmentType)
{
    XHSegmentTypeFilled = 0,    //  充满屏幕高度
    XHSegmentTypeFit,           //  适应文字大小
    XHSegmentTypeCircle         //  循环
};

@protocol XHSegmentControlDelegate <NSObject>

- (void)xhSegmentSelectAtIndex:(NSInteger)index animation:(BOOL)animation;

@end

@interface XHSegmentControl : UIView

@property(nonatomic, weak)      id<XHSegmentControlDelegate>    delegate;

//  选中
@property(nonatomic)            NSInteger       selectIndex;
@property(nonatomic, strong)    NSArray         *titles;

@property(nonatomic)            XHSegmentType   segmentType;
@property(nonatomic, strong)    UIImage         *backgroundImage;
@property(nonatomic)            CGFloat         lineWidth;      //  linewidth > 0，底部高亮线
@property(nonatomic, strong)    UIColor         *highlightColor;
@property(nonatomic, strong)    UIColor         *borderColor;
@property(nonatomic)            CGFloat         borderWidth;
@property(nonatomic, strong)    UIColor         *titleColor;
@property(nonatomic, strong)    UIFont          *titleFont;
@property(nonatomic, assign)    BOOL            cornerEnabled;
@property(nonatomic, assign)    CGFloat         inset;

@property(nonatomic, strong, readonly)          UIScrollView        *scrollView;

- (void)load;
- (void)scrollToRate:(CGFloat)rate;

@end
