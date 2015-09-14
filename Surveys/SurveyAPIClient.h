//
//  SurveyAPIClient.h
//  Surveys
//
//  Created by Thanaporn on 9/12/15.
//  Copyright (c) 2015 Thanaporn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@protocol SurveyClientDelegate;

@interface SurveyAPIClient : AFHTTPSessionManager
@property (nonatomic, weak) id<SurveyClientDelegate>delegate;

+ (SurveyAPIClient *)sharedClient;
- (void) getSurveyData;
@end

@protocol SurveyClientDelegate <NSObject>
@optional
-(void)SurveyAPIClient:(SurveyAPIClient *)client didUpdateWithSurvey:(id)surveys;
-(void)SurveyAPIClient:(SurveyAPIClient *)client didFailWithError:(NSError *)error;
@end

