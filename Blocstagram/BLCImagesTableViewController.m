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

#define cellIdentifier @"mediaCell"

@interface BLCImagesTableViewController ( ) <BLCMediaTableViewCellDelegate, UIViewControllerTransitioningDelegate>

@property ( nonatomic, weak ) UIImageView *lastTappedImageView;

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
  [super viewDidLoad];
  
  [[BLCDataSource sharedInstance] addObserver:self forKeyPath:@"mediaItems" options:0 context:nil];
  
  [self.tableView registerClass:[BLCMediaTableViewCell class] forCellReuseIdentifier:cellIdentifier];
  self.navigationItem.rightBarButtonItem = self.editButtonItem;
  self.tableView.allowsSelectionDuringEditing = NO;
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
  self.navigationItem.leftBarButtonItem = backButton;
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self action:@selector(refreshControlDidFire:) forControlEvents:UIControlEventValueChanged];
}

-( void )backPressed: ( id )sender
{
  BLCLoginViewController *loginVC = [BLCLoginViewController new];
  [self.navigationController setViewControllers:@[loginVC] animated:YES];
}

- (void) dealloc
{
  [[BLCDataSource sharedInstance] removeObserver:self forKeyPath:@"mediaItems"];
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
        // We have an incremental change: inserted, deleted, or replaced images
      
        // Get a list of the index (or indices) that changed
      NSIndexSet *indexSetOfChanges = change[NSKeyValueChangeIndexesKey];
      
        // Convert this NSIndexSet to an NSArray of NSIndexPaths (which is what the table view animation methods require)
      NSMutableArray *indexPathsThatChanged = [NSMutableArray array];
      [indexSetOfChanges enumerateIndexesUsingBlock:^( NSUInteger idx, BOOL *stop )
       {
         NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
         [indexPathsThatChanged addObject:newIndexPath];
       }];
      
        // Call `beginUpdates` to tell the table view we're about to make changes
      [self.tableView beginUpdates];
      
        // Tell the table view what the changes are
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
      
        // Tell the table view that we're done telling it about changes, and to complete the animation
      [self.tableView endUpdates];
    }
  }
}

-( BOOL )tableView:( UITableView * )tableView shouldIndentWhileEditingRowAtIndexPath:( NSIndexPath * )indexPath
{
  return NO;
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
  NSLog(@"Did Double Tap");
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
  if (item.image)
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
}

@end
