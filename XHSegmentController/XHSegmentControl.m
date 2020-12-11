//
//  XHSegmentControl.m
//
//  Created by xihe on 15-9-17.
//  Copyright (c) 2015年 xihe. All rights reserved.
//

#import "XHSegmentControl.h"

@interface XHSegmentControl()
<
    UIScrollViewDelegate
>

@property(nonatomic)            CGRect              lastSelectRect;
@property(nonatomic, strong)    NSArray             *items;
@property(nonatomic, strong)    UIScrollView        *scrollView;
@property(nonatomic, strong)    CALayer             *lineLayer;
@property(nonatomic)            CGFloat             beginOffsetX;

- (void)segmentItemClicked:(XHSegmentItem *)item;

@end

@implementation XHSegmentControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)awakeFromNib
{
    [self initialize];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
    CGContextSetLineWidth(context, self.borderWidth);
    CGContextMoveToPoint(context, 0, CGRectGetMaxY(rect) - self.borderWidth);
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect) - self.borderWidth);
    CGContextStrokePath(context);
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    self.scrollView.frame = CGRectMake(0, 0, size.width, size.height);
    
    //  contentSize
    XHSegmentItem *item = [self.items lastObject];
    self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(item.frame), CGRectGetHeight(self.scrollView.frame));
    
}

#pragma mark - Initialize Method

- (void)initialize
{
    // 初始化数据
    self.highlightColor = Default_Highlight_Color;
    self.titleColor = Default_Color;
    self.titleFont = Default_Title_font;
    self.lineWidth = Default_Line_Width;
    self.cornerEnabled = Default_corner_enabled;
    self.inset = Default_inset;
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.items = [[NSMutableArray alloc] init];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    self.scrollView.autoresizesSubviews = NO;
    self.scrollView.alwaysBounceHorizontal = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    [self addSubview:self.scrollView];
    
    //  初始化高亮线
    self.lineLayer = [[CALayer alloc] init];
    self.lineLayer.backgroundColor = self.highlightColor.CGColor;
    [self.scrollView.layer addSublayer:self.lineLayer];
}

- (void)createItems
{
    if (!self.titles || self.titles.count == 0) {
        return;
    }
    
    NSMutableArray *arrayItem = [[NSMutableArray alloc] initWithCapacity:self.titles.count];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat itemWidth = 0.;
    CGFloat itemHeight = CGRectGetHeight(self.frame);
    CGRect  itemRect = CGRectZero;
    for (int i = 0; i < self.titles.count; i++) {
        
        NSString *title = self.titles[i];
        
        if (self.segmentType == XHSegmentTypeFilled) {
            
            itemWidth = screenWidth/self.titles.count;
            itemRect = CGRectMake(i * itemWidth, 0, itemWidth, itemHeight);
        }
        else if (self.segmentType == XHSegmentTypeFit) {
            
            itemWidth = [XHSegmentItem caculateWidthWithtitle:title titleFont:self.titleFont];
            XHSegmentItem *lastItem = [arrayItem lastObject];
            itemRect = CGRectMake(CGRectGetMaxX(lastItem.frame), 0, itemWidth, itemHeight);
        }
        else {
            
        }
        
        XHSegmentItem *item = [self createItem:itemRect title:title];
        [arrayItem addObject:item];
    }
    
    self.items = [arrayItem mutableCopy];
}

