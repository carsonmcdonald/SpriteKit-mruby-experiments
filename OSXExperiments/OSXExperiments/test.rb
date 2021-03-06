begin
    SKMR::show_debug = true
    
    view_size = {:x=>800, :y=>600}

    main_scene = SKMR::Scene.new(view_size[:x], view_size[:y])
 
    main_scene.background_color = "#0033A0"
    
    label = SKMR::Label.new
    label.text = "Good day!"
    label.font_size = 64
    label.font_color = "#990099"
    label.position = [view_size[:x]/2, view_size[:y]/1.5]
    main_scene << label
    
    label = SKMR::Label.new
    label.text = "Hello, World!"
    label.font_size = 64
    label.font_color = "#990099"
    label.position = [view_size[:x]/2, view_size[:y]/3]
    main_scene << label
    
    sprite = SKMR::Sprite.new "simplesprite.png"
    sprite.position = [view_size[:x]/2, view_size[:y]/2]
    sprite.color = "#880000"
    sprite.color_blend_factor = 0.5
    main_scene << sprite
    
    sprite = SKMR::Sprite.new "simplesprite.png"
    sprite.position = [view_size[:x]/4, view_size[:y]/2]
    main_scene << sprite
    
    sprite = SKMR::Sprite.new "simplesprite.png"
    sprite.position = [view_size[:x]/2, view_size[:y]/4]
    main_scene << sprite
    
    SKMR::Input.on_left_arrow_press do
        puts "Left arrow press"
        
        sprite.action = SKMR::Action.create_move_by(-10, 0, 0.2)
    end
    
    SKMR::Input.on_right_arrow_press do
        puts "Right arrow press"
        
        sprite.action = SKMR::Action.create_move_by(10, 0, 0.2)
    end
    
    last_time = 0
    main_scene.on_update do |current_time|
        begin
        if current_time - 1 > last_time
            last_time = current_time
            puts "Update loop: #{SKMR::Input.left_arrow_pressed}"
        end
        rescue Exception => e
            p e
        end
    end
    
    SKMR::current_scene = main_scene
rescue Exception => e
    p e
end
