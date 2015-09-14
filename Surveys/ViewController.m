//
//  ViewController.m
//  Surveys
//
//  Created by Thanaporn on 9/12/15.
//  Copyright (c) 2015 Thanaporn. All rights reserved.
//

#import "ViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SurveyCardView.h"


@interface ViewController ()


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (strong, nonatomic) IBOutlet TAPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *cardViews;
@property (strong, nonatomic) NSArray *surveys;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAPIData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - API
- (void) getAPIData {
    SurveyAPIClient *client = [SurveyAPIClient sharedClient];
    client.delegate = self;

    self.activityView.hidden = NO;
    [self.activityView startAnimating];
    
    [client getSurveyData];
}

#pragma mark - Survey Card Manipulation

- (void) setUpCardViewController {
   
    NSInteger cardCount = self.surveys.count;
    
    self.cardViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < cardCount; ++i) {
        [self.cardViews addObject:[NSNull null]];
    }

    //set up scroll view
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize =
    CGSizeMake(CGRectGetWidth(self.scrollView.frame) , CGRectGetHeight(self.scrollView.frame) * self.surveys.count);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    
    //set up page control
    [self.view bringSubviewToFront:self.pageControl];
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = cardCount;
    self.pageControl.dotImage = [UIImage imageNamed:@"dotInactive"];
    self.pageControl.currentDotImage = [UIImage imageNamed:@"dotActive"];
    self.pageControl.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    [self loadVisibleCards];
}

- (void)loadVisibleCards {
    
    // determine current page
    CGFloat cardHeight = CGRectGetHeight(self.scrollView.frame);
    NSUInteger card = floor((self.scrollView.contentOffset.y - cardHeight / 2) / cardHeight) + 1;
    self.pageControl.currentPage = card;
    
    NSInteger firstCard = card - 1;
    NSInteger lastCard = card + 1;
    
    // Clear anything before the first card
    for (NSInteger i=0; i< firstCard; i++) {
        [self clearCard:i];
    }
    for (NSInteger i=firstCard; i<=lastCard; i++) {
        [self loadCard:i];
    }
    // Clear anything after the last card
    for (NSInteger i=lastCard + 1; i< self.surveys.count ; i++) {
        [self clearCard:i];
    }
}

- (void)loadCard:(NSInteger)index {
    
    if (index < 0 || index >= self.surveys.count) {
        return;
    }
    
    // Load an individual card
    SurveyCardView *surveyCardView = [self.cardViews objectAtIndex:index];
    SurveyModel *survey = [self.surveys objectAtIndex:index];
    
    if ((NSNull*)surveyCardView == [NSNull null]) {
        
        CGRect frame = self.scrollView.frame;
        frame.origin.x = 0;
        frame.origin.y = CGRectGetHeight(frame) * index;
        frame.size = self.scrollView.bounds.size;
        
        surveyCardView = [[SurveyCardView alloc] initWithFrame:frame];
        surveyCardView.titleLbl.text = survey.title;
        surveyCardView.descriptionLbl.text = survey.desc;
        surveyCardView.takeSurveyBtn.layer.cornerRadius = 20;
        surveyCardView.clipsToBounds = YES;
        
        [surveyCardView.takeSurveyBtn addTarget:self
                   action:@selector(takeSurveyBtnPressed)
         forControlEvents:UIControlEventTouchUpInside];
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        NSURL *imageURL = [NSURL URLWithString:survey.cover_image_url];
        [manager downloadImageWithURL:imageURL
                              options:0
                             progress: nil
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    surveyCardView.imageView.image = image;
                                    surveyCardView.imageView.alpha = 0.9;
                                    surveyCardView.imageView.contentMode = UIViewContentModeScaleAspectFill;
                
                                }
                            }];
        
        [self.scrollView addSubview:surveyCardView];
        [self.cardViews replaceObjectAtIndex:index withObject:surveyCardView];
    }
    
}


- (void)clearCard:(NSInteger)index {
    if (index < 0 || index >= self.surveys.count) {
        return;
    }
    // Remove a page from the scroll view for performance
    SurveyCardView *cardView = [self.cardViews objectAtIndex:index];
    if ((NSNull*)cardView != [NSNull null]) {
        [cardView removeFromSuperview];
        [self.cardViews replaceObjectAtIndex:index withObject:[NSNull null]];
    }
}

#pragma mark - ButtonPressed
- (void) takeSurveyBtnPressed
{
    ViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    [self.navigationController pushViewController:detailViewController animated:YES];    
}

- (IBAction)refreshBtnPressed:(id)sender {
    
    for(int index = 0; index < self.surveys.count; index++)
    {
        SurveyCardView *cardView = [self.cardViews objectAtIndex:index];
        if ((NSNull*)cardView != [NSNull null]) {
            [cardView removeFromSuperview];
        }
    }
    
    self.cardViews = nil;
    self.surveys = nil;
    [self.scrollView setContentOffset:CGPointMake(0,0) animated:NO];
    self.pageControl.numberOfPages = 0;
    [self getAPIData];
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self loadVisibleCards];
}

#pragma mark - SurveyAPIClientDelegate

-(void)SurveyAPIClient:(SurveyAPIClient *)client didUpdateWithSurvey:(id)surveys{
    
    _surveys = [SurveyModel arrayOfModelsFromDictionaries: surveys];
    
    self.activityView.hidden = YES;
    [self.activityView stopAnimating];
    
    [self setUpCardViewController];
    
}

-(void)SurveyAPIClient:(SurveyAPIClient *)client didFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error retrieving data"
                                                        message:[NSString stringWithFormat:@"%@",error]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alertView.frame = self.view.bounds;
    [alertView show];
    self.activityView.hidden = YES;
    [self.activityView stopAnimating];

    
}
@end