- (XHSegmentItem *)createItem:(CGRect)rect title:title
{
    XHSegmentItem *item = [[XHSegmentItem alloc] initWithFrame:rect];
    item.title = title;
    item.titleColor = self.titleColor;
    item.titleFont = self.titleFont;
    item.highlightColor = self.highlightColor;
    [item addTarget:self action:@selector(segmentItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:item];
    return item;
}


#pragma mark - Public Method

- (void)load
{
    // 初始化scrollview
    if (self.backgroundImage) {
        self.backgroundColor = [UIColor colorWithPatternImage:self.backgroundImage];
    }
    
    //  load 高亮线
    self.lineLayer.backgroundColor = self.highlightColor.CGColor;
     self.lineLayer.frame = CGRectMake(CGRectGetMinX(self.lineLayer.frame) + self.inset, CGRectGetHeight(self.frame) - self.lineWidth, CGRectGetWidth(self.lineLayer.frame) - 2*self.inset, self.lineWidth);
    
    // 初始化scrollview
    if (self.backgroundImage) {
        self.backgroundColor = [UIColor colorWithPatternImage:self.backgroundImage];
    }
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    [self createItems];
    
    //  根据type初始化items
    self.selectIndex = 0;
    self.lineLayer.cornerRadius = self.cornerEnabled == true ? self.lineWidth/2.0f : 0.0f;
    [self layoutSubviews];
}

- (void)scrollToRate:(CGFloat)rate
{
    if (!self.items || self.items.count == 0) {
        return;
    }
    XHSegmentItem *currentItem = self.items[self.selectIndex];
    XHSegmentItem *previousItem = self.selectIndex > 0 ? self.items[self.selectIndex - 1]: nil;
    XHSegmentItem *nextItem = (self.selectIndex < self.items.count - 1)? self.items[self.selectIndex + 1]: nil;
    if (fabs(rate) > 0.5) {
        
        if (rate > 0) {
            
            if (nextItem) {
                [self segmentItemSelected:nextItem];
            }
        }
        else if (rate < 0) {
            
            if (previousItem) {
                [self segmentItemSelected:previousItem];
            }
        }
    }
    else
    {
        if (currentItem) {
            [self segmentItemSelected:currentItem];
        }
    }
    
    CGFloat dx = 0.;
    CGFloat dw = 0.;
    if (rate > 0) {
        
        if (nextItem) {
            
            dx = CGRectGetMinX(nextItem.frame) - CGRectGetMinX(currentItem.frame);
            dw = CGRectGetWidth(nextItem.frame) - CGRectGetWidth(currentItem.frame);
        }
        else {
            
            dx = CGRectGetWidth(currentItem.frame);
        }
    }
    else if (rate < 0) {
        
        if (previousItem) {
            
            dx = CGRectGetMinX(currentItem.frame) - CGRectGetMinX(previousItem.frame);
            dw = CGRectGetWidth(currentItem.frame) - CGRectGetWidth(previousItem.frame);
        }
        else {
            
            dx = CGRectGetWidth(currentItem.frame);
        }
    }
    
    CGFloat x = CGRectGetMinX(self.lastSelectRect) + rate * dx;
    CGFloat w = CGRectGetWidth(self.lastSelectRect) + rate * dw;
    self.lineLayer.frame = CGRectMake(x, CGRectGetMinY(self.lastSelectRect), w, CGRectGetHeight(self.lastSelectRect));
}


#pragma mark - Private Method

- (void)segmentItemClicked:(XHSegmentItem *)item
{
    [self setSelectIndex:[self.items indexOfObject:item] animation:NO];
}

- (void)segmentItemSelected:(XHSegmentItem *)item
{
    for (XHSegmentItem *i in self.items) {
        
        i.selected = NO;
        [item refresh];
    }
    item.selected = YES;
}

#pragma mark - Setters

- (void)setSelectIndex:(NSInteger)selectIndex animation:(BOOL)animation
{
    _selectIndex = selectIndex;
    if (selectIndex < self.items.count) {
        
        XHSegmentItem *item = self.items[selectIndex];
        [self segmentItemSelected:item];
        
        self.lineLayer.frame = CGRectMake(CGRectGetMinX(item.frame) + 12, CGRectGetHeight(item.frame) - self.lineWidth, CGRectGetWidth(item.frame) - 24, self.lineWidth);
        self.lastSelectRect = self.lineLayer.frame;
        
        [self.scrollView scrollRectToVisible:item.frame animated:YES];
        [self.delegate xhSegmentSelectAtIndex:selectIndex animation:animation];
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    [self setSelectIndex:selectIndex animation:YES];
}

- (void)setHighlightColor:(UIColor *)highlightColor
{
    _highlightColor = highlightColor;
    self.lineLayer.backgroundColor = highlightColor.CGColor;
}

@end
