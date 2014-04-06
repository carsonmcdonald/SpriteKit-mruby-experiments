#import "SKMRCore.h"

#import <MRuby/MRuby.h>
#import <MRuby/mruby/variable.h>
#import <MRuby/mruby/data.h>
#import <MRuby/mruby/proc.h>

@interface SKMRCore(Private)

- (void)loadScriptFromBundle:(NSString *)scriptFile;
- (void)registerModule;

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

        [self registerModule];
    }
    
    return self;
}

- (void)startExecution:(NSString *)scriptFile
{
    [self loadScriptFromBundle:scriptFile];
    
    mrb_run(mrb, mrb_proc_ptr(script), mrb_top_self(mrb));
}

#pragma mark - Private

static void skmr_core_free(mrb_state *mrb, void *obj)
{
    NSLog(@"SKMRCore free called");
    
    SKMRCore *skmrCore = (__bridge SKMRCore *)obj;
    CFBridgingRelease((__bridge CFTypeRef)(skmrCore));
}

static const struct mrb_data_type skmr_core_type = {
    "skmrCoreData", skmr_core_free,
};

- (void)registerModule
{
    struct RClass *module = mrb_define_module(mrb, "SKMRCore");
    
    mrb_mod_cv_set(mrb, module, mrb_intern_cstr(mrb, "skmrCoreData"), mrb_obj_value(Data_Wrap_Struct(mrb, mrb->object_class, &skmr_core_type, (void*) CFBridgingRetain(self))));
}

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
