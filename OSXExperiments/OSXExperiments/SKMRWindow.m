#import <Carbon/Carbon.h>

#import "SKMRWindow.h"
#import "SKMRInput.h"

@implementation SKMRWindow

- (BOOL)resignFirstResponder
{
    return NO;
}

- (void)keyDown:(NSEvent *)theEvent
{
    if(theEvent.isARepeat) return;
    
    if (theEvent.keyCode == kVK_LeftArrow)
    {
        if(![SKMRInput instance].leftArrowPressed)
        {
            [[SKMRInput instance] triggerLeftArrowPress];
        }
        [SKMRInput instance].leftArrowPressed = YES;
    }
    
    if (theEvent.keyCode == kVK_RightArrow)
    {
        if(![SKMRInput instance].rightArrowPressed)
        {
            [[SKMRInput instance] triggerRightArrowPress];
        }
        [SKMRInput instance].rightArrowPressed = YES;
    }
    
    if (theEvent.keyCode == kVK_UpArrow)
    {
        if(![SKMRInput instance].upArrowPressed)
        {
            [[SKMRInput instance] triggerUpArrowPress];
        }
        [SKMRInput instance].upArrowPressed = YES;
    }
    
    if (theEvent.keyCode == kVK_DownArrow)
    {
        if(![SKMRInput instance].downArrowPressed)
        {
            [[SKMRInput instance] triggerDownArrowPress];
        }
        [SKMRInput instance].downArrowPressed = YES;
    }
}

- (void)keyUp:(NSEvent *)theEvent
{
    if(theEvent.isARepeat) return;
    
    if (theEvent.keyCode == kVK_LeftArrow)
    {
        [SKMRInput instance].leftArrowPressed = NO;
    }
    
    if (theEvent.keyCode == kVK_RightArrow)
    {
        [SKMRInput instance].rightArrowPressed = NO;
    }
    
    if (theEvent.keyCode == kVK_UpArrow)
    {
        [SKMRInput instance].upArrowPressed = NO;
    }
    
    if (theEvent.keyCode == kVK_DownArrow)
    {
        [SKMRInput instance].downArrowPressed = NO;
    }
}

@end
