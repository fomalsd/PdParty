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
#import "Loadsave.h"

#import "AppDelegate.h"
#import "Gui.h"
#import "UIAlertView+Blocks.h"

@implementation Loadsave

- (id)initWithAtomLine:(NSArray *)line andGui:(Gui *)gui {
	if(line.count < 6) { // sanity check
		DDLogWarn(@"Loadsave: cannot create, atom line length < 6");
		return nil;
	}
	self = [super initWithAtomLine:line andGui:gui];
	if(self) {
		self.label = nil; // no label

		self.name = [Gui filterEmptyStringValues:[line objectAtIndex:5]];
		self.receiveName = self.name;
		if(![self hasValidReceiveName]) {
			// drop something we can't interact with
			DDLogVerbose(@"Loadsave: dropping, receive name is empty");
			return nil;
		}
		
		self.originalFrame = CGRectZero; // doesn't draw anything
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
	// doesn't draw anything
}

- (void)reshape {
	// doesn't draw anything
}

#pragma mark Overridden Getters / Setters

- (NSString *)type {
	return @"Loadsave";
}

#pragma mark WidgetListener

- (BOOL)receiveEditMessage:(NSString *)message withArguments:(NSArray *)arguments {
	if(([message isEqualToString:@"load"] || [message isEqualToString:@"save"])) {

		// load variables
		if(arguments.count > 0 && [arguments isStringAt:0]) {
			self.directory = [arguments objectAtIndex:0];
		}
		else {
			self.directory = nil;
		}
		if(arguments.count > 1 && [arguments isStringAt:1]) {
			self.extension = [arguments objectAtIndex:1];
		}
		else {
			self.extension = nil;
		}
		self.sendName = [self.name stringByAppendingFormat:@"-%@", message];
		DDLogVerbose(@"Loadsave %@: received %@ message: %@ %@", self.receiveName, message, self.directory, self.extension);
		
		AppDelegate *app = [[UIApplication sharedApplication] delegate];
		if(!app.isPatchViewVisible) {
			DDLogWarn(@"Loadsave %@: cannot open dialog when patch view is not visible", self.receiveName);
			return YES;
		}
		
		// launch browser
		PartyBrowser *browser = [[PartyBrowser alloc] initWithStyle:UITableViewStylePlain];
		browser.delegate = self;
		browser.extensions = self.extension ? @[self.extension] : nil;
		browser.directoriesOnly = YES;
		browser.canAddDirectories = (self.directory ? NO : YES);
		browser.showMoveButton = (self.directory ? NO : YES);
		browser.modalPresentationStyle = UIModalPresentationFormSheet;
		browser.modalInPopover = YES;
		if([message isEqualToString:@"load"]) {
			browser.canAddFiles = NO;
			if(self.extension) {
				browser.title = [NSString stringWithFormat:@"Load .%@ file", self.extension];
			}
			else {
				browser.title = @"Load file";
			}
		}
		else { // @"save"
			if(self.extension) {
				browser.title = [NSString stringWithFormat:@"Save .%@ file", self.extension];
			}
			else {
				browser.title = @"Save file";
			}
		}
		if(self.directory) {
			NSString *path = [app.sceneManager.currentPath stringByAppendingPathComponent:self.directory];
			if(![[NSFileManager defaultManager] fileExistsAtPath:path]) {
				DDLogInfo(@"LoadSave: %@ doesn't exist, create it?", self.directory);
				UIAlertView *alertView = [[UIAlertView alloc]
									  initWithTitle:[NSString stringWithFormat:@"%@ folder doesn't exist", self.extension]
									  message:@"Create it?"
									  delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Create", nil];
				alertView.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
					if(buttonIndex == 1) { // Create
						[browser createDirectoryPath:path];
					}
				};
				[alertView show];
				return YES;
			}
			else {
				[browser loadDirectory:path];
			}
		}
		else {
			[browser loadDirectory:app.sceneManager.currentPath relativeTo:[Util documentsPath]];
		}
		if(self.directory && self.extension && [browser fileCountForExtensions] == 0) {
			if([message isEqualToString:@"load"]) {
				DDLogVerbose(@"Loadsave: dir & extension set when loading, but no files to load");
				UIAlertView *alertView = [[UIAlertView alloc]
									  initWithTitle:[NSString stringWithFormat:@"No .%@ files found", self.extension]
									  message:@"Save one first?"
									  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
				[alertView show];
			}
			else { // @"save"
				[browser showNewFileDialog];
			}
		}
		else {
			[browser presentAnimated:YES];
		}
		return YES;
	}
	return NO;
}

#pragma mark BrowserDelegate

- (void)browser:(Browser *)browser selectedFile:(NSString *)path {
	[self sendPath:path];
	[browser dismissViewControllerAnimated:YES completion:nil];
}

- (void)browser:(Browser *)browser createdFile:(NSString *)path {
	[self sendPath:path];
	[browser dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Private

- (void)sendPath:(NSString *)path {
	[self sendSymbol:path];
	NSArray *detail = @[ // ext file dir
		[path pathExtension],
		[[path lastPathComponent] stringByDeletingPathExtension],
		[path stringByDeletingLastPathComponent]
	];
	[PdBase sendList:detail toReceiver:[self.sendName stringByAppendingString:@"-detail"]];
}

@end
