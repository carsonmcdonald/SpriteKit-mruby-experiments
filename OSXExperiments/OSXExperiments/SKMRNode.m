#import "SKMRNode.h"

#import "SKMRAction.h"

#import <MRuby/mruby/variable.h>
#import <MRuby/mruby/data.h>
#import <MRuby/mruby/proc.h>
#import <MRuby/mruby/array.h>

@implementation SKMRNode

+ (void)registerModule:(mrb_state *)mrb withRootModule:(struct RClass *)skmrModule
{
    struct RClass* skmrNodeClass = mrb_define_class_under(mrb, skmrModule, "Node", mrb->object_class);
    
    mrb_define_method(mrb, skmrNodeClass, "position=", set_position, MRB_ARGS_REQ(1));
    mrb_define_method(mrb, skmrNodeClass, "action=", set_action, MRB_ARGS_REQ(1));
    mrb_define_method(mrb, skmrNodeClass, "<<", add_node, MRB_ARGS_REQ(1));
}

+ (SKNode *)fetchStoredNode:(mrb_state *)mrb fromObject:(mrb_value)obj
{
    return (__bridge SKNode *)(mrb_data_get_ptr(mrb, mrb_iv_get(mrb, obj, mrb_intern_lit(mrb, "skmrNodeData")), &skmr_node_type));
}

+ (void)setStoredNode:(SKNode *)node withMRB:(mrb_state *)mrb fromObject:(mrb_value)obj
{
    mrb_iv_set(mrb, obj, mrb_intern_lit(mrb, "skmrNodeData"), mrb_obj_value(Data_Wrap_Struct(mrb, mrb->object_class, &skmr_node_type, (void*) CFBridgingRetain(node))));
}

#pragma mark - Private

static void skmr_node_free(mrb_state *mrb, void *obj)
{
    SKNode *node = (__bridge SKNode *)obj;
    CFBridgingRelease((__bridge CFTypeRef)(node));
}

static const struct mrb_data_type skmr_node_type = {
    "skmrNodeData", skmr_node_free,
};

static mrb_value set_action(mrb_state *mrb, mrb_value obj)
{
    mrb_value mrbAction;
    mrb_get_args(mrb, "o", &mrbAction);
    
    SKAction *action = [SKMRAction fetchStoredAction:mrb fromObject:mrbAction];
    
    SKNode *node = [SKMRNode fetchStoredNode:mrb fromObject:obj];
    
    [node runAction:action];
    
    return obj;
}

static mrb_value set_position(mrb_state *mrb, mrb_value obj)
{
    mrb_value positionXY;
    mrb_get_args(mrb, "A", &positionXY);
    
    mrb_float x = mrb_float(mrb_ary_ref(mrb, positionXY, 0));
    mrb_float y = mrb_float(mrb_ary_ref(mrb, positionXY, 1));
    
    SKNode *node = [SKMRNode fetchStoredNode:mrb fromObject:obj];
    node.position = CGPointMake(x, y);
    
    return mrb_nil_value();
}

static mrb_value add_node(mrb_state *mrb, mrb_value obj)
{
    mrb_value *argv;
    int len;
    
    mrb_get_args(mrb, "*", &argv, &len);
    
    SKNode *node = [SKMRNode fetchStoredNode:mrb fromObject:obj];
    
    while (len--)
    {
        mrb_value childNode = *argv++;
        [node addChild:[SKMRNode fetchStoredNode:mrb fromObject:childNode]];
    }
    
    return obj;
}

@end
