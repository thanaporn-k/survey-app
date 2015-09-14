//
//  SurveyModel.m
//  Surveys
//
//  Created by Thanaporn on 9/12/15.
//  Copyright (c) 2015 Thanaporn. All rights reserved.
//

#import "SurveyModel.h"

@implementation SurveyModel
@dynamic description;

+ (JSONKeyMapper*)keyMapper {
    NSDictionary *map = @{ @"description": @"desc"};
    
    return [[JSONKeyMapper alloc] initWithDictionary:map];
}
@end
