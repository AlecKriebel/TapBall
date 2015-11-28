//
//  gameViewController.h
//  TapBall
//
//  Created by Alec Kriebel on 7/4/14.
//  Copyright (c) 2014 AlecKriebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface gameViewController : GAITrackedViewController {
    
    IBOutlet UILabel *countDown;
    IBOutlet UILabel *scoreLabel;
    IBOutlet UILabel *dailyLabel;
    
    IBOutlet UIImageView *ball;

}

@end
