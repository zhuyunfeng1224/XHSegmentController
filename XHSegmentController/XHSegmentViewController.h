//
//  XHSegmentViewController.h
//  ShouChouJin
//
//  Created by xihe on 15/9/23.
//  Copyright © 2015年 ouer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHSegmentControl.h"

@interface XHSegmentViewController : UIViewController

@property(nonatomic, strong, readonly) XHSegmentControl   *segmentControl;
@property(nonatomic, strong, readonly) UIScrollView       *scrollView;

//  segment properties
@property(nonatomic)            XHSegmentType   segmentType;
@property(nonatomic, strong)    UIImage         *segmentBackgroundImage;
@property(nonatomic, strong)    UIColor         *segmentBackgroundColor;
@property(nonatomic)            CGFloat         segmentLineWidth;      //  linewidth > 0，底部高亮线
@property(nonatomic, strong)    UIColor         *segmentHighlightColor;
@property(nonatomic, strong)    UIColor         *segmentBorderColor;
@property(nonatomic)            CGFloat         segmentBorderWidth;
@property(nonatomic, strong)    UIColor         *segmentTitleColor;
@property(nonatomic, strong)    UIFont          *segmentTitleFont;
@property(nonatomic, strong)    NSArray         *viewControllers;

@end
