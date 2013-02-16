//
//  photosTVC.m
//  stanfordTour
//
//  Created by Zheming Zheng on 2/15/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "photosTVC.h"
#import "FlickrFetcher.h"


@interface photosTVC ()

@property (nonatomic, strong) NSMutableArray *photoCategory;


@end

@implementation photosTVC





-(NSMutableArray *)photoCategory
{
    if (!_photoCategory)
        _photoCategory= [[NSMutableArray alloc]init];
    return  _photoCategory;
    
}


-(NSString *) getTagString: (NSString *) tagNames
{
    NSArray *tags= [tagNames componentsSeparatedByString:@" "];
    for (int i=0; i<[tags count]; i++) {
      
        if ( !([tags[i] isEqualToString:@"cs193pspot"])){
            if(!([tags[i] isEqualToString:@"portrait"])){
                if(!([tags[i] isEqualToString:@"landscape"])){
                    return tags[i];
                }
            }
        }
        
        
    }
    
     return tags[0];
}



// sets the Model
// reloads the UITableView (since Model is changing)

- (void)viewDidLoad
{
    self.photos = [FlickrFetcher stanfordPhotos ];
    NSMutableSet *tags= [[NSMutableSet alloc]init];
    
    
    for (int i=0; i<[self.photos count]; i++) {
        NSString *str= [self getTagString:[self.photos[i][FLICKR_TAGS]description]];
        [tags addObject:str];
    }
    
    
    
    for (NSString* tempStr in tags ) {
      
        NSMutableArray *tempPics=[[NSMutableArray alloc]init];
        for (int i=0; i<[self.photos count]; i++) {
            if ([tempStr isEqualToString: [self getTagString:[self.photos[i][FLICKR_TAGS]description]]]) {
                [tempPics addObject:self.photos[i]];
            }
        }
        [self.photoCategory addObject:tempPics];
    }
}


//- (void)setPhotos:(NSArray *)photos
//{
//    _photos = photos;
//    [self.tableView reloadData];
//}

#pragma mark - Segue

// prepares for the "Show Image" segue by seeing if the destination view controller of the segue
//  understands the method "setImageURL:"
// if it does, it sends setImageURL: to the destination view controller with
//  the URL of the photo that was selected in the UITableView as the argument
// also sets the title of the destination view controller to the photo's title
//
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"get photos"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setPhotos:)]) {
                   
                    [segue.destinationViewController performSelector:@selector(setPhotos:) withObject:self.photoCategory[indexPath.row]];
                    [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
                }
            }
        }
    }
}

#pragma mark - UITableViewDataSource

// lets the UITableView know how many rows it should display
// in this case, just the count of dictionaries in the Model's array

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.photoCategory count];
}

// a helper method that looks in the Model for the photo dictionary at the given row
//  and gets the title out of it

- (NSString *)titleForRow:(NSUInteger)row
{
   NSString *str= [self.photoCategory[row][0] [FLICKR_TAGS] description];
    str= [str stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[str substringToIndex:1] uppercaseString]];

    return [self getTagString:str]; // description because could be NSNull
}

// a helper method that looks in the Model for the photo dictionary at the given row
//  and gets the owner of the photo out of it

- (NSString *)subtitleForRow:(NSUInteger)row
{
    
    return [NSString stringWithFormat: @"%d photos" , [self.photoCategory[row] count] ]; // description because could be NSNull
}

// loads up a table view cell with the title and owner of the photo at the given row in the Model

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Stanford Photo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    
    return cell;
}
@end

