#import <SpriteKit/SpriteKit.h>

#import <MRuby/mruby.h>
#import <MRuby/mruby/proc.h>

#import "AppDelegate.h"

typedef void (^ DebugBlock)(NSString *);

static DebugBlock debugBlock;

@interface AppDelegate(Private)

- (void)loadScriptFromBundle:(NSString *)filename;

@end

@implementation AppDelegate
{
    mrb_state *mrb;
    mrb_value script;
}

- (void)loadScriptFromBundle:(NSString *)filename
{
    NSString *bundleLocation = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
    
    FILE *fp = fopen([bundleLocation UTF8String], "rb");
    if (fp == NULL)
    {
        debugBlock(@"Error loading test file from bundle.\n");
    }
    else
    {
        mrbc_context *context = mrbc_context_new(mrb);
        context->no_exec = YES;
        script = mrb_load_file_cxt(mrb, fp, context);
        mrbc_context_free(mrb, context);
        
        if (mrb_nil_p(script))
        {
            debugBlock(@"Error loading test.\n");
        }
        
        fclose(fp);
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    debugBlock = ^(NSString *message) {
        NSLog(@"DEBUG: %@", message);
    };
    
    mrb = mrb_open();
    [self loadScriptFromBundle:@"test.rb"];

    mrb_run(mrb, mrb_proc_ptr(script), mrb_top_self(mrb));
    
    SKView *skView = [[SKView alloc] initWithFrame:self.gameView.frame];
    skView.autoresizingMask = NSViewNotSizable;
    
    [self.gameView addSubview:skView];
}

@end
