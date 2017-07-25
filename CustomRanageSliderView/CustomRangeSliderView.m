//
//  CustomRangeSliderView.m
//  CustomRangePriceSlider
//
//  Created by zhang on 2017/7/25.
//  Copyright © 2017年 CJ. All rights reserved.
//

#import "CustomRangeSliderView.h"

#define marginleft 20
#define imagewidth 30
#define viewheight 200

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)      //屏幕宽度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)    //屏幕高度

@interface CustomRangeSliderView ()
{

    UIButton *_submitBtn;
    
    UIView *_lineView;
    UIView *_leftLine;
    UIView *_rightLine;
    
    UIImageView *_leftBtn;
    UIImageView *_rightBtn;
    
    NSArray *_moneyArr;
    NSArray *_selectedArr;
    NSMutableArray *_centexArr;
    
    NSString *_maxMoney;
    NSString *_minMoney;
    
    NSInteger _selectLeftIdx;
    NSInteger _selectRightIdx;
}
@end

@implementation CustomRangeSliderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initWithSubView];
    }
    return self;
}

- (void) initWithSubView{
    
    
    _moneyArr = @[@"0",@"500",@"1000",@"1500",@"2000",@"3000",@"不限"];
    _centexArr=[[NSMutableArray alloc] init];
    _selectLeftIdx=0;
    _selectRightIdx=_moneyArr.count-1;
    _maxMoney = @"不限";
    _minMoney = @"0";
    
    /**设置默认选中值***/
    _selectedArr=@[@"500",@"2000"];
    _selectLeftIdx=1;
    _selectRightIdx=4;
    _maxMoney = @"2000";
    _minMoney = @"500";
    
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(marginleft, 100, SCREEN_WIDTH-marginleft*2, 8)];
    _lineView.layer.masksToBounds=YES;
    _lineView.layer.cornerRadius=4;
    _lineView.backgroundColor  = [UIColor blueColor];
    [self addSubview:_lineView];
    
    
    CGFloat width = _lineView.frame.size.width / (_moneyArr.count -1);
    
    for (int i = 0; i <_moneyArr.count ; i ++) {

        UIView *line = [UIView new];
        line.frame = CGRectMake(i *width+marginleft, 50, 1, 15);
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 30 , 40, 20)];
        lable.text = _moneyArr[i];
        lable.textColor = [UIColor lightGrayColor];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont systemFontOfSize:12];
        lable.center=CGPointMake(line.center.x, line.frame.origin.y-15);
        [_centexArr addObject:@(line.center.x)];
        
        [self addSubview:lable];
    }
    
    
    _leftLine = [[UIView alloc] initWithFrame:CGRectMake(_lineView.frame.origin.x, _lineView.frame.origin.y, 0, 8)];
    _leftLine.layer.masksToBounds=YES;
    _leftLine.layer.cornerRadius=4;
    _leftLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_leftLine];
    
    _rightLine = [[UIView alloc] initWithFrame:CGRectMake(_lineView.frame.size.width + _lineView.frame.origin.x, _lineView.frame.origin.y, 0,8)];
    _rightLine.layer.masksToBounds=YES;
    _rightLine.layer.cornerRadius=4;
    _rightLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_rightLine];
    
    _leftBtn = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imagewidth, 40)];
    _leftBtn.userInteractionEnabled=YES;
    _leftBtn.image=[UIImage imageNamed:@"ss_zj_3"];
    _leftBtn.center = CGPointMake(_lineView.frame.origin.x, _lineView.center.y);
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftPanEvent:)];
    [_leftBtn addGestureRecognizer:pan];
    [self addSubview:_leftBtn];
    
    
    _rightBtn = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imagewidth, 40)];
    _rightBtn.userInteractionEnabled=YES;
    _rightBtn.image=[UIImage imageNamed:@"ss_zj_3"];
    _rightBtn.center = CGPointMake(_lineView.frame.size.width + _lineView.frame.origin.x,  _lineView.center.y);
    UIPanGestureRecognizer *pan2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightPanEvent:)];
    [_rightBtn addGestureRecognizer:pan2];
    [self addSubview:_rightBtn];
    
    
    _submitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _submitBtn.backgroundColor=[UIColor lightGrayColor];
    _submitBtn.frame=CGRectMake(30, _lineView.frame.origin.x+130, SCREEN_WIDTH-60, 30);
    [_submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_submitBtn];
    
    
    //如果要设置默认值，需确定_selectLeftIdx，_selectRightIdx即可
    _leftBtn.center = CGPointMake([_centexArr[_selectLeftIdx] floatValue], _leftBtn.center.y);
    _leftLine.frame = CGRectMake(_leftLine.frame.origin.x, _leftLine.frame.origin.y, [_centexArr[_selectLeftIdx] floatValue] -imagewidth/2 , _leftLine.frame.size.height);
    
    _rightBtn.center = CGPointMake([_centexArr[_selectRightIdx] floatValue], _rightBtn.center.y);
    _rightLine.frame = CGRectMake( [_centexArr[_selectRightIdx] floatValue] , _rightLine.frame.origin.y, _lineView.frame.size.width - [_centexArr[_selectRightIdx] floatValue] +marginleft , _rightLine.frame.size.height);
    
}


