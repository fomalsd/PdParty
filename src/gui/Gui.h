/*
 * Copyright (c) 2011 Dan Wilcox <danomatika@gmail.com>
 *
 * BSD Simplified License.
 * For information on usage and redistribution, and for a DISCLAIMER OF ALL
 * WARRANTIES, see the file, "LICENSE.txt," in this distribution.
 *
 * See https://github.com/danomatika/robotcowboy for documentation
 *
 */
#import <Foundation/Foundation.h>

#import "Widget.h"

@interface Gui : NSObject

@property (nonatomic, retain) NSMutableArray *widgets;

@property (nonatomic, assign) CGRect bounds;

@property (nonatomic, assign) int patchWidth;
@property (nonatomic, assign) int patchHeight;
@property (nonatomic, assign) int fontSize;

// add a widget using a given atom line aka array of NSStrings
- (void)addComment:(NSArray*) atomLine;
- (void)addNumberbox:(NSArray*) atomLine;
- (void)addBang:(NSArray*) atomLine;
- (void)addToggle:(NSArray*) atomLine;

// add widgets from an array of atom lines
- (void)buildGui:(NSArray*) atomLines;

@end

//#include "Widget.h"
//
//class ofxPd;
//
//namespace gui {
//
//class Gui {
//
//	public:
//	
//		Gui(ofxPd& pd);
//		~Gui() {}
//		
//		void setSize(int w, int h);
//		
//		void addComment(const AtomLine& line);
//		void addNumberbox(const AtomLine& line);
//		
//		void addBang(const AtomLine& line);
//		void addToggle(const AtomLine& line);
//		
//		void buildGui(const vector<AtomLine>& atomLines);
//		
//		void setFont(string file);
//		
//		void clear();
//		
//		void draw();
//		
//		vector<Widget*> widgets;
//		int width, height;	///< overall gui draw area size
//		int patchWidth, patchHeight;
//		
//		ofTrueTypeFont font;
//		int fontSize;
//		string fontFile;
//		
//		ofxPd& pd;
//};
//
//} // namespace
