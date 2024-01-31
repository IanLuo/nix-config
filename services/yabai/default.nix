{...}:

{
  config.services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    config = {
      mouse_follows_focus         = "off";            
      focus_follows_mouse         = "off";           
      window_origin_display       = "default";
      window_placement            = "second_child";
      window_zoom_persist         = "on";            
      window_shadow               = "off";            
      window_animation_duration   = 0.0;           
      window_animation_frame_rate = 120;           
      window_opacity_duration     = 0.0;           
      active_window_opacity       = 1.0;           
      normal_window_opacity       = 0.90;          
      window_opacity              = "off";           
      insert_feedback_color       = "0xffd75f5f";    
      split_ratio                 = 0.50;          
      split_type                  = "auto";          
      auto_balance                = "on";           
      top_padding                 = 12;            
      bottom_padding              = 12;            
      left_padding                = 12;            
      right_padding               = 12;            
      window_gap                  = 06;            
      layout                      = "bsp";           
      mouse_modifier              = "fn";            
      mouse_action1               = "move";          
      mouse_action2               = "resize";        
      mouse_drop_action           = "swap";
    };

    extraConfig = ''
      yabai -m rule --add app='System Settings' manage=off
    '';
  };
}
