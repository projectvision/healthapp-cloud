//
//  DemographicsViewController.m
//  Health
//
//  Created by Yuan on 1/27/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#import "DemographicsViewController.h"
#import "UITableView+DataSourceBlocks.h"
#import "TableViewWithBlock.h"
#import "SelectionCell.h"
#import "SVProgressHUD.h"
#import "SessionManager.h"
#import "Utility.h"

@interface DemographicsViewController ()
{
        BOOL isOpendCombobox1;
        NSArray *comboString1;
        BOOL isOpendCombobox2;
        NSArray *comboString2;
        BOOL isOpendCombobox3;
        NSArray *comboString3;
        BOOL isEdit;
    BOOL isUpdated;
    PFObject *obj;
    NSString  *ethincityString, *genderString;
    int compleationrate;
   IBOutlet UIButton *badgeButton;
}

@property (nonatomic, strong) NSDateFormatter *dateFormatter;


@end

@implementation DemographicsViewController
@synthesize demographics;
@synthesize comboText1,combotable1,comboBtn1,comboBtn2,combotable2,comboText2,comboBtn3,combotable3,comboText3,weightTextField,heightTextField,scrollView,saveButton,mrnTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationController.navigationBar.translucent=YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isUpdated = NO;

    _contentWidthConstraint.constant = [UIScreen mainScreen].bounds.size.width;
    
    scrollView.delegate = self;
    _surnameTextField.delegate=self;
    
    [self initBadgeButton];
    [self loadData];
    self.title = @"HEALTH ASSESSMENT";
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]init];
    barButton.title = @"";
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
//    self.navigationController.navigationBar.translucent = NO;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];    // show short-style date format
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
   
  
    bornTextField.enabled = NO;
    isOpenedCalendarView = NO;
    
    [self combobox1Init];
    [self combobox2Init];

    saveButton.buttonColor = [UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0];
    saveButton.highlightedColor = [UIColor colorWithRed:59.0f/255.0f green:173.0f/255.0f blue:213.0f/255.0f alpha:1.0];
    [saveButton setCornerRadius:5.0f];
    
    weightTextField.delegate = self;
    heightTextField.delegate = self;
   _waistTextField.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer *swipeGestureOptionView = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    swipeGestureOptionView.direction=UISwipeGestureRecognizerDirectionDown;
    [self.scrollView addGestureRecognizer:swipeGestureOptionView];
    [scrollView setUserInteractionEnabled:YES];
    isEdit = NO;
}

-(void)loadData
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    SessionManager *manager = [SessionManager sharedManager];
    NSDictionary *parameters = @{};
    
    [manager GET:@"v1/healthAssessmentDemographics" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        self.demographics = (NSDictionary *)responseObject;
        if([self.demographics count]>0)
        {
            [self showInfor];
            [SVProgressHUD dismiss];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSDictionary *json=[NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:nil error:nil];
        
        [SVProgressHUD dismiss];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[json valueForKey:@"message"]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];

    
}

