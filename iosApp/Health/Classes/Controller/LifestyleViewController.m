//
//  LifestyleViewController.m
//  Health
//
//  Created by Yuan on 1/27/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#import "LifestyleViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UITableView+DataSourceBlocks.h"
#import "TableViewWithBlock.h"
#import "SelectionCell.h"
#import "SVProgressHUD.h"
#import "SessionManager.h"
@interface LifestyleViewController ()
{
    BOOL isOpendCombobox1;
    NSArray *comboString1;
    BOOL isOpendCombobox2;
    NSArray *comboString2;
    BOOL isOpendCombobox3;
    NSArray *comboString3;
    BOOL isOpendCombobox4;
    NSArray *comboString4;
    BOOL isOpendCombobox5;
    NSArray *comboString5;
    IBOutlet UIButton *badgeButton;
     int option1,option2,option3,option4,option5,sum;
    BOOL isUpdated;
    NSString  *combo1String, *combo2String, *combo3String, *combo4String, *combo5String;
    int compleationrate;
}

@end

@implementation LifestyleViewController
@synthesize scrollView,comboBtn1,comboBtn2,comboBtn3,comboBtn4,comboBtn5,combotalbe1,combotalbe2,combotalbe3,combotalbe4,combotalbe5,comboText1,comboText2,comboText3,comboText4,comboText5,quiz1View,quiz2View,quiz3View,quiz4View,quiz5View,saveButton;
@synthesize lifestyle;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
       
    }
    return self;
}

- (void)viewDidLoad
{
    isUpdated = NO;
    [super viewDidLoad];

    self.title = @"HEALTH ASSESSMENT";
    
    _contentWidthConstraint.constant = [UIScreen mainScreen].bounds.size.width;
//    scrollView.contentSize = CGSizeMake(320, 1100);
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]init];
    barButton.title = @"";
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self initBadgeButton];
    [self loadData];
    [self combobox1Init];
    [self combobox2Init];
    [self combobox3Init];
    [self combobox4Init];
    [self combobox5Init];
    saveButton.buttonColor = [UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0];
    saveButton.highlightedColor = [UIColor colorWithRed:59.0f/255.0f green:173.0f/255.0f blue:213.0f/255.0f alpha:1.0];
    
    [saveButton setCornerRadius:5.0f];

    
    // Do any additional setup after loading the view from its nib.
}

-(void)loadData
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    SessionManager *manager = [SessionManager sharedManager];
    NSDictionary *parameters = @{};
    
    [manager GET:@"v1/healthAssessmentLifestyle" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        self.lifestyle = (NSDictionary *)responseObject;
        if([self.lifestyle count]>0)
        {
            [self showInfor];
            [SVProgressHUD dismiss];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error.."
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        [SVProgressHUD dismiss];
        
    }];}
