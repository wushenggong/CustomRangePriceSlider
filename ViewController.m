//
//  ViewController.m
//  CustomRangePriceSlider
//
//  Created by zhang on 2017/7/25.
//  Copyright © 2017年 CJ. All rights reserved.
//

#import "ViewController.h"
#import "CustomRangeSliderView.h"

@interface ViewController ()

@property (nonatomic, strong) CustomRangeSliderView *sliderView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.sliderView];
}

- (CustomRangeSliderView *)sliderView{
    if (!_sliderView) {
        _sliderView =[[CustomRangeSliderView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width , 200)];
        _sliderView.backgroundColor=[UIColor yellowColor];
        [_sliderView setCustomRangeSliderView_Block:^(NSString *minMoney,NSString *maxMoney){
            NSLog(@"min=%@  max=%@",minMoney,maxMoney);
        }];
    }
    return _sliderView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
