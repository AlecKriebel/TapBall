//
//  howToViewController.h
//  TapBall
//
//  Created by Alec Kriebel on 7/7/14.
//  Copyright (c) 2014 AlecKriebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface howToViewController : GAITrackedViewController {
    
    IBOutlet UIButton *back;
    IBOutlet UIButton *play;
    
    IBOutlet UILabel *topLabel;
    IBOutlet UILabel *midLabel;
    IBOutlet UILabel *bottomLabel;
}

@property (nonatomic) BOOL tutorial;

@end
