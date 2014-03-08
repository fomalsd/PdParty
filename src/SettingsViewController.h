/*
 * Copyright (c) 2013 Dan Wilcox <danomatika@gmail.com>
 *
 * BSD Simplified License.
 * For information on usage and redistribution, and for a DISCLAIMER OF ALL
 * WARRANTIES, see the file, "LICENSE.txt," in this distribution.
 *
 * See https://github.com/danomatika/PdParty for documentation
 *
 */
#import <UIKit/UIKit.h>

// settings view
@interface SettingsViewController : UITableViewController

#pragma mark Behavior

@property (weak, nonatomic) IBOutlet UISwitch *lockScreenDisabledSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *runInBackgroundSwitch;

- (IBAction)behaviorChanged:(id)sender;

#pragma mark OSC Event Fowarding

@property (weak, nonatomic) IBOutlet UISwitch *oscAccelEnabledSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *oscTouchEnabledSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *oscLocationEnabledSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *oscHeadingEnabledSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *oscKeyEnabledSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *oscPrintEnabledSwitch;

- (IBAction)oscEventTypeChanged:(id)sender;

#pragma mark Audio Latency

@property (weak, nonatomic) IBOutlet UISegmentedControl *ticksPerBufferSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *latencyLabel;

- (IBAction)ticksPerBufferChanged:(id)sender;

#pragma mark Default Folders

@property (weak, nonatomic) IBOutlet UIButton *libFolderButton;
@property (weak, nonatomic) IBOutlet UIButton *samplesFolderButton;
@property (weak, nonatomic) IBOutlet UIButton *testsFolderButton;

- (IBAction)copyDefaultFolder:(id)sender;

@end
