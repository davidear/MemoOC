//
//  MMNoteEditTextView.m
//  MemoOC
//
//  Created by dai.fengyi on 15/7/31.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import "MMNoteEditTextView.h"
#import "MMNoteData.h"
@interface MMNoteEditTextView()
@end
@implementation MMNoteEditTextView
- (MMNote *)note {
    if (_note == nil) {
        _note = [[MMNote alloc] init];
    }
    return _note;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadData];
        [self initSubviews];
        [self setUI];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadData];
        [self initSubviews];
        [self setUI];
    }
    return self;
}

- (void)loadData {
    
}
- (void)initSubviews {
    self.topicTextField = [[UITextField alloc] init];
    self.notebook = [[UIButton alloc] init];
    self.locationButton = [[UIButton alloc] init];
    [self addSubview:self.topicTextField];
    [self addSubview:self.notebook];
    [self addSubview:self.locationButton];
    [self setUI];
}
- (void)setUI {
    _topicTextField.font = [UIFont systemFontOfSize:13];
    _topicTextField.textColor = [UIColor colorFromHexString:kColorDark];
    _topicTextField.placeholder = @"note comes from shenzhen city 1088";
    
    [_notebook setImage:[UIImage imageNamed:@"iconfont-bijiben"] forState:UIControlStateNormal];
    [_notebook setTitleColor:[UIColor colorFromHexString:kColorDark] forState:UIControlStateNormal];
    [_notebook setTitle:self.note.notebook forState:UIControlStateNormal];
    [_notebook setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    [_locationButton setImage:[UIImage imageNamed:@"iconfont-ditu"] forState:UIControlStateNormal];
    
}

- (void)layoutSubviews {
    _topicTextField.frame = CGRectMake(8, 0, self.bounds.size.width - 16, 44);
    _notebook.frame = CGRectMake(8, CGRectGetMaxY(_topicTextField.frame), 100, 30);
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
