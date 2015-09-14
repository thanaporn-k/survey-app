//
//  SurveyModel.h
//  Surveys
//
//  Created by Thanaporn on 9/12/15.
//  Copyright (c) 2015 Thanaporn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface SurveyModel : JSONModel

@property (strong, nonatomic) NSString* cover_image_url;
@property (strong, nonatomic) NSString* desc;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* type;

@end


