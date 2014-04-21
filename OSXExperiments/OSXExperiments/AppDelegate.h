#import <Cocoa/Cocoa.h>

#import "SKMRWindow.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet SKMRWindow *window;
@property (assign) IBOutlet NSView *gameView;

@end
