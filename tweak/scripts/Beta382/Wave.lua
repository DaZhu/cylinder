return function(page, offset, screen_width, screen_height)
    local percent = offset/page.width
    
    local numIcons = page.max_icons
    
    for i, icon in subviews(page) do
        
        if (percent > 0) then
            local curIconPercent = percent-(0.525/numIcons)*(i-1)
            
            if (curIconPercent > 0) then
                dx = -math.pow(curIconPercent*3.5, 2)*page.width
                
                icon:translate(dx, 0, 0)
            end
        elseif (percent < 0) then
            local curIconPercent = (-percent)-(0.525/numIcons)*(numIcons-i)
            
            if (curIconPercent > 0) then
                dx = math.pow(curIconPercent*3.5, 2)*page.width
                
                icon:translate(dx, 0, 0)
            end
        end
    end
    
   page:translate(offset, 0, 0)
end
