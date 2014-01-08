//
//  ViewController.m
//  SlotMachineGame
//
//  Created by Jinho Son on 2014. 1. 7..
//  Copyright (c) 2014년 STD1. All rights reserved.
//

#import "ViewController.h"

#define IMAGE_COMPONENT_NUM 100

@interface ViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UILabel *remainAmountField;
@property (weak, nonatomic) IBOutlet UILabel *betingAmountField;
@property (weak, nonatomic) IBOutlet UILabel *statusField;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController
{
    int myMoney;
    int betingAmount;
}

- (IBAction)spinButton:(id)sender
{
    int comp1 = arc4random() % IMAGE_COMPONENT_NUM;
    int comp2 = arc4random() % IMAGE_COMPONENT_NUM;
    int comp3 = arc4random() % IMAGE_COMPONENT_NUM;
    
    [self.picker selectRow:comp1 inComponent:0 animated:YES];
    [self.picker selectRow:comp2 inComponent:1 animated:YES];
    [self.picker selectRow:comp3 inComponent:2 animated:YES];
    
    comp1 = comp1 % (IMAGE_COMPONENT_NUM/10) + 1;
    comp2 = comp2 % (IMAGE_COMPONENT_NUM/10) + 1;
    comp3 = comp3 % (IMAGE_COMPONENT_NUM/10) + 1;
    
    if (comp1==comp2 && comp1==comp3)
    {
        myMoney = myMoney + betingAmount*100 - betingAmount;
        
        self.statusField.text = [NSString stringWithFormat:@"Bound2: %d을 땃습니다.", betingAmount*100];
    }
    else if (comp1==comp2 || comp1==comp3 || comp2==comp3)
    {
        myMoney = myMoney + betingAmount*10 - betingAmount;
        self.statusField.text = [NSString stringWithFormat:@"Bound1: %d을 땃습니다.", betingAmount*10];
    }
    else
    {
        if (myMoney <= betingAmount)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:@"다시 게임하겠습니까?"
                                                           delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
            alert.tag = 99;
            [alert show];
            
        }
        else
        {
            myMoney -= betingAmount;
            self.statusField.text = @"실패했습니다.";
        }
    }
    self.statusField.textColor = [UIColor redColor];
    
    self.remainAmountField.text = [NSString stringWithFormat:@"%d", myMoney];
}

// 게임재식작 여부를 판단
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.firstOtherButtonIndex == buttonIndex)
    {
        [self newGame];
    }
    else
    {
        myMoney = 0;
        self.remainAmountField.text = [NSString stringWithFormat:@"%d", myMoney];
        self.remainAmountField.textColor = [UIColor yellowColor];
        
        self.button.enabled = NO;
        
    }
}

- (IBAction)selectBetingAmount:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 1)
    {
        betingAmount = 10;
    }
    else if(button.tag == 2)
    {
        betingAmount = 50;
    }
    else
    {
        betingAmount = 100;
    }
    
    self.betingAmountField.text = [NSString stringWithFormat:@"%d", betingAmount];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return IMAGE_COMPONENT_NUM;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 64;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSString *imagePath = [NSString stringWithFormat:@"flag%d", row % (IMAGE_COMPONENT_NUM/10) + 1];
    UIImage *image = [UIImage imageNamed:imagePath];
    UIImageView *imageView;
    
    if (view == nil)
    {
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, 75, 45);
    }
    else
    {
        imageView = (UIImageView *)view;
        imageView.image = image;
    }
    
    return imageView;
}
- (IBAction)clickNewGame:(id)sender
{
    [self newGame];
}

// 게임에 필요한 초기치를 설정한다
- (void)newGame
{
    int comp1 = arc4random() % IMAGE_COMPONENT_NUM;
    int comp2 = arc4random() % IMAGE_COMPONENT_NUM;
    int comp3 = arc4random() % IMAGE_COMPONENT_NUM;
    
    [self.picker selectRow:comp1 inComponent:0 animated:YES];
    [self.picker selectRow:comp2 inComponent:1 animated:YES];
    [self.picker selectRow:comp3 inComponent:2 animated:YES];
    
    myMoney = 500;
    self.remainAmountField.text = [NSString stringWithFormat:@"%d", myMoney];
    self.remainAmountField.textColor = [UIColor yellowColor];
    
    betingAmount = 10;
    self.betingAmountField.text = [NSString stringWithFormat:@"%d", betingAmount];
    
    self.statusField.text = @"";
    self.button.enabled = YES;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.button.enabled = NO;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
