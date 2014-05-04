begin
    SKMR::show_debug = true
    
    view_size = {:x=>800, :y=>600}
    
    main_scene = SKMR::Scene.new(view_size[:x], view_size[:y])
    
    main_scene.background_color = "#0033A0"
    
    dog_textures = [SKMR::Texture.new("dog1-state1.png"), SKMR::Texture.new("dog1-state2.png")]
    
    dog_pos = [view_size[:x]/2, view_size[:y]/4]

    dog_sprite = SKMR::Sprite.new "dog1-state1.png"
    dog_sprite.position = dog_pos
    main_scene << dog_sprite

    SKMR::Input.on_left_arrow_press do
        puts "Left arrow press"
        
        begin
            walk_animation_p1 = [SKMR::Action.create_texture_animation(dog_textures, 0.15), SKMR::Action.create_move_by(-5, 0, 0.2)]
            walk_animation_p2 = [SKMR::Action.create_rotate_by(5 * (3.14/180.0), 0.15), SKMR::Action.create_rotate_by(-5 * (3.14/180.0), 0.15)]
            walk_animation = [SKMR::Action.create_sequence(walk_animation_p1), SKMR::Action.create_sequence(walk_animation_p2)]

            dog_sprite.action = SKMR::Action.create_repeat(SKMR::Action.create_group(walk_animation), 5)
        rescue Exception => e
            p e
        end
    end
    
    SKMR::Input.on_right_arrow_press do
        puts "Right arrow press"
        
        walk_animation = [SKMR::Action.create_texture_animation(dog_textures, 0.15), SKMR::Action.create_move_by(5, 0, 0.2)]
        
        dog_sprite.action = SKMR::Action.create_repeat(SKMR::Action.create_group(walk_animation), 5)
    end
    
    SKMR::current_scene = main_scene
rescue Exception => e
    p e
end
