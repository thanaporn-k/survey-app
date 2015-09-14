//
//  SurveyCardView.m
//  Surveys
//
//  Created by Thanaporn on 9/13/15.
//  Copyright (c) 2015 Thanaporn. All rights reserved.
//

#import "SurveyCardView.h"

@implementation SurveyCardView


- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self)
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"SurveyCardView" owner:self options:nil] firstObject];
        self.frame = frame;
    }
    return self;
}



@end
