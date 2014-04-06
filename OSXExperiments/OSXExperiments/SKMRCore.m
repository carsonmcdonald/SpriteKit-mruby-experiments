#import "SKMRCore.h"

#import <MRuby/MRuby.h>
#import <MRuby/mruby/variable.h>
#import <MRuby/mruby/data.h>
#import <MRuby/mruby/proc.h>

@interface SKMRCore(Private)

- (void)loadScriptFromBundle:(NSString *)scriptFile;

@end

@implementation SKMRCore
{
    mrb_state *mrb;
    mrb_value script;
}

typedef void (^ DebugBlock)(NSString *);

static DebugBlock debugBlock;

- (instancetype)initWithFrame:(NSRect)frame
{
    if(self = [super init])
    {
        self.skView = [[SKView alloc] initWithFrame:frame];
        self.skView.autoresizingMask = NSViewNotSizable;
        
        debugBlock = ^(NSString *message) {
            NSLog(@"DEBUG: %@", message);
        };
        
        mrb = mrb_open();
    }
    
    return self;
}

- (void)startExecution:(NSString *)scriptFile
{
    [self loadScriptFromBundle:scriptFile];
    
    mrb_run(mrb, mrb_proc_ptr(script), mrb_top_self(mrb));
}

#pragma mark - Private

- (void)loadScriptFromBundle:(NSString *)scriptFile
{
    NSString *bundleLocation = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:scriptFile];
    
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

@end
