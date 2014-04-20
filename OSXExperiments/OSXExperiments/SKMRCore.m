#import "SKMRCore.h"
#import "SKMRScene.h"
#import "SKMRLabel.h"
#import "SKMRSprite.h"

#import <MRuby/MRuby.h>
#import <MRuby/mruby/variable.h>
#import <MRuby/mruby/data.h>
#import <MRuby/mruby/proc.h>

@interface SKMRCore(Private)

- (void)loadScriptFromBundle:(NSString *)scriptFile;
- (struct RClass *)registerRootModule;

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

        struct RClass *skmrModule = [self registerRootModule];
        
        [SKMRScene registerModule:mrb withRootModule:skmrModule];
        [SKMRLabel registerModule:mrb withRootModule:skmrModule];
        [SKMRSprite registerModule:mrb withRootModule:skmrModule];
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
    SKMRCore *skmrCore = (__bridge SKMRCore *)obj;
    CFBridgingRelease((__bridge CFTypeRef)(skmrCore));
}

static const struct mrb_data_type skmr_core_type = {
    "skmrCoreData", skmr_core_free,
};

static mrb_value set_show_debug(mrb_state* mrb, mrb_value obj)
{
    mrb_bool setting = YES;
    mrb_get_args(mrb, "b", &setting);
    
    SKMRCore *slf = (__bridge SKMRCore *)(mrb_data_get_ptr(mrb, mrb_cv_get(mrb, obj, mrb_intern_lit(mrb, "skmrCoreData")), &skmr_core_type));
    if (!slf)
    {
        mrb_raise(mrb, E_ARGUMENT_ERROR, "Internal state corrupted");
    }
    
    slf.skView.showsFPS = setting;
    slf.skView.showsDrawCount = setting;
    slf.skView.showsNodeCount = setting;
    
    return mrb_nil_value();
}

static mrb_value set_current_scene(mrb_state* mrb, mrb_value obj)
{
    mrb_value scene = mrb_nil_value();
    mrb_get_args(mrb, "o", &scene);
    
    SKMRCore *slf = (__bridge SKMRCore *)(mrb_data_get_ptr(mrb, mrb_cv_get(mrb, obj, mrb_intern_lit(mrb, "skmrCoreData")), &skmr_core_type));
    if (!slf)
    {
        mrb_raise(mrb, E_ARGUMENT_ERROR, "Internal state corrupted");
    }
    
    SKMRScene *skmrScene = [SKMRScene fetchStoredScene:mrb fromObject:scene];
    if (!skmrScene)
    {
        mrb_raise(mrb, E_ARGUMENT_ERROR, "Internal state corrupted");
    }
    
    [slf.skView presentScene:skmrScene];
    
    return mrb_nil_value();
}

- (struct RClass *)registerRootModule
{
    struct RClass *skmrModule = mrb_define_module(mrb, "SKMR");
    
    mrb_define_module_function(mrb, skmrModule, "show_debug=", set_show_debug, MRB_ARGS_REQ(1));
    mrb_define_module_function(mrb, skmrModule, "current_scene=", set_current_scene, MRB_ARGS_REQ(1));
    
    mrb_mod_cv_set(mrb, skmrModule, mrb_intern_lit(mrb, "skmrCoreData"), mrb_obj_value(Data_Wrap_Struct(mrb, mrb->object_class, &skmr_core_type, (void*) CFBridgingRetain(self))));

    return skmrModule;
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
