begin
    SKMR::show_debug = true
    
    view_size = {:x=>800, :y=>600}
    
    main_scene = SKMR::Scene.new(view_size[:x], view_size[:y])
    
    main_scene.background_color = "#0033A0"
    
    SKMR::current_scene = main_scene
rescue Exception => e
    puts e
end