
#import <UIKit/UIKit.h>

@class SRYearQuarterPicker;


@protocol SRYearQuarterPickerDelegate <NSObject>

@optional

- (void)yearQuarterPickerDidChangeDate:(SRYearQuarterPicker *)yearQuarterPicker;

@end

@interface SRYearQuarterPicker : UIPickerView<UIPickerViewDataSource, UIPickerViewDelegate>


@property (nonatomic, weak) id<SRYearQuarterPickerDelegate> yearQuarterPickerDelegate;

@property (nonatomic, strong) NSString* yearStr;
@property (nonatomic, strong) NSString* quarterStr;
/// The minimum year that a month picker can show.
@property (nonatomic, strong) NSNumber* minimumYear;

/// The maximum year that a month picker can show.
@property (nonatomic, strong) NSNumber* maximumYear;




-(id)init;


@end