#pragma mark - 滑动事件
- (void)leftPanEvent:(UIPanGestureRecognizer *)gesture{
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint offset = [gesture translationInView:self];
        CGFloat y = gesture.view.center.y;
        CGFloat x = gesture.view.center.x +offset.x;
        if (x <_lineView.frame.origin.x) {
            x = _lineView.frame.origin.x;
        }
        
        if (x > _rightBtn.center.x - imagewidth) {
            x =  _rightBtn.center.x - imagewidth;
        }
        gesture.view.center = CGPointMake(x, y);
        [gesture setTranslation:CGPointMake(0, 0) inView:self];
        _leftLine.frame = CGRectMake(_leftLine.frame.origin.x, _leftLine.frame.origin.y, x-imagewidth/2 , _leftLine.frame.size.height);
        
    }else if(gesture.state == UIGestureRecognizerStateEnded){
        CGFloat width = _lineView.frame.size.width / (_moneyArr.count -1);
        
        CGPoint offset = [gesture translationInView:self];
        CGFloat y = gesture.view.center.y;
        CGFloat x = gesture.view.center.x +offset.x;
        NSLog(@"left x=%f",x);
        
        if (x <_lineView.frame.origin.x) {
            x = _lineView.frame.origin.x;
        }
        
        if (x > _rightBtn.center.x - width/2) {
            x = _rightBtn.center.x - width/2;
        }
        
        NSLog(@"arr centerx=%@",_centexArr);
        for (int i=0; i<_centexArr.count; i++) {
            float rcx=[_centexArr[i] floatValue];
            if (i==0) {
                float r_x=rcx-x;
                if (r_x>=0)
                {
                    x=rcx;
                    _selectLeftIdx=0;
                }
            }
            else {
                float lcx=[_centexArr[i-1] floatValue];
                
                float m_x=x-lcx;
                float r_x=rcx-x;
                if (m_x>=0&&r_x>=0) {
                    if (m_x<r_x) {
                        x=lcx;
                        _selectLeftIdx=i-1;
                    }
                    else
                    {
                        x=rcx;
                        _selectLeftIdx=i;
                    }
                }
            }
        }
        if (_selectLeftIdx==_selectRightIdx) {
            _selectLeftIdx=_selectRightIdx-1>=0?_selectRightIdx-1:0;
        }
        NSLog(@"end -left =%ld",_selectLeftIdx);
        gesture.view.center = CGPointMake([_centexArr[_selectLeftIdx] floatValue], y);
        [gesture setTranslation:CGPointMake(0, 0) inView:self];
        _leftLine.frame = CGRectMake(_leftLine.frame.origin.x, _leftLine.frame.origin.y, [_centexArr[_selectLeftIdx] floatValue] -imagewidth/2 , _leftLine.frame.size.height);
        _minMoney = [NSString stringWithFormat:@"%@",_moneyArr[_selectLeftIdx]];
        
        
    }
}
- (void)rightPanEvent:(UIPanGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint offset = [gesture translationInView:self];
        CGFloat y = gesture.view.center.y;
        CGFloat x = gesture.view.center.x +offset.x;
        if (x < _leftBtn.center.x + imagewidth) {
            x =  _leftBtn.center.x + imagewidth;
        }
        if (x > _lineView.frame.origin.x + _lineView.frame.size.width ) {
            x = _lineView.frame.origin.x + _lineView.frame.size.width;
        }
        gesture.view.center = CGPointMake(x, y);
        [gesture setTranslation:CGPointMake(0, 0) inView:self];
        
        _rightLine.frame = CGRectMake( x , _rightLine.frame.origin.y, _lineView.frame.size.width - x +marginleft , _rightLine.frame.size.height);
        
    }else if(gesture.state == UIGestureRecognizerStateEnded){
        
        CGFloat width = _lineView.frame.size.width / (_moneyArr.count -1);
        
        CGPoint offset = [gesture translationInView:self];
        
        CGFloat y = gesture.view.center.y;
        CGFloat x = gesture.view.center.x + offset.x;
        
        if (x < _leftBtn.center.x + width/2) {
            x =  _leftBtn.center.x + width/2;
        }
        
        if (x > _lineView.frame.origin.x + _lineView.frame.size.width ) {
            x = _lineView.frame.origin.x + _lineView.frame.size.width;
        }
        
        for (int i=0; i<_centexArr.count; i++) {
            if (i!=0) {
                float lcx=[_centexArr[i-1] floatValue];
                float rcx=[_centexArr[i] floatValue];
                
                float m_x=x-lcx;
                float r_x=rcx-x;
                if (m_x>=0&&r_x>=0) {
                    if (m_x<r_x) {
                        x=lcx;
                        _selectRightIdx=i-1;
                    }
                    else
                    {
                        x=rcx;
                        _selectRightIdx=i;
                    }
                }
            }
        }
        
        if (_selectRightIdx==_selectLeftIdx) {
            _selectRightIdx=_selectLeftIdx+1<=_moneyArr.count-1?_selectLeftIdx+1:_moneyArr.count-1;
        }
        
        
        gesture.view.center = CGPointMake([_centexArr[_selectRightIdx] floatValue], y);
        
        [gesture setTranslation:CGPointMake(0, 0) inView:self];
        _rightLine.frame = CGRectMake( [_centexArr[_selectRightIdx] floatValue] , _rightLine.frame.origin.y, _lineView.frame.size.width - [_centexArr[_selectRightIdx] floatValue] +marginleft , _rightLine.frame.size.height);
        _maxMoney = [NSString stringWithFormat:@"%@",_moneyArr[_selectRightIdx]];
        
       
        
    }
}

-(void)submitBtnClicked:(id)sender
{
    if (self.customRangeSliderView_Block) {
        self.customRangeSliderView_Block(_minMoney,_maxMoney);
    }
}
@end
