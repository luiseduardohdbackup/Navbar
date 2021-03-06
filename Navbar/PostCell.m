//
//  PostCell.m
//  Navbar
//
//  Created by Jake Scott on 4/03/13.
//  Copyright (c) 2013 superlogical. All rights reserved.
//

#import "PostCell.h"


@implementation PostCell

@synthesize titleLabel = _titleLabel;
@synthesize urlLabel = _urlLabel;
@synthesize twitterImageView = _twitterImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.backgroundView = [[UIImageView alloc] initWithImage:[[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]imageFromColor]];   
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIColor colorWithRed:139/255.0f green:93/255.0f blue:121/255.0f alpha:1]imageFromColor]];
    
    self.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:14];
    self.titleLabel.textColor = [UIColor darkGrayColor];
    
    self.urlLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:12];
    self.urlLabel.textColor = [UIColor lightGrayColor];
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    
    self.titleLabel = nil;
    self.urlLabel = nil;
    
    [self.twitterImageView cancelCurrentImageLoad];
}

-(void)configureForPost:(PFObject *)post
{
    NSString *urlString = [post objectForKey:@"url"];
    if (urlString && urlString.length > 0)
    {
        NSURL *url = [[NSURL alloc]initWithString:[post objectForKey:@"url"]];
        NSString *host = [url host];
        
        NSString *twitter = [post objectForKey:@"twitter"];
        if (twitter && twitter.length > 0) {
            twitter = [NSString stringWithFormat:@"\nvia @%@", twitter];
        }
        
        self.urlLabel.text = [NSString stringWithFormat:@"%@ %@", host, twitter];
        
    } else {
        self.urlLabel.text = @"No url, yikes!";
    }
    
    NSString *titleString = [post objectForKey:@"title"];
    self.titleLabel.text = titleString ? titleString : @"No title umm woops!";

    CGFloat width = 240.0f;
    
    // Resize the title rect based on content
    CGRect rect = CGRectMake(10, 0, width, 88);
    self.titleLabel.frame = rect;
    [self.titleLabel sizeToFit];
    rect.size.height = self.titleLabel.frame.size.height;
    self.titleLabel.frame = rect;
    
    // Resize the url rect based on content
    CGRect urlRect = CGRectMake(10, 0, width, 88);
    self.urlLabel.frame = urlRect;
    [self.urlLabel sizeToFit];
    urlRect.size.height = self.urlLabel.frame.size.height;
    self.urlLabel.frame = urlRect;
    
    // Vertically position the labels
    CGFloat height = self.titleLabel.frame.size.height + self.urlLabel.frame.size.height;
    CGFloat y = ceilf(self.frame.size.height / 2.0f) - ceilf(height / 2.0f);
    
    rect = CGRectMake(self.titleLabel.frame.origin.x, y, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    self.titleLabel.frame = rect;
    
    // Position the url based on the title label
    rect = CGRectMake(self.urlLabel.frame.origin.x, y + self.titleLabel.frame.size.height, self.urlLabel.frame.size.width, self.urlLabel.frame.size.height);
    self.urlLabel.frame = rect;
    
    
    NSString *twitter = [post objectForKey:@"twitter"];
    if (twitter)
    {
        NSString *twitterUrl = [NSString stringWithFormat:@"https://api.twitter.com/1/users/profile_image?size=bigger&screen_name=%@", twitter];
        NSURL *url = [NSURL URLWithString:twitterUrl];
        [self.twitterImageView setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (!error) {
                self.twitterImageView.image = [self.twitterImageView.image roundedCornerImage:[[NSNumber numberWithInt:36] intValue] borderSize:0];
            } else {
                NSLog(@"Error downloading twitter image %@", error);
            }
        }];        
    }
}

@end
