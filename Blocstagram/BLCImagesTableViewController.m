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

#define cellIdentifier @"mediaCell"

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

  [self.tableView registerClass:[BLCMediaTableViewCell class] forCellReuseIdentifier:cellIdentifier];
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
  BLCMediaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
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
    [self.items removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
  }
}

@end
