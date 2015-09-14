//
//  SurveyAPIClient.m
//  Surveys
//
//  Created by Thanaporn on 9/12/15.
//  Copyright (c) 2015 Thanaporn. All rights reserved.
//

#import "SurveyAPIClient.h"

NSString * const theAPIKey = @"6eebeac3dd1dc9c97a06985b6480471211a777b39aa4d0e03747ce6acc4a3369";
NSString * const baseURLString = @"https://www-staging.usay.co";

@implementation SurveyAPIClient

+ (SurveyAPIClient *)sharedClient {
    
    static SurveyAPIClient *_sharedClient = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
    });
    return _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    return self;
}

- (void)getSurveyData {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = theAPIKey;
    parameters[@"username"] = @"usay";
    parameters[@"password"] = @"isc00l";
    
    [self GET:@"app/surveys.json" parameters:parameters
      success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(SurveyAPIClient:didUpdateWithSurvey:)]){
            [self.delegate SurveyAPIClient:self didUpdateWithSurvey:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(SurveyAPIClient:didFailWithError:)]) {
            [self.delegate SurveyAPIClient:self didFailWithError:error];
        }
    }];
    
}

@end

