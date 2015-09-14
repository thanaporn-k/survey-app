//
//  SurveyCardView.h
//  Surveys
//
//  Created by Thanaporn on 9/13/15.
//  Copyright (c) 2015 Thanaporn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurveyCardView : UIView
@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLbl;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *takeSurveyBtn;
@property (strong, nonatomic) IBOutlet UIView *view;

@end
