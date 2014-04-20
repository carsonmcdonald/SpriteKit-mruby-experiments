begin
    SKMR::show_debug = true
    
    view_size = {:x=>800, :y=>600}
    
    main_scene = SKMR::Scene.new(view_size[:x], view_size[:y])
    
    main_scene.background_color = "#0033A0"
    
    label = SKMR::Label.new
    label.text = "Hello, World!"
    label.font_size = 64
    label.font_color = "#990099"
    label.position = [view_size[:x]/2, view_size[:y]/2]
    main_scene << label
    
    sprite = SKMR::Sprite.new "simplesprite.png"
    sprite.position = [view_size[:x]/2, view_size[:y]/2]
    main_scene << sprite
    
    SKMR::current_scene = main_scene
rescue Exception => e
    puts e
end