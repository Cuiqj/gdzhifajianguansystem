

#import "SRYearQuarterPicker.h"

#define MONTH_ROW_MULTIPLIER 340
#define DEFAULT_MINIMUM_YEAR 1
#define DEFAULT_MAXIMUM_YEAR 99999


@interface SRYearQuarterPicker()

@property (nonatomic) int quarterComponent;
@property (nonatomic) int yearComponent;
@property (nonatomic, readonly) NSArray* quarterStrings;

-(int)yearFromRow:(NSUInteger)row;
-(NSUInteger)rowFromYear:(int)year;

@end

@implementation SRYearQuarterPicker

@synthesize yearStr	= _yearStr;
@synthesize quarterStr = _quarterStr;
@synthesize quarterStrings = _quarterStrings;
@synthesize yearQuarterPickerDelegate = _yearQuarterPickerDelegate;

-(id)initWithDate:(NSDate *)date
{
    self = [super init];
    
    if (self)
    {
        [self prepare];
    }
    
    return self;
}

-(id)init
{
    self = [self initWithDate:[NSDate date]];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self prepare];
        if (!_yearStr){
			NSDate *currentDate = [NSDate date];
			NSCalendar* calendar = [NSCalendar currentCalendar];
			NSDateComponents* components = [calendar components:NSYearCalendarUnit fromDate:currentDate]; // Get necessary date components
			_yearStr = [NSString stringWithFormat:@"%d",[components year] ];
			[self selectRow:[self rowFromYear:[components year]] inComponent:0 animated:NO];
		}
		if(!_quarterStr)
			_quarterStr = [self.quarterStrings objectAtIndex:0];
		 int monthMidpoint = self.quarterStrings.count * (MONTH_ROW_MULTIPLIER / 2);
		[self selectRow:0 + monthMidpoint inComponent:1 animated:NO];
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self prepare];
        if (!_yearStr){
			NSDate *currentDate = [NSDate date];
			NSCalendar* calendar = [NSCalendar currentCalendar];
			NSDateComponents* components = [calendar components:NSYearCalendarUnit fromDate:currentDate]; // Get necessary date components
			_yearStr = [NSString stringWithFormat:@"%d",[components year] ];
		}
		if(!_quarterStr)
			_quarterStr = [self.quarterStrings objectAtIndex:0];
    }
    
    return self;
}

-(void)prepare
{
    self.dataSource = self;
    self.delegate = self;

}

-(id<UIPickerViewDelegate>)delegate
{
    return self;
}

-(void)setDelegate:(id<UIPickerViewDelegate>)delegate
{
    if ([delegate isEqual:self])
        [super setDelegate:delegate];
}

-(id<UIPickerViewDataSource>)dataSource
{
    return self;
}

-(void)setDataSource:(id<UIPickerViewDataSource>)dataSource
{
    if ([dataSource isEqual:self])
        [super setDataSource:dataSource];
}

-(int)monthComponent
{
    return self.yearComponent ^ 1;
}



-(NSArray *)quarterStrings
{
    return @[@"1-3月",@"1-6月",@"1-9月",@"1-12月" ];
}



-(void)setMinimumYear:(NSNumber *)minimumYear
{
	

    
    if (minimumYear && [_yearStr integerValue] < minimumYear.integerValue)
        _yearStr = [NSString stringWithFormat:@"%d",minimumYear.integerValue ];
    
	
    _minimumYear = minimumYear;
    [self reloadAllComponents];

}

-(void)setMaximumYear:(NSNumber *)maximumYear
{
	
    if (maximumYear && [_yearStr integerValue] > maximumYear.integerValue)
        _yearStr = [NSString stringWithFormat:@"%d",maximumYear.integerValue ];
    
    _maximumYear = maximumYear;
    [self reloadAllComponents];

}



-(int)yearFromRow:(NSUInteger)row
{
    int minYear = DEFAULT_MINIMUM_YEAR;
    
    if (self.minimumYear)
        minYear = self.minimumYear.integerValue;
    
    return row + minYear;
}

-(NSUInteger)rowFromYear:(int)year
{
    int minYear = DEFAULT_MINIMUM_YEAR;
    
    if (self.minimumYear)
        minYear = self.minimumYear.integerValue;
    
    return year - minYear;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	_yearStr = [NSString stringWithFormat:@"%i",[self yearFromRow:[self selectedRowInComponent:self.yearComponent]]];
    _quarterStr = [self.quarterStrings objectAtIndex:([self selectedRowInComponent:1] % self.quarterStrings.count)];
        
    if ([self.yearQuarterPickerDelegate respondsToSelector:@selector(yearQuarterPickerDidChangeDate:)])
        [self.yearQuarterPickerDelegate yearQuarterPickerDidChangeDate:self];
    [self didChangeValueForKey:@"date"];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == self.monthComponent)
        return MONTH_ROW_MULTIPLIER * 4 * 3;
    
    int maxYear = DEFAULT_MAXIMUM_YEAR;
    if (self.maximumYear)
        maxYear = self.maximumYear.integerValue;
    
    return [self rowFromYear:maxYear] + 1;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == self.monthComponent)
        return 100.0f;
    else
        return 110.0f;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    CGFloat width = [self pickerView:self widthForComponent:component];
    CGRect frame = CGRectMake(0.0f, 0.0f, width, 45.0f);
    
    if (component == 1)
    {
        const CGFloat padding = 9.0f;
        if (component) {
            frame.origin.x += padding;
            frame.size.width -= padding;
        }
        
        frame.size.width -= padding;
    }
    
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    if (component == 1) {
        label.text = [self.quarterStrings objectAtIndex:(row % 4)];
        label.textAlignment = component ? NSTextAlignmentLeft : NSTextAlignmentRight;
    } else {
        label.text = [NSString stringWithFormat:@"%d年", [self yearFromRow:row]];
        label.textAlignment = NSTextAlignmentCenter;
        formatter.dateFormat = @"y";
    }
	NSDate *currentDate = [NSDate date];
	NSCalendar* calendar = [NSCalendar currentCalendar];
	NSDateComponents* components = [calendar components:NSYearCalendarUnit fromDate:currentDate]; // Get necessary date components
	if([components year] == [label.text integerValue] || [label.text isEqual:[_quarterStrings objectAtIndex:0]]) 
        label.textColor = [UIColor colorWithRed:0.0f green:0.35f blue:0.91f alpha:1.0f];
    
    label.font = [UIFont boldSystemFontOfSize:24.0f];
    label.backgroundColor = [UIColor clearColor];
    label.shadowOffset = CGSizeMake(0.0f, 0.1f);
    label.shadowColor = [UIColor whiteColor];
    
    return label;
}

@end
