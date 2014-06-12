//
//  ViewController.m
//  DraggableTable
//
//  Created by Sarah Hicks on 6/6/14.
//  Copyright (c) 2014 Sarah Hicks. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *tableViewConstraints;
@property (nonatomic, strong) NSNumber *lastTableHeight;
@property (nonatomic) CGPoint lastHeightPoint;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    mainArray = [[NSMutableArray alloc] initWithObjects:@"this", @"is", @"a", @"table", @"view", nil];
    NSArray *fillerData = @[@"Item 1", @"Item 2", @"Item 3", @"Item 4",@"Item 5", @"Item 6", @"Item 7", @"Item 8", @"Item 9", @"Item 10"];
    mainArray = [fillerData mutableCopy];
    
    
    //TRYING CONSTRAINTS
    [self.myTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.tableViewConstraints = [[NSMutableArray alloc]initWithCapacity:10];
    NSNumber *height;
    self.lastHeightPoint = CGPointMake(-1, -1);    //because a CGPoint has no uninitialized state
    if (self.lastHeightPoint.y <0)
    {
        height = self.initialHeightOfTable;
    } else {
        height = self.lastTableHeight;
    }
    
    //dictionary of view(s) to arrange with key(s): self.tableview, tableView
    NSDictionary *tableViewsDictionary =[[NSDictionary alloc] initWithObjectsAndKeys:
                                         self.myTableView, @"tableView",nil];
    
    //dictionary of metrics to help arrangement
    NSDictionary *metrics = [[NSDictionary alloc] initWithObjectsAndKeys:
                             height, @"tableHeight", nil];
    
    //pin tableview to full width of whatever superview is, no standard padding
    [self.tableViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:tableViewsDictionary]];
    
    //pin tableview to bottom, no standard padding, height to be a third of screen
    [self.tableViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[tableView(tableHeight)]|" options:0 metrics:metrics views:tableViewsDictionary]];
    
    [self.view addConstraints:self.tableViewConstraints];
    
    UIPanGestureRecognizer *dragToExpand = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(changeTableViewSize:)];
    dragToExpand.minimumNumberOfTouches = 1;
    dragToExpand.delegate = (id)self;
    [self.view addGestureRecognizer:dragToExpand];
    
    [self.myTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - dragToExpand

- (NSNumber *)initialHeightOfTable
{
    CGSize viewSize = self.view.bounds.size;
    NSNumber *viewHeight = [NSNumber numberWithFloat:viewSize.height * 1.0/3.0];
    NSLog(@"initialHeightOfTable is %@", viewHeight);
    return viewHeight;
}

- (NSNumber *)lastHeightOfTableFromPoint:(CGPoint)point
{
    CGSize viewSize = self.view.bounds.size;
    NSNumber *lastHeight = [NSNumber numberWithFloat:viewSize.height- point.y + 20];
    self.lastTableHeight = lastHeight;
    self.lastHeightPoint = point;
    NSLog(@"lastHeightOfTableFromPoint is %@",self.lastTableHeight);
    return lastHeight;
}

- (void)changeTableViewSize:(UIPanGestureRecognizer *)dragToExpand
{
    
    [self.view removeConstraints:self.tableViewConstraints];
    [self.tableViewConstraints removeAllObjects];
    
    CGPoint dragEnd = [dragToExpand locationInView:self.view];
    
    //dictionary of view(s) to arrange with key(s): self.tableview, tableView
    NSDictionary *tableViewsDictionary =[[NSDictionary alloc] initWithObjectsAndKeys:
                                         self.myTableView, @"tableView",nil];
    //dictionary of metrics to help arrangement
    NSDictionary *metrics = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [self lastHeightOfTableFromPoint:dragEnd], @"tableHeight", nil];
    
    //pin tableview to full width of whatever superview is, no standard padding
    [self.tableViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:tableViewsDictionary]];
    //pin tableview to bottom, no standard padding, height to be wherever pan gesture stops
    [self.tableViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[tableView(tableHeight)]|" options:0 metrics:metrics views:tableViewsDictionary]];
    
    [self.view addConstraints:self.tableViewConstraints];
}

//to allow tableview scroll and dragToExpand to both work

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)dragToExpand shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;    //NO turns off dragToExpand
}

//to control conditions in which dragToExpand does NOT register: tableview scroll, pans outside the tableView frame

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)dragToExpand shouldReceiveTouch:(UITouch *)touch {
    
    CGPoint pointInView = [touch locationInView:dragToExpand.view];
    if (CGRectContainsPoint(self.myTableView.frame, pointInView) && [touch locationInView:self.myTableView].y <80)
    {
        return YES;
    }
    else
        return NO;      //NO turns off dragToExpand  unimplemented same as YES
}

#pragma mark - Table view data source, not immediately involved in dragToExpand

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mainArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [mainArray objectAtIndex:indexPath.row];
    
    return cell;
}

@end
