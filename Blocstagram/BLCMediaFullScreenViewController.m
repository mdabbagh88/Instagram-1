  //
  //  BLCMediaFullScreenViewController.m
  //  Blocstagram
  //
  //  Created by Eric Gu on 1/3/15.
  //  Copyright (c) 2015 egu. All rights reserved.
  //

#import "BLCMediaFullScreenViewController.h"
#import "BLCMedia.h"

@interface BLCMediaFullScreenViewController () <UIScrollViewDelegate>

@property ( nonatomic, strong ) BLCMedia *media;
@property ( nonatomic, strong ) UITapGestureRecognizer *tap;
@property ( nonatomic, strong ) UITapGestureRecognizer *doubleTap;
@property ( nonatomic, strong ) UIButton *shareButton;

@end

@implementation BLCMediaFullScreenViewController

- ( instancetype ) initWithMedia:( BLCMedia * )media
{
  self = [super init];
  
  if ( self )
  {
    self.media = media;
    self.shareButton = _shareButton;
  }
  
  return self;
}

- ( void ) viewDidLoad
{
  [super viewDidLoad];
  
  self.scrollView = [UIScrollView new];
  self.scrollView.delegate = self;
  self.scrollView.backgroundColor = [UIColor whiteColor];
  
  //why don't we make this self.view = self.scrollview?
  [self.view addSubview:self.scrollView];
  
  self.imageView = [UIImageView new];
  self.imageView.image = self.media.image;
  
  [self.scrollView addSubview:self.imageView];
  self.scrollView.contentSize = self.media.image.size;
  
  self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector( tapFired: )];
  
  self.doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector( doubleTapFired: )];
  self.doubleTap.numberOfTapsRequired = 2;
  
  //Add Custom Button
  self.shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.shareButton setTitle:@"Share" forState:UIControlStateNormal];
 
  [self.shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  [self.scrollView addSubview:self.shareButton];
  
  [self.tap requireGestureRecognizerToFail:self.doubleTap];
  
  [self.scrollView addGestureRecognizer:self.tap];
  [self.scrollView addGestureRecognizer:self.doubleTap];
}

- ( void ) viewWillAppear:( BOOL )animated
{
  [super viewWillAppear:animated];
  [self centerScrollView];
}

- ( void ) viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  self.scrollView.frame = self.view.bounds;
 
  CGSize scrollViewFrameSize = self.scrollView.frame.size;
  CGSize scrollViewContentSize = self.scrollView.contentSize;
  
  [self.shareButton setFrame:CGRectMake(self.view.frame.size.width * 0.8, self.view.frame.size.height * 0.05, 50, 50)];
  
  CGFloat scaleWidth = scrollViewFrameSize.width / scrollViewContentSize.width;
  CGFloat scaleHeight = scrollViewFrameSize.height / scrollViewContentSize.height;
  CGFloat minScale = MIN(scaleWidth, scaleHeight);
  
  self.scrollView.minimumZoomScale = minScale;
  self.scrollView.maximumZoomScale = 1;
}

- ( void )centerScrollView
{
  [self.imageView sizeToFit];
  
  CGSize boundsSize = self.scrollView.bounds.size;
  CGRect contentsFrame = self.imageView.frame;
  
  if ( contentsFrame.size.width < boundsSize.width )
  {
    contentsFrame.origin.x = ( boundsSize.width - CGRectGetWidth( contentsFrame ) ) / 2;
  }
  else
  {
    contentsFrame.origin.x = 0;
  }
  
  if ( contentsFrame.size.height < boundsSize.height )
  {
    contentsFrame.origin.y = ( boundsSize.height - CGRectGetHeight( contentsFrame ) ) / 2;
  }
  else
  {
    contentsFrame.origin.y = 0;
  }
  
  self.imageView.frame = contentsFrame;
}

#pragma mark - UIScrollViewDelegate

- ( UIView* )viewForZoomingInScrollView:( UIScrollView * )scrollView
{
  return self.imageView;
}

- ( void)scrollViewDidZoom:(UIScrollView *)scrollView {
  [self centerScrollView];
}

#pragma mark - Gesture Recognizers

- ( void ) tapFired:( UITapGestureRecognizer * )sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- ( void ) doubleTapFired:(UITapGestureRecognizer *)sender {
  if ( self.scrollView.zoomScale == self.scrollView.minimumZoomScale )
  {
    CGPoint locationPoint = [sender locationInView:self.imageView];
    
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat width = scrollViewSize.width / self.scrollView.maximumZoomScale;
    CGFloat height = scrollViewSize.height / self.scrollView.maximumZoomScale;
    CGFloat x = locationPoint.x - ( width / 2 );
    CGFloat y = locationPoint.y - ( height / 2 );
    
    [self.scrollView zoomToRect:CGRectMake( x, y, width, height ) animated:YES];
  }
  else
  {
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
  }
}

-( void )shareButtonPressed:( id )sender
{
  NSLog( @"hi" );
}

@end
