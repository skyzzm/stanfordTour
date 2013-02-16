//
//  recentPhotosViewController.m
//  stanfordTour
//
//  Created by Zheming Zheng on 2/15/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "recentPhotosViewController.h"
#import "FlickrFetcher.h"

@interface recentPhotosViewController ()

@end

@implementation recentPhotosViewController
- (void)viewDidLoad
{
    self.photos = [FlickrFetcher stanfordPhotos];
    [super viewDidLoad];
    
    
}

@end
