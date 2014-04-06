#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface SKMRCore : NSObject

@property (strong) SKView *skView;

- (instancetype)initWithFrame:(NSRect)frame;

- (void)startExecution:(NSString *)scriptFile;

@end
