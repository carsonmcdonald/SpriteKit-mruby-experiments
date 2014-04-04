#import <SpriteKit/SpriteKit.h>

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    SKView *skView = [[SKView alloc] initWithFrame:self.gameView.frame];
    skView.autoresizingMask = NSViewNotSizable;
    
    [self.gameView addSubview:skView];
}

@end
