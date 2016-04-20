//
//  WKFCircularSlidingView.h
//  scrollView的滑动
//
//  Created by fantasy on 15/11/6.
//  Copyright © 2015年 fantasy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickImageBlock)(int tag);


@interface WKFCircularSlidingView : UIView

- (instancetype)initWithFrame:(CGRect)frame ImagesArray:(NSArray *)imagesArray
                 andClickImageBlock:(ClickImageBlock)clickImageBlock
              withChangeAnImageTime:(CGFloat)time;



@end
