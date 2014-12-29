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

#define cellIdentifier @"imageCell"

@interface BLCImagesTableViewController ( )

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

  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
}

#pragma mark - Table view data source

- ( NSInteger )tableView:( UITableView * )tableView numberOfRowsInSection:( NSInteger )section
{
  return self.items.count;
}

- ( NSMutableArray* ) items
{
 return [BLCDataSource sharedInstance].mediaItems;
}

- ( UITableViewCell * )tableView:( UITableView * )tableView cellForRowAtIndexPath:( NSIndexPath * )indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
  static NSInteger imageViewTag = 1234;
  UIImageView *imageView = ( UIImageView* )[cell.contentView viewWithTag:imageViewTag];

  if (!imageView) {
    // This is a new cell, it doesn't have an image view yet
    imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleToFill;

    imageView.frame = cell.contentView.bounds;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    imageView.tag = imageViewTag;
    [cell.contentView addSubview:imageView];
  }
  BLCMedia *item = self.items[indexPath.row];
  imageView.image = item.image;
    
  return cell;
}

- ( CGFloat ) tableView:( UITableView * )tableView heightForRowAtIndexPath:( NSIndexPath * )indexPath
{
  BLCMedia *item = self.items[indexPath.row];
  UIImage *image = item.image;
  return ( CGRectGetWidth( self.view.frame ) / image.size.width ) * image.size.height;
}


- ( void )tableView:( UITableView * )tableView commitEditingStyle:( UITableViewCellEditingStyle )editingStyle forRowAtIndexPath:( NSIndexPath * )indexPath
{
  if ( editingStyle == UITableViewCellEditingStyleDelete )
  {  
    [self.items removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
  }
}

@end
