begin
    SKMR::show_debug = true
    
    main_scene = SKMR::Scene.new
rescue Exception => e
    puts e
end