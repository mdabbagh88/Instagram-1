//
//  BLCImagesTableViewController.m
//  Blocstagram
//
//  Created by Eric Gu on 12/28/14.
//  Copyright (c) 2014 egu. All rights reserved.
//

#import "BLCImagesTableViewController.h"
#import "BLCDataSource.h"
#import "BLCMedia.h"
#import "BLCUser.h"
#import "BLCComment.h"
#import "BLCMediaTableViewCell.h"
#import "BLCLoginViewController.h"
#import "BLCMediaFullScreenViewController.h"
#import "BLCMediaFullScreenAnimator.h"
#import "BLCCameraViewController.h"
#import "BLCImageLibraryViewController.h"

#define cellIdentifier @"mediaCell"

@interface BLCImagesTableViewController ( ) <BLCMediaTableViewCellDelegate, UIViewControllerTransitioningDelegate, BLCCameraViewControllerDelegate, BLCImageLibraryViewControllerDelegate>

@property ( nonatomic, weak ) UIImageView *lastTappedImageView;
@property ( nonatomic, weak ) UIView *lastSelectedCommentView;
@property ( nonatomic, assign ) CGFloat lastKeyboardAdjustment;

@end

@implementation BLCImagesTableViewController

- ( id )initWithStyle:( UITableViewStyle )style
{
  self = [super initWithStyle:style];
  if ( self )
  {
    
  }
  return self;
}

- ( void )viewDidLoad
{
  [[BLCDataSource sharedInstance] addObserver:self forKeyPath:@"mediaItems" options:0 context:nil];
  
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self action:@selector( refreshControlDidFire: ) forControlEvents:UIControlEventValueChanged];
  
  [self.tableView registerClass:[BLCMediaTableViewCell class] forCellReuseIdentifier:@"mediaCell"];
  
  self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
  
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ||
         [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
         UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraPressed:)];
         self.navigationItem.rightBarButtonItem = cameraButton;
     }
  
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
}

- ( void )viewWillAppear:( BOOL )animated
{
  NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
  if ( indexPath )
  {
    [self.tableView deselectRowAtIndexPath:indexPath animated:animated];
  }
}

- ( void ) tableView:( UITableView * )tableView didSelectRowAtIndexPath:( NSIndexPath * )indexPath
{
  BLCMediaTableViewCell *cell = ( BLCMediaTableViewCell * ) [tableView cellForRowAtIndexPath:indexPath];
  [cell stopComposingComment];
}

-( void )backPressed: ( id )sender
{
  BLCLoginViewController *loginVC = [BLCLoginViewController new];
  [self.navigationController setViewControllers:@[loginVC] animated:YES];
}

