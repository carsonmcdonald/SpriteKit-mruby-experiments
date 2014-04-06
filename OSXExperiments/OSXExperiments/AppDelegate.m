#import <SpriteKit/SpriteKit.h>

#import "AppDelegate.h"
#import "SKMRCore.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    SKMRCore *skmrCore = [[SKMRCore alloc] initWithFrame:self.gameView.frame];
    
    [self.gameView addSubview:skmrCore.skView];
    
    [skmrCore startExecution:@"test.rb"];
}

@end
