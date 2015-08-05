//
//  MMNoteEditTextView.m
//  MemoOC
//
//  Created by dai.fengyi on 15/7/31.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import "MMNoteEditTextView.h"
@interface MMNoteEditTextView()
@end
@implementation MMNoteEditTextView
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSubviews];
        [self setUI];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
        [self setUI];
    }
    return self;
}

- (void)initSubviews {
    self.locationInfo = [[UILabel alloc] init];
    self.notebook = [[UIButton alloc] init];
    self.locationButton = [[UIButton alloc] init];
    [self addSubview:self.locationInfo];
    [self addSubview:self.notebook];
    [self addSubview:self.locationButton];
    [self setUI];
}
- (void)setUI {
    _locationInfo.font = [UIFont systemFontOfSize:13];
    _locationInfo.textColor = [UIColor colorFromHexString:kColorDark];
    _locationInfo.text = @"note comes from shenzhen city 1088";
    
    [_notebook setImage:[UIImage imageNamed:@"iconfont-bijiben"] forState:UIControlStateNormal];
    [_notebook setTitleColor:[UIColor colorFromHexString:kColorDark] forState:UIControlStateNormal];
    [_notebook setTitle:@"notebook" forState:UIControlStateNormal];
    [_notebook setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    [_locationButton setImage:[UIImage imageNamed:@"iconfont-ditu"] forState:UIControlStateNormal];
    
}

- (void)layoutSubviews {
    _locationInfo.frame = CGRectMake(8, 0, self.bounds.size.width - 16, 44);
    _notebook.frame = CGRectMake(8, CGRectGetMaxY(_locationInfo.frame), 100, 30);
    _locationButton.frame = CGRectMake(self.bounds.size.width - 8 - 30, _notebook.frame.origin.y, 30, 30);
    self.textContainerInset = UIEdgeInsetsMake(CGRectGetMaxY(_locationButton.frame), 0, 0, 0);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
