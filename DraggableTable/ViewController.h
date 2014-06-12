//
//  ViewController.h
//  DraggableTable
//
//  Created by Sarah Hicks on 6/6/14.
//  Copyright (c) 2014 Sarah Hicks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    
    NSMutableArray *mainArray;
}

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;

@end
