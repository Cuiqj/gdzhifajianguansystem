
#import <UIKit/UIKit.h>

@class SRYearPicker;


@protocol SRYearPickerDelegate <NSObject>

@optional

- (void)yearPickerDidChangeDate:(SRYearPicker *)yearPicker;

@end

@interface SRYearPicker : UIPickerView<UIPickerViewDataSource, UIPickerViewDelegate>


@property (nonatomic, weak) id<SRYearPickerDelegate> yearPickerDelegate;

@property (nonatomic, strong) NSString* yearStr;
/// The minimum year that a month picker can show.
@property (nonatomic, strong) NSNumber* minimumYear;

/// The maximum year that a month picker can show.
@property (nonatomic, strong) NSNumber* maximumYear;




-(id)init;


@end
