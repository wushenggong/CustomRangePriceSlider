//
//  CustomRangeSliderView.h
//  CustomRangePriceSlider
//
//  Created by zhang on 2017/7/25.
//  Copyright © 2017年 CJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CustomRangeSliderView_Block)(NSString *minMoney,NSString *maxMoney);


@interface CustomRangeSliderView : UIView


@property(nonatomic,copy)CustomRangeSliderView_Block customRangeSliderView_Block;

@end