-(void)showInfor
{
    NSString *datestring = [self.demographics valueForKey:@"dob"];
    if(datestring != (id)[NSNull null])
    {
      NSString *newdate = [datestring substringToIndex:10];
        bornTextField.text =newdate;
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *dd = [self.dateFormatter dateFromString:newdate];
       [self->pickerView setDate:dd];

    }
   
    _nameTextField.text = [self setfirstName_lastName_Mrn:[self.demographics valueForKey:@"firstName"]];
   _surnameTextField.text =[self setfirstName_lastName_Mrn:[self.demographics valueForKey:@"lastName"]];
    comboText1.text = [self setEthnicity:[self.demographics valueForKey:@"ethnicity"]];
    comboText2.text = [self setGender:[self.demographics valueForKey:@"gender"]];
    
    mrnTextField.text = [self setfirstName_lastName_Mrn:[self.demographics valueForKey:@"mrn"]];
    
    heightTextField.text = [self setHeight_OR_Weight_OR_Waist_Circumference:[[self.demographics valueForKey:@"height"]integerValue]];
    weightTextField.text = [self setHeight_OR_Weight_OR_Waist_Circumference:[[self.demographics valueForKey:@"weight"]integerValue]];
    _waistTextField.text = [self setHeight_OR_Weight_OR_Waist_Circumference:[[self.demographics valueForKey:@"waistCircumference"]integerValue]];
    
    for (UIButton *button in _bodyShapeButtons)
    {
        int tag=[button tag];
        
        if([self.demographics valueForKey:@"somatoType"]== [NSNull null])
        {
            return;
        }
        if (button.tag ==1)
        {
            if([[self.demographics valueForKey:@"somatoType"] isEqualToString:@"ECTOMORPH"])
            {
            button.selected = YES;
            button.alpha = 1.0f;
            }
        }
        if (button.tag ==2)
        {
            if([[self.demographics valueForKey:@"somatoType"] isEqualToString:@"ENDOMORPH"])
            {
                button.selected = YES;
                button.alpha = 1.0f;
            }
        }
        
        if (button.tag ==3)
        {
            if([[self.demographics valueForKey:@"somatoType"] isEqualToString:@"MESOMORPH"])
            {
                button.selected = YES;
                button.alpha = 1.0f;
            }
        }
    }

    [badgeButton setTitle:[NSString stringWithFormat:@"%@%%",[self.demographics valueForKey:@"completionPercentage"]]forState:UIControlStateNormal];
}

- (void) initBadgeButton
{
    [badgeButton setBackgroundImage:[[UIImage imageNamed:@"ico_badge.png"] stretchableImageWithLeftCapWidth:9 topCapHeight:9] forState:UIControlStateNormal];
    
    [badgeButton setTitle:[NSString stringWithFormat:@"%d%%", 0] forState:UIControlStateNormal];
    
    [badgeButton sizeToFit];
    
    CGRect badgeRect = badgeButton.frame;
    CGSize badgeSize = badgeRect.size;
    CGSize newSize = CGSizeMake(badgeSize.width + 15, badgeSize.height + 3);
    badgeRect.size = newSize;
    
    badgeButton.frame = badgeRect;
}

-(void)hideKeyboard
{
    if (isEdit)
    {

        [heightTextField resignFirstResponder];
        [weightTextField resignFirstResponder];
        [_waistTextField resignFirstResponder];
        
        isEdit=NO;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.35];
        CGRect frame = scrollView.frame;
        frame.origin.y=45;
        [scrollView setFrame:frame];
        [UIView commitAnimations];
    }
    [_surnameTextField resignFirstResponder];
    [_nameTextField resignFirstResponder];
    [mrnTextField resignFirstResponder];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35];
    CGRect frame = scrollView.frame;
    frame.origin.y=45;
    [scrollView setFrame:frame];
    [UIView commitAnimations];
    
    if (isOpenedCalendarView)
    {
        [self clickedCalendarBtn:nil];
    }
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    isEdit = YES;
    /*if (textField.tag == 1)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.35];
        CGRect frame = scrollView.frame;
        frame.origin.y = -55;
        [scrollView setFrame:frame];
        [UIView commitAnimations];
    }
    else if (textField.tag == 2)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.35];
        CGRect frame = scrollView.frame;
        frame.origin.y = -100;
        [scrollView setFrame:frame];
        [UIView commitAnimations];
    }
    else*/ if (textField.tag == 3)
    {
        /*[UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.35];
        CGRect frame = scrollView.frame;
        frame.origin.y = -155;
        [scrollView setFrame:frame];
        [UIView commitAnimations];*/
        [scrollView scrollToActiveTextField];
    }
}
- (BOOL) textFieldShouldReturn:(UITextField*)textField
{
    if([_surnameTextField isFirstResponder])
    {
    [_surnameTextField resignFirstResponder];
    return YES;
    }
    return NO;
}
-(void)combobox2Init
{
    comboString2 = [NSArray arrayWithObjects:@"male",@"female",@"other", nil];
    isOpendCombobox2 = NO;
    comboText2.enabled = NO;
    [combotable2 initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section)
    {
        NSInteger n=[comboString2 count];
        return n;
    }
                           setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath)
    {
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
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
        
        int gender = [cell.lb.text isEqualToString:@"female"] ? 2 : 1;
        for (UIButton *button in _bodyShapeButtons)
        {
            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d_%ld", gender, (long)button.tag]] forState:UIControlStateNormal];
        }
        
        [comboBtn2 sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    [combotable2.layer setBorderColor:[UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0].CGColor];
    [combotable2.layer setBorderWidth:2];
    
}
-(void)combobox1Init
{
    comboString1 = [NSArray arrayWithObjects:@"Asian/Pacific Islander",@"Black",@"White",@"Hispanic(white)",@"Hispanic(non-white)", @"Not disclosing",nil];
    isOpendCombobox1 = NO;
    comboText1.enabled = NO;
    [combotable1 initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section)
    {
        NSInteger n=[comboString1 count];
        return n;  
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        [cell.lb setText:comboString1[indexPath.row]];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath)
    {
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        comboText1.text=cell.lb.text;
        [comboBtn1 sendActionsForControlEvents:UIControlEventTouchUpInside];
        //
        
        
    }];
    
    [combotable1.layer setBorderColor:[UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0].CGColor];
    [combotable1.layer setBorderWidth:2];
    
}
//- (IBAction)clickedcombo3Btn:(id)sender {
//    if (isOpendCombobox3) {
//        isOpendCombobox3=NO;
//        
//        
//        
//        [UIView animateWithDuration:0.5 animations:^{
//            //            UIImage *closeImage=[UIImage imageNamed:@"dropdown.png"];
//            //            [_countryOptionBtn setImage:closeImage forState:UIControlStateNormal];
//            
//            
//            CGRect frame=combotable3.frame;
//            
//            frame.size.height=1;
//            frame.origin.y = frame.origin.y+90;
//            [combotable3 setFrame:frame];
//            
//        } completion:^(BOOL finished){
//            
//            
//        }];
//    }else{
//        
//        isOpendCombobox3=YES;
//        [UIView animateWithDuration:0.5 animations:^{
//            //            UIImage *openImage=[UIImage imageNamed:@"dropup.png"];
//            //            [_countryOptionBtn setImage:openImage forState:UIControlStateNormal];
//            
//            CGRect frame=combotable3.frame;
//            
//            frame.size.height=90;
//            frame.origin.y = frame.origin.y-90;
//            [combotable3 setFrame:frame];
//        } completion:^(BOOL finished){
//            
//            
//        }];
//        
//        
//    }
//    
//}

- (IBAction)clickedcombo2Btn:(id)sender {
    if (isOpendCombobox2) {
        
        
        
        [UIView animateWithDuration:0.5 animations:^{
            //            UIImage *closeImage=[UIImage imageNamed:@"dropdown.png"];
            //            [_countryOptionBtn setImage:closeImage forState:UIControlStateNormal];
            
            
            CGRect frame=combotable2.frame;
            
            frame.size.height=0;
            [combotable2 setFrame:frame];
            
        } completion:^(BOOL finished){
            
            isOpendCombobox2=NO;
        }];
    }else{
        
        
        [UIView animateWithDuration:0.5 animations:^{
            //            UIImage *openImage=[UIImage imageNamed:@"dropup.png"];
            //            [_countryOptionBtn setImage:openImage forState:UIControlStateNormal];
            
            CGRect frame=combotable2.frame;
            
            frame.size.height=90;
            [combotable2 setFrame:frame];
        } completion:^(BOOL finished){
            
            isOpendCombobox2=YES;
        }];
        
        
    }

}
- (IBAction)clickedcombo1Btn:(id)sender
{
    if (isOpendCombobox1)
    {
        [UIView animateWithDuration:0.5 animations:^
        {
            //            UIImage *closeImage=[UIImage imageNamed:@"dropdown.png"];
            //            [_countryOptionBtn setImage:closeImage forState:UIControlStateNormal];
            CGRect frame=combotable1.frame;
            frame.size.height=0;
            [combotable1 setFrame:frame];
        }
                         completion:^(BOOL finished)
        {
            isOpendCombobox1=NO;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^
        {
            //            UIImage *openImage=[UIImage imageNamed:@"dropup.png"];
            //            [_countryOptionBtn setImage:openImage forState:UIControlStateNormal];
            CGRect frame=combotable1.frame;
            frame.size.height=180;
            frame.size.width=190;
            [combotable1 setFrame:frame];
        }
                         completion:^(BOOL finished)
        {
            isOpendCombobox1=YES;
        }];
        
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickedCalendarBtn:(id)sender
{
    [self.view layoutIfNeeded];
    
    if (isOpenedCalendarView)
    {
        [UIView animateWithDuration:0.5 animations:^
        {

            _calendarViewConstraint.constant = -162;
            [self.view layoutIfNeeded];
        }
                         completion:^(BOOL finished)
        {
            isOpenedCalendarView = NO;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^
        {
            _calendarViewConstraint.constant = 0;
            [self.view layoutIfNeeded];
        }
                         completion:^(BOOL finished)
        {
            isOpenedCalendarView = YES;
        }];
    }
}

- (IBAction)ChangedDate:(id)sender
{
    UIDatePicker *targetedDatePicker=sender;
    targetedDatePicker.maximumDate=[NSDate date];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];

    bornTextField.text = [self.dateFormatter stringFromDate:targetedDatePicker.date];
}



- (IBAction)clickedSaveBtn:(id)sender
{
    
    NSString *firstname = _nameTextField.text;
    NSString *lastname= _surnameTextField.text;
    NSString *dob=bornTextField.text;
    NSString *mrn=mrnTextField.text;
    NSNumber *height = @([heightTextField.text intValue]);
    NSNumber *weight= @([weightTextField.text intValue]);
    NSNumber *waist = @([_waistTextField.text intValue]);
    
    if (firstname.length == 0 ) {
        
        [_nameTextField becomeFirstResponder];
        return;
    }
    if(![Utility isValidName:firstname])
        
    {
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter name in valid format" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alertview show];
                return;
    }
    
    if (lastname.length == 0 ) {
        
        [_surnameTextField becomeFirstResponder];
        return;
    }
    if(![Utility isValidName:lastname])
        
    {
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter lastName in valid format" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alertview show];
       
        return;
    }
    
if ([height intValue]>999) {
        
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Height should not be more than 3 digits" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alertview show];
        
        return;
    }
   if ([weight intValue]>999 ) {
       
       UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Weight should not be more than 3 digits" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
       [alertview show];
       
       return;
   }
   if ([waist intValue]>999 ) {
       
       UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Weist size should not be more than 3 digits" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
       [alertview show];
       
       return;
   }
  
    [SVProgressHUD showWithStatus:@"Saving..." maskType:SVProgressHUDMaskTypeBlack];

    ethincityString=[self getEthnicity:self.comboText1.text];
    genderString=[self getGender:self.comboText2.text];
    NSString *somatoString=[self getSomatoType];
    SessionManager *manager = [SessionManager sharedManager];
    NSDictionary *parameters = @{@"firstName":firstname,@"lastName":lastname,@"dobAsISO8601String":dob,@"mrn":mrn,@"ethnicity":ethincityString,@"gender":genderString,@"height":height,@"weight":weight,@"waistCircumference":waist,@"somatoType":somatoString};
    
    [manager POST:@"v1/healthAssessmentDemographics" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
    
        [SVProgressHUD dismiss];
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
    
    if (![_nameTextField.text isEqualToString:@""]) {
        compleationrate=compleationrate+10;
    }
    if (![_surnameTextField.text isEqualToString:@""]) {
        compleationrate=compleationrate+10;
    }
    
    if (![bornTextField.text isEqualToString:@""]) {
        compleationrate=compleationrate+10;
    }
    
    if (![mrnTextField.text isEqualToString:@""]) {
        compleationrate=compleationrate+10;
    }
    
    if (![comboText1.text isEqualToString:@""]) {
        compleationrate=compleationrate+10;
    }
    if (![comboText2.text isEqualToString:@""]) {
        compleationrate=compleationrate+10;
    }
    if (![heightTextField.text isEqualToString:@""]) {
        compleationrate=compleationrate+10;
    }
    
    if (![_waistTextField.text isEqualToString:@""])
    {
        compleationrate = compleationrate+10;
    }
    
    if (![weightTextField.text isEqualToString:@""]) {
        compleationrate=compleationrate+10;
    }
    
    for (UIButton *button in _bodyShapeButtons)
    {
        if (button.selected)
        {
            compleationrate = compleationrate + 10;
            break;
        }
    }
    
    return compleationrate;
}

-(IBAction)bodyShapeButtonTapped:(UIButton *)sender
{
    if (!sender.selected)
    {
        sender.selected = !sender.selected;
        sender.alpha = 1.0f;

        for (UIButton *button in _bodyShapeButtons)
        {
            if (sender.tag != button.tag)
            {
                button.selected = NO;
                button.alpha = 0.2f;
            }
        }
    }
}



-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (isOpenedCalendarView)
    {
        [self clickedCalendarBtn:nil];
    }
}

-(NSString*)setEthnicity:(NSString*) value
{
    if(value == (id)[NSNull null])
    {
        return @"";
    }
    if ([value isEqualToString:@"ASIAN_PASIFIC_ISLANDER"]) {
        return @"Asian/Pacific Islander";
        
    }else if([value isEqualToString:@"BLACK"]){
        return @"Black";
    }else if([value isEqualToString:@"WHITE"]){
        return @"White";
    }else if([value isEqualToString:@"HISPANIC_WHITE"]){
        return @"Hispanic(white)";
    }else if([value isEqualToString:@"HISPANIC_NON_WHITE"]){
        return @"Hispanic(non-white)";
    }
    else if([value isEqualToString:@"NOT_DISCLOSING"]){
        return @"Not disclosing";
    }
    return  @"";
}
-(NSString*)setGender:(NSString*) value
{
    if(value == (id)[NSNull null])
    {
        return @"";
    }
    if ([value isEqualToString:@"MALE"]) {
        return @"male";
        
    }else if([value isEqualToString:@"FEMALE"]){
        return @"female";
    }
    else if([value isEqualToString:@"OTHER"]){
        return @"other";
    }
    return  @"";
}
-(NSString*)setfirstName_lastName_Mrn:(NSString*) value
{
    if(value == (id)[NSNull null])
    {
        return @"";
    }
    else {
        return value;
        
    }
}
-(NSString*)setHeight_OR_Weight_OR_Waist_Circumference:(int) value
{
    if(value == (id)[NSNull null])
    {
        return @"";
    }
 else {
     NSString *myString;
     myString = [NSString stringWithFormat:@"%d", value];
     return myString;
        
    }
}
-(NSString*)setSomatoType:(NSString*) value
{
    if(value == (id)[NSNull null])
    {
        return @"";
    }
    if ([value isEqualToString:@"MESOMORPH"]) {
        return @"mesomorph";
        
    }else if([value isEqualToString:@"ENDOMORPH"]){
        return @"endomorph";
    }
    else if([value isEqualToString:@"ECTOMORPH"]){
        return @"ectomorph";
    }
return @"";
}
-(NSString*)getEthnicity:(NSString*) value
{
    if(value == (id)[NSNull null])
    {
        return @"";
    }
    if ([value isEqualToString:@"Asian/Pacific Islander"]) {
        return @"ASIAN_PASIFIC_ISLANDER";
        
    }else if([value isEqualToString:@"Black"]){
        return @"BLACK";
    }else if([value isEqualToString:@"White"]){
        return @"WHITE";
    }else if([value isEqualToString:@"Hispanic(white)"]){
        return @"HISPANIC_WHITE";
    }else if([value isEqualToString:@"Hispanic(non-white)"]){
        return @"HISPANIC_NON_WHITE";
    }
    else if([value isEqualToString:@"Not disclosing"]){
        return @"NOT_DISCLOSING";
    }
    return  @"";
}
-(NSString*)getGender:(NSString*) value
{
    if ([value isEqualToString:@"male"]) {
        return @"MALE";
        
    }else if([value isEqualToString:@"female"]){
        return @"FEMALE";
    }
    else if([value isEqualToString:@"other"]){
        return @"OTHER";
    }
    return  @"";
}

-(NSString*)getSomatoType
{
    for (UIButton *button in _bodyShapeButtons)
    {
        if (button.selected)
        {
            if(button.tag==1)
            {
                return @"ECTOMORPH";
            }
            if(button.tag==2)
            {
                return @"ENDOMORPH";
            }
            if(button.tag==3)
            {
                return @"MESOMORPH";
            }
        }
    }
    return @"";
}



@end
