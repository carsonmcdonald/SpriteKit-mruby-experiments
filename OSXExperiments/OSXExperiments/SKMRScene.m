#import "SKMRScene.h"
#import "SKMRUtils.h"
#import "SKMRNode.h"

#import <MRuby/mruby/variable.h>
#import <MRuby/mruby/data.h>
#import <MRuby/mruby/proc.h>

@implementation SKMRScene
{
    mrb_state *currentMRB;
    mrb_value onUpdateBlock;
}

+ (void)registerModule:(mrb_state *)mrb withRootModule:(struct RClass *)skmrModule
{
    struct RClass* skmrSceneClass = mrb_define_class_under(mrb, skmrModule, "Scene", mrb_class_get_under(mrb, skmrModule, "Node"));
    
    mrb_define_method(mrb, skmrSceneClass, "initialize", skmr_scene_init, MRB_ARGS_REQ(2));
    mrb_define_method(mrb, skmrSceneClass, "background_color=", set_background_color, MRB_ARGS_REQ(1));
    mrb_define_method(mrb, skmrSceneClass, "on_update", set_on_update, MRB_ARGS_BLOCK());
}

+ (SKMRScene *)fetchStoredScene:(mrb_state *)mrb fromObject:(mrb_value)obj
{
    return (SKMRScene *)[SKMRNode fetchStoredNode:mrb fromObject:obj];
}

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.scaleMode = SKSceneScaleModeAspectFit;
        onUpdateBlock = mrb_nil_value();
    }
    return self;
}

- (void)update:(NSTimeInterval)currentTime
{
    if(!mrb_nil_p(onUpdateBlock))
    {
        mrb_yield(currentMRB, onUpdateBlock, mrb_fixnum_value(currentTime));
    }
}

#pragma mark - Private

static mrb_value skmr_scene_init(mrb_state *mrb, mrb_value obj)
{
    mrb_int height = 0;
    mrb_int width = 0;
    mrb_get_args(mrb, "ii", &width, &height);
    
    SKMRScene *scene = [[SKMRScene alloc] initWithSize:CGSizeMake(width, height)];
    scene->currentMRB = mrb;
    
    [SKMRNode setStoredNode:scene withMRB:mrb fromObject:obj];
    
    return obj;
}

static mrb_value set_background_color(mrb_state *mrb, mrb_value obj)
{
    const char *bgColor = NULL;
    mrb_get_args(mrb, "z", &bgColor);
    
    SKMRScene *scene = (SKMRScene *)[SKMRNode fetchStoredNode:mrb fromObject:obj];
    scene.backgroundColor = [SKMRUtils convertHexStringToSKColor:[NSString stringWithUTF8String:bgColor]];
    
    return obj;
}

static mrb_value set_on_update(mrb_state *mrb, mrb_value obj)
{
    mrb_value onUpdateBlock;
    mrb_get_args(mrb, "&", &onUpdateBlock);
    
    SKMRScene *scene = (SKMRScene *)[SKMRNode fetchStoredNode:mrb fromObject:obj];
    scene->onUpdateBlock = onUpdateBlock;

    return obj;
}

@end