- ( void ) dealloc
{
  [[BLCDataSource sharedInstance] removeObserver:self forKeyPath:@"mediaItems"];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- ( void )setEditing:( BOOL )editing animated:( BOOL )animate
{
  [super setEditing:editing animated:animate];
  [self.tableView setEditing:editing animated:animate];
}

- ( void ) refreshControlDidFire:( UIRefreshControl * ) sender
{
  [[BLCDataSource sharedInstance] requestNewItemsWithCompletionHandler:^( NSError *error )
   {
     [sender endRefreshing];
   }];
}

- ( void ) cellWillStartComposingComment:( BLCMediaTableViewCell * )cell
{
  self.lastSelectedCommentView = ( UIView * )cell.commentView;
}

- ( void ) cell:( BLCMediaTableViewCell * )cell didComposeComment:( NSString * )comment
{
  [[BLCDataSource sharedInstance] commentOnMediaItem:cell.mediaItem withCommentText:comment];
}

- ( void ) infiniteScrollIfNecessary
{
  NSIndexPath *bottomIndexPath = [[self.tableView indexPathsForVisibleRows] lastObject];
  if ( bottomIndexPath && bottomIndexPath.row == [BLCDataSource sharedInstance].mediaItems.count - 1 )
  {
      // The very last cell is on screen
    [[BLCDataSource sharedInstance] requestOldItemsWithCompletionHandler:nil];
  }
}

#pragma mark - UIScrollViewDelegate

- ( void )scrollViewDidScroll:( UIScrollView * )scrollView
{
  [self infiniteScrollIfNecessary];
}

- ( void ) observeValueForKeyPath:( NSString * )keyPath ofObject:( id )object change:( NSDictionary * )change context:( void * )context
{
  if ( object == [BLCDataSource sharedInstance] && [keyPath isEqualToString:@"mediaItems"] )
  {
      // We know mediaItems changed.  Let's see what kind of change it is.
    int kindOfChange = [change[NSKeyValueChangeKindKey] intValue];
    
    if ( kindOfChange == NSKeyValueChangeSetting )
    {
      [self.tableView reloadData];
    }
    else if ( kindOfChange == NSKeyValueChangeInsertion || kindOfChange == NSKeyValueChangeRemoval || kindOfChange == NSKeyValueChangeReplacement )
    {
      NSIndexSet *indexSetOfChanges = change[NSKeyValueChangeIndexesKey];
      
      NSMutableArray *indexPathsThatChanged = [NSMutableArray array];
      [indexSetOfChanges enumerateIndexesUsingBlock:^( NSUInteger idx, BOOL *stop )
       {
         NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
         [indexPathsThatChanged addObject:newIndexPath];
       }];
      
      [self.tableView beginUpdates];
      
      if ( kindOfChange == NSKeyValueChangeInsertion )
      {
        [self.tableView insertRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
      }
      else if ( kindOfChange == NSKeyValueChangeRemoval )
      {
        [self.tableView deleteRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
      }
      else if ( kindOfChange == NSKeyValueChangeReplacement )
      {
        [self.tableView reloadRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
      }
      [self.tableView endUpdates];
    }
  }
}

-( BOOL )tableView:( UITableView * )tableView shouldIndentWhileEditingRowAtIndexPath:( NSIndexPath * )indexPath
{
  return NO;
}

#pragma mark - Keyboard Handling

- ( void )keyboardWillShow:( NSNotification * )notification
{
  NSValue *frameValue = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
  CGRect keyboardFrameInScreenCoordinates = frameValue.CGRectValue;
  CGRect keyboardFrameInViewCoordinates = [self.navigationController.view convertRect:keyboardFrameInScreenCoordinates fromView:nil];
  
  CGRect commentViewFrameInViewCoordinates = [self.navigationController.view convertRect:self.lastSelectedCommentView.bounds fromView:self.lastSelectedCommentView];
  
  CGPoint contentOffset = self.tableView.contentOffset;
  UIEdgeInsets contentInsets = self.tableView.contentInset;
  UIEdgeInsets scrollIndicatorInsets = self.tableView.scrollIndicatorInsets;
  CGFloat heightToScroll = 0;
  
  CGFloat keyboardY = CGRectGetMinY(keyboardFrameInViewCoordinates);
  CGFloat commentViewY = CGRectGetMinY(commentViewFrameInViewCoordinates);
  CGFloat difference = commentViewY - keyboardY;
  
  if ( difference > 0 )
  {
    heightToScroll += difference;
  }
  
  if ( CGRectIntersectsRect( keyboardFrameInViewCoordinates, commentViewFrameInViewCoordinates ) )
  {
    // The two frames intersect (the keyboard would block the view)
    CGRect intersectionRect = CGRectIntersection(keyboardFrameInViewCoordinates, commentViewFrameInViewCoordinates);
    heightToScroll += CGRectGetHeight(intersectionRect);
  }
  
  if ( heightToScroll > 0 )
  {
    contentInsets.bottom += heightToScroll;
    scrollIndicatorInsets.bottom += heightToScroll;
    contentOffset.y += heightToScroll;
    
    NSNumber *durationNumber = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curveNumber = notification.userInfo[UIKeyboardAnimationCurveUserInfoKey];
    
    NSTimeInterval duration = durationNumber.doubleValue;
    UIViewAnimationCurve curve = curveNumber.unsignedIntegerValue;
    UIViewAnimationOptions options = curve << 16;
    
    [UIView animateWithDuration:duration delay:0 options:options animations:^
    {
      self.tableView.contentInset = contentInsets;
      self.tableView.scrollIndicatorInsets = scrollIndicatorInsets;
      self.tableView.contentOffset = contentOffset;
    } completion:nil];
  }
  
  self.lastKeyboardAdjustment = heightToScroll;
}

- ( void )keyboardWillHide:( NSNotification * )notification
{
  UIEdgeInsets contentInsets = self.tableView.contentInset;
  contentInsets.bottom -= self.lastKeyboardAdjustment;
  
  UIEdgeInsets scrollIndicatorInsets = self.tableView.scrollIndicatorInsets;
  scrollIndicatorInsets.bottom -= self.lastKeyboardAdjustment;
  
  NSNumber *durationNumber = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
  NSNumber *curveNumber = notification.userInfo[UIKeyboardAnimationCurveUserInfoKey];
  
  NSTimeInterval duration = durationNumber.doubleValue;
  UIViewAnimationCurve curve = curveNumber.unsignedIntegerValue;
  UIViewAnimationOptions options = curve << 16;
  
  [UIView animateWithDuration:duration delay:0 options:options animations:^
  {
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = scrollIndicatorInsets;
  } completion:nil];
}

#pragma mark - Table view data source

- ( NSInteger )tableView:( UITableView * )tableView numberOfRowsInSection:( NSInteger )section
{
  return self.items.count;
}

- ( NSArray* ) items
{
  return [BLCDataSource sharedInstance].mediaItems;
}

- ( UITableViewCell * )tableView:( UITableView * )tableView cellForRowAtIndexPath:( NSIndexPath * )indexPath
{
  BLCMediaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
  cell.delegate = self;
  cell.mediaItem = [BLCDataSource sharedInstance].mediaItems[indexPath.row];
  return cell;
}

- ( CGFloat ) tableView:( UITableView * )tableView heightForRowAtIndexPath:( NSIndexPath * )indexPath
{
  BLCMedia *item = self.items[indexPath.row];
  return [BLCMediaTableViewCell heightForMediaItem:item width:CGRectGetWidth(self.view.frame)];
}

- ( void )tableView:( UITableView * )tableView commitEditingStyle:( UITableViewCellEditingStyle )editingStyle forRowAtIndexPath:( NSIndexPath * )indexPath
{
  if ( editingStyle == UITableViewCellEditingStyleDelete )
  {
    BLCMedia *item = self.items[indexPath.row];
    [[BLCDataSource sharedInstance] deleteMediaItem:item];
  }
}

#pragma mark - BLCMediaTableViewCellDelegate

- ( void ) cell:( BLCMediaTableViewCell * )cell didTapImageView:( UIImageView * )imageView
{
  self.lastTappedImageView = imageView;
  
  
  BLCMediaFullScreenViewController *fullScreenVC = [[BLCMediaFullScreenViewController alloc] initWithMedia:cell.mediaItem];
  
  fullScreenVC.transitioningDelegate = self;
  fullScreenVC.modalPresentationStyle = UIModalPresentationCustom;
  [self presentViewController:fullScreenVC animated:YES completion:nil];
}

- ( void ) cell:( BLCMediaTableViewCell * )cell didDoubleTapImageView:( UIImageView * )imageView
{
  BLCMedia *mediaItem = cell.mediaItem;
  if ( mediaItem.downloadState == BLCMediaDownloadStateNeedsImage )
  {
    [[BLCDataSource sharedInstance] downloadImageForMediaItem:mediaItem];
  }
}

#pragma mark - UIViewControllerTransitioningDelegate

- ( id<UIViewControllerAnimatedTransitioning> )animationControllerForPresentedController:( UIViewController * )presented
                                                                    presentingController:(UIViewController *)presenting
                                                                        sourceController:(UIViewController *)source {
  BLCMediaFullScreenAnimator *animator = [BLCMediaFullScreenAnimator new];
  animator.presenting = YES;
  animator.cellImageView = self.lastTappedImageView;
  return animator;
}

- ( id<UIViewControllerAnimatedTransitioning> )animationControllerForDismissedController:( UIViewController * )dismissed {
  BLCMediaFullScreenAnimator *animator = [BLCMediaFullScreenAnimator new];
  animator.cellImageView = self.lastTappedImageView;
  return animator;
}

- ( void ) cell:( BLCMediaTableViewCell * )cell didLongPressImageView:( UIImageView * )imageView
{
  NSMutableArray *itemsToShare = [NSMutableArray array];
  
  if ( cell.mediaItem.caption.length > 0 )
  {
    [itemsToShare addObject:cell.mediaItem.caption];
  }
  
  if (cell.mediaItem.image)
  {
    [itemsToShare addObject:cell.mediaItem.image];
  }
  
  if (itemsToShare.count > 0)
  {
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
  }
}

- ( void ) tableView:( UITableView *)tableView willDisplayCell:( UITableViewCell * )cell forRowAtIndexPath:( NSIndexPath * )indexPath
{
  BLCMedia *mediaItem = [BLCDataSource sharedInstance].mediaItems[indexPath.row];
  if ( mediaItem.downloadState == BLCMediaDownloadStateNeedsImage )
  {
    [[BLCDataSource sharedInstance] downloadImageForMediaItem:mediaItem];
  }
}

-( CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  BLCMedia *item = [BLCDataSource sharedInstance].mediaItems[indexPath.row];
  if ( item.image )
  {
    return 350;
  }
  else
  {
    return 150;
  }
}

- ( void ) cellDidPressLikeButton:( BLCMediaTableViewCell * )cell
{
  [[BLCDataSource sharedInstance] toggleLikeOnMediaItem:cell.mediaItem];
  
  
  if (cell.mediaItem.likeState == BLCLikeStateLiking)
  {
    int i = [cell.mediaItem.likes intValue] + 1;
    cell.mediaItem.likes = [NSString stringWithFormat:@"%d", i];
  }
  if (cell.mediaItem.likeState == BLCLikeStateUnliking)
  {
    int i = [cell.mediaItem.likes intValue] - 1;
    cell.mediaItem.likes = [NSString stringWithFormat:@"%d", i];
  }
}

#pragma mark - Camera and BLCCameraViewControllerDelegate
 
- ( void ) cameraPressed:( UIBarButtonItem * ) sender
{
  UIViewController *imageVC;
  if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
  {
    BLCCameraViewController *cameraVC = [[BLCCameraViewController alloc] init];
    cameraVC.delegate = self;
    imageVC = cameraVC;
  }
  else if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] )
  {
    BLCImageLibraryViewController *imageLibraryVC = [[BLCImageLibraryViewController alloc] init];
    imageLibraryVC.delegate = self;
    imageVC = imageLibraryVC;
  }
  if ( imageVC )
  {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:imageVC];
    [self presentViewController:nav animated:YES completion:nil];
  }
}

- ( void ) cameraViewController:( BLCCameraViewController * )cameraViewController didCompleteWithImage:( UIImage * )image
{
  [cameraViewController dismissViewControllerAnimated:YES completion:^{
    if ( image )
    {
      NSLog(@"Got an image!");
    }
    else
    {
      NSLog(@"Closed without an image.");
    }
  }];
}

- ( void ) imageLibraryViewController:( BLCImageLibraryViewController * )imageLibraryViewController didCompleteWithImage:( UIImage * )image {
  [imageLibraryViewController dismissViewControllerAnimated:YES completion:^{
    if ( image )
    {
      NSLog(@"Got an image!");
    }
    else
    {
      NSLog(@"Closed without an image.");
    }
  }];
}

@end