-(void)showInfor
{
    comboText1.text = [self setCombo1:[self.lifestyle valueForKey:@"combo1"]];
    comboText2.text = [self setCombo2_3:[self.lifestyle valueForKey:@"combo2"]];
    comboText3.text = [self setCombo2_3:[self.lifestyle valueForKey:@"combo3"]];
    comboText4.text = [self setCombo4:[self.lifestyle valueForKey:@"combo4"]];
    comboText5.text = [self setCombo5:[self.lifestyle valueForKey:@"combo5"]];
    
    [badgeButton setTitle:[NSString stringWithFormat:@"%@%%", [self.lifestyle valueForKey:@"completionPercentage"]] forState:UIControlStateNormal];
}
-(void)initBadgeButton
{
    [badgeButton setBackgroundImage:[[UIImage imageNamed:@"ico_badge.png"] stretchableImageWithLeftCapWidth:9 topCapHeight:9] forState:UIControlStateNormal];
    /*if (obj[@"COMPLETIONRATE"]) {
         [badgeButton setTitle:[NSString stringWithFormat:@"%@%%", obj[@"COMPLETIONRATE"]] forState:UIControlStateNormal];
    }
    else{
        [badgeButton setTitle:@"0%" forState:UIControlStateNormal];
        
    }*/
   
    
    [badgeButton sizeToFit];
    
    CGRect badgeRect = badgeButton.frame;
    CGSize badgeSize = badgeRect.size;
    CGSize newSize = CGSizeMake(badgeSize.width + 15, badgeSize.height + 3);
    badgeRect.size = newSize;
    
    badgeButton.frame = badgeRect;
    
}
-(void)combobox5Init
{
    comboString5 = [NSArray arrayWithObjects:@"YES",@"NO", nil];
    isOpendCombobox5 = NO;
    comboText5.enabled = NO;
    [combotalbe5 initTableViewDataSourceAndDelegate:^(UITableView *tableView, NSInteger section)
    {
        NSInteger n = [comboString5 count];
        return n;
    }
                           setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath)
    {
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell)
        {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        
        [cell.lb setText:comboString5[indexPath.row]];
        return cell;
    }
                               setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath)
    {
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        comboText5.text=cell.lb.text;
//        CGRect rect = quiz5View.frame;
//        rect.size.height = 100;
//        [quiz5View setFrame:rect];
        [comboBtn5 sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    [combotalbe5.layer setBorderColor:[UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0].CGColor];
    [combotalbe5.layer setBorderWidth:2];
    
}

-(void)combobox3Init
{
    comboString3 = [NSArray arrayWithObjects:@"0-2",@"2-4",@"4-6",@"more than 6", nil];
    isOpendCombobox3 = NO;
    comboText3.enabled = NO;
    [combotalbe3 initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section)
    {
        NSInteger n = [comboString3 count];
        return n;
    }
                           setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath)
    {
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell)
        {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        
        [cell.lb setText:comboString3[indexPath.row]];
        return cell;
    }
                               setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath)
    {
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        comboText3.text=cell.lb.text;
//        CGRect rect = quiz3View.frame;
//        rect.size.height = 100;
//        [quiz3View setFrame:rect];
        [comboBtn3 sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    [combotalbe3.layer setBorderColor:[UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0].CGColor];
    [combotalbe3.layer setBorderWidth:2];
    
}

-(void)combobox2Init
{
    comboString2 = [NSArray arrayWithObjects:@"0-2",@"2-4",@"4-6",@"more than 6", nil];
    isOpendCombobox2 = NO;
    comboText2.enabled = NO;
    [combotalbe2 initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section)
    {
        NSInteger n=[comboString2 count];
        return n;
    }
                           setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath)
    {
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell)
        {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        
        [cell.lb setText:comboString2[indexPath.row]];
        return cell;
    }
                               setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath)
    {
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        comboText2.text=cell.lb.text;
//        CGRect rect = quiz2View.frame;
//        rect.size.height = 100;
//        [quiz2View setFrame:rect];
        [comboBtn2 sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    [combotalbe2.layer setBorderColor:[UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0].CGColor];
    [combotalbe2.layer setBorderWidth:2];
    
}

-(void)combobox1Init
{
    comboString1 = [NSArray arrayWithObjects:@"More than 5",@"between 3 and 5",@"between 1 and 3",@"I don't exercise at all", nil];
    isOpendCombobox1 = NO;
    comboText1.enabled = NO;
    [combotalbe1 initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section)
    {
        NSInteger n=[comboString1 count];
        return n;
    }
                           setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath)
    {
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell)
        {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        
        [cell.lb setText:comboString1[indexPath.row]];
        return cell;
    }
                               setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath)
    {
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        comboText1.text=cell.lb.text;
        [comboBtn1 sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    [combotalbe1.layer setBorderColor:[UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0].CGColor];
    [combotalbe1.layer setBorderWidth:2];
    
}
-(void)combobox4Init
{
    comboString4 = [NSArray arrayWithObjects:@"Never",@"Sometimes",@"Often",@"Always", nil];
    isOpendCombobox4 = NO;
    comboText4.enabled = NO;
    [combotalbe4 initTableViewDataSourceAndDelegate:^(UITableView *tableView, NSInteger section)
    {
        NSInteger n=[comboString4 count];
        return n;
    }
                           setCellForIndexPathBlock:^(UITableView *tableView, NSIndexPath *indexPath)
    {
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell)
        {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        [cell.lb setText:comboString4[indexPath.row]];
        return cell;
    }
                               setDidSelectRowBlock:^(UITableView *tableView, NSIndexPath *indexPath)
    {
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        comboText4.text=cell.lb.text;
//        CGRect rect = quiz4View.frame;
//        rect.size.height = 100;
//        [quiz4View setFrame:rect];
        [comboBtn4 sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    [combotalbe4.layer setBorderColor:[UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0].CGColor];
    [combotalbe4.layer setBorderWidth:2];
}


- (IBAction)clickedcombo5Btn:(id)sender
{
    if(isOpendCombobox4||isOpendCombobox3 || isOpendCombobox2 || isOpendCombobox1)
    {
        return;
    }
    if (isOpendCombobox5)
    {
        _quizHeightConstraint5.constant = 100;
        
        [UIView animateWithDuration:0.5 animations:^
         {
             [self.view layoutIfNeeded];
             
             CGRect frame = combotalbe5.frame;
             frame.size.height = 0;
             [combotalbe5 setFrame:frame];
         }
                         completion:^(BOOL finished)
         {
             isOpendCombobox5 = NO;
         }];
    }
    else
    {
        _quizHeightConstraint5.constant = 160;
        
        [UIView animateWithDuration:0.5 animations:^
         {
             [self.view layoutIfNeeded];
             
             CGRect frame = combotalbe5.frame;
             frame.size.height = 60;
             [combotalbe5 setFrame:frame];
         }
                         completion:^(BOOL finished)
         {
             isOpendCombobox5 = YES;
         }];
    }
}

- (IBAction)clickedcombo4Btn:(id)sender
{
    if(isOpendCombobox5||isOpendCombobox3 || isOpendCombobox2 || isOpendCombobox1)
    {
        return;
    }
    if (isOpendCombobox4)
    {
        _quizHeightConstraint4.constant = 100;
        
        [UIView animateWithDuration:0.5 animations:^
         {
             [self.view layoutIfNeeded];
             
             CGRect frame = combotalbe4.frame;
             frame.size.height = 0;
             [combotalbe4 setFrame:frame];
         }
                         completion:^(BOOL finished)
         {
             isOpendCombobox4 = NO;
         }];
    }
    else
    {
        _quizHeightConstraint4.constant = 220;
        
        [UIView animateWithDuration:0.5 animations:^
         {
             [self.view layoutIfNeeded];
             
             CGRect frame = combotalbe4.frame;
             frame.size.height = 120;
             [combotalbe4 setFrame:frame];
         }
                         completion:^(BOOL finished)
         {
             isOpendCombobox4 = YES;
         }];
    }
}

- (IBAction)clickedcombo3Btn:(id)sender
{
    if(isOpendCombobox5||isOpendCombobox4 || isOpendCombobox2 || isOpendCombobox1)
    {
        return;
    }
    if (isOpendCombobox3)
    {
        _quizHeightConstraint3.constant = 100;
        
        [UIView animateWithDuration:0.5 animations:^
         {
             [self.view layoutIfNeeded];
             
             CGRect frame = combotalbe3.frame;
             frame.size.height = 0;
             [combotalbe3 setFrame:frame];
         }
                         completion:^(BOOL finished)
         {
             isOpendCombobox3 = NO;
         }];
    }
    else
    {
        _quizHeightConstraint3.constant = 220;
        
        [UIView animateWithDuration:0.5 animations:^
         {
             [self.view layoutIfNeeded];
             
             CGRect frame = combotalbe3.frame;
             frame.size.height = 120;
             [combotalbe3 setFrame:frame];
         }
                         completion:^(BOOL finished)
         {
             isOpendCombobox3 = YES;
         }];
    }
}

- (IBAction)clickedcombo2Btn:(id)sender
{
    if(isOpendCombobox5||isOpendCombobox4 || isOpendCombobox3 || isOpendCombobox1)
    {
        return;
    }
    if (isOpendCombobox2)
    {
        _quizHeightConstraint2.constant = 100;
        
        [UIView animateWithDuration:0.5 animations:^
         {
             [self.view layoutIfNeeded];
             
             CGRect frame = combotalbe2.frame;
             frame.size.height = 0;
             [combotalbe2 setFrame:frame];
         }
                         completion:^(BOOL finished)
         {
             isOpendCombobox2 = NO;
         }];
    }
    else
    {
        _quizHeightConstraint2.constant = 220;
        
        [UIView animateWithDuration:0.5 animations:^
         {
             [self.view layoutIfNeeded];
             
             CGRect frame = combotalbe2.frame;
             frame.size.height = 120;
             [combotalbe2 setFrame:frame];
         }
                         completion:^(BOOL finished)
         {
             isOpendCombobox2 = YES;
         }];
    }
}

- (IBAction)clickedcombo1Btn:(id)sender
{
    if(isOpendCombobox5||isOpendCombobox4 || isOpendCombobox3 || isOpendCombobox2)
    {
        return;
    }
    if (isOpendCombobox1)
    {
        _quizHeightConstraint1.constant = 100;
        
        [UIView animateWithDuration:0.5 animations:^
        {
            [self.view layoutIfNeeded];
            
            CGRect frame = combotalbe1.frame;
            frame.size.height = 0;
            [combotalbe1 setFrame:frame];
        }
                         completion:^(BOOL finished)
        {
            isOpendCombobox1 = NO;
        }];
    }
    else
    {
        _quizHeightConstraint1.constant = 220;
        
        [UIView animateWithDuration:0.5 animations:^
        {
            [self.view layoutIfNeeded];
            
            CGRect frame = combotalbe1.frame;
            frame.size.height = 120;
            [combotalbe1 setFrame:frame];
        }
                         completion:^(BOOL finished)
        {
            isOpendCombobox1 = YES;
        }];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//just for test
- (IBAction)testButtonTapped:(UIButton *)sender
{
    comboText1.text = @"between 3 and 5";
    comboText2.text = @"2-4";
    comboText3.text = @"2-4";
    comboText4.text = @"Sometimes";
    comboText5.text = @"YES";
}


- (IBAction)clickSaveBtn:(id)sender
{
    ///sum
    [SVProgressHUD showWithStatus:@"Saving..." maskType:SVProgressHUDMaskTypeBlack];
    combo1String=[self getCombo1:self.comboText1.text];
    combo2String=[self getCombo2_3:self.comboText2.text];
    combo3String=[self getCombo2_3:self.comboText3.text];
    combo4String=[self getCombo4:self.comboText4.text];
    combo5String=[self getCombo5:self.comboText5.text];
  
    
    SessionManager *manager = [SessionManager sharedManager];
    NSDictionary *parameters = @{@"combo1":combo1String,@"combo2":combo2String,@"combo3":combo3String,@"combo4":combo4String,@"combo5":combo5String};
    
    [manager POST:@"v1/healthAssessmentLifestyle" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD popActivity];
        
        [badgeButton setTitle:[NSString stringWithFormat:@"%d%%",[self getcompletionRate]] forState:UIControlStateNormal];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error.."
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        [SVProgressHUD dismiss];
        
    }];
    

}

-(int)getcompletionRate
{
    compleationrate = 0;
    if (![comboText1.text isEqualToString:@""]) {
        compleationrate=compleationrate+20;
    }
    if (![comboText2.text isEqualToString:@""]) {
        compleationrate=compleationrate+20;
    }
    if (![comboText3.text isEqualToString:@""]) {
        compleationrate=compleationrate+20;
    }
    if (![comboText4.text isEqualToString:@""]) {
        compleationrate=compleationrate+20;
    }
    if (![comboText5.text isEqualToString:@""]) {
        compleationrate=compleationrate+20;
    }
       return compleationrate;
}

-(NSString*)setCombo1:(NSString*) value
{
    if(value == (id)[NSNull null])
    {
        return @"";
    }
    if ([value isEqualToString:@"MORE_THAN_5"]) {
        return @"More than 5";
        
    }else if([value isEqualToString:@"BETWEEN_3_TO_5"]){
        return @"between 3 and 5";
    }else if([value isEqualToString:@"BETWEEN_1_TO_3"]){
        return @"between 1 and 3";
    }else if([value isEqualToString:@"I_DONT_EXCERCISE_AT_ALL"]){
        return @"I don't exercise at all";
    }
    return  @"";
}

-(NSString*)setCombo2_3:(NSString*) value
{
    if(value == (id)[NSNull null])
    {
        return @"";
    }
    
    if ([value isEqualToString:@"ZERO_TO_TWO"]) {
        return @"0-2";
        
    }else if([value isEqualToString:@"TWO_TO_FOUR"]){
        return @"2-4";
    }else if([value isEqualToString:@"FOUR_TO_SIX"]){
        return @"4-6";
    }
    else if([value isEqualToString:@"MORE_THAN_SIX"]){
        return @"more than 6";
    }
    return  @"";
}


-(NSString*)setCombo4:(NSString*) value
{
    if(value == (id)[NSNull null])
    {
        return @"";
    }
    
    if ([value isEqualToString:@"NEVER"]) {
        return @"Never";
        
    }else if([value isEqualToString:@"SOMETIMES"]){
        return @"Sometimes";
    }else if([value isEqualToString:@"OFTEN"]){
        return @"Often";
    }
    else if([value isEqualToString:@"ALWAYS"]){
        return @"Always";
    }
    return  @"";
}
-(NSString*)setCombo5:(NSString*) value
{
    if(value == (id)[NSNull null])
    {
        return @"";
    }
    
    if ([value isEqualToString:@"YES"]) {
        return @"YES";
        
    }else if([value isEqualToString:@"NO"]){
        return @"NO";
    }
    return  @"";
}



-(NSString*) getCombo1:(NSString*) value
{
    if ([value isEqualToString:@"More than 5"]) {
        return @"MORE_THAN_5";
    }else if([value isEqualToString:@"between 3 and 5"]){
        return @"BETWEEN_3_TO_5";
    }else if([value isEqualToString:@"between 1 and 3"]){
        return @"BETWEEN_1_TO_3";
    }else if([value isEqualToString:@"I don't exercise at all"]){
        return @"I_DONT_EXCERCISE_AT_ALL";
    }
    return  @"";
}

-(NSString*) getCombo2_3:(NSString*) value
{
    if ([value isEqualToString:@"0-2"]) {
        return @"ZERO_TO_TWO";
    }else if([value isEqualToString:@"2-4"]){
        return @"TWO_TO_FOUR";
    }else if([value isEqualToString:@"4-6"]){
        return @"FOUR_TO_SIX";
    }
    else if([value isEqualToString:@"more than 6"]){
        return @"MORE_THAN_SIX";
    }
    return  @"";
}
-(NSString*) getCombo4:(NSString*) value
{
    if ([value isEqualToString:@"Never"]) {
        return @"NEVER";
    }else if([value isEqualToString:@"Sometimes"]){
        return @"SOMETIMES";
    }else if([value isEqualToString:@"Often"]){
        return @"OFTEN";
    }
    else if([value isEqualToString:@"Always"]){
        return @"ALWAYS";
    }
    return  @"";
}
-(NSString*) getCombo5:(NSString*) value
{
    if ([value isEqualToString:@"YES"]) {
        return @"YES";
    }else if([value isEqualToString:@"NO"]){
        return @"NO";
    }
    return  @"";
}
@end
