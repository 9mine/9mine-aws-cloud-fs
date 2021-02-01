local function aws_message_handler(player_name, message)
    if message:match("^aws ") then
        local player = minetest.get_player_by_name(player_name)
        local player_graph = graphs:get_player_graph(player_name)
        local platform = player_graph:get_platform(common.get_platform_string(player))
        if not platform then
            return false
        end
        local cmdchan = platform:get_cmdchan()
        if not cmdchan then
            return
        end
        message = message:gsub("^aws ", "")

        cmdchan:write(message)
        minetest.after(1, function()
            local result, response = pcall(cmdchan.read, cmdchan, "/n/cmdchan/cmdchan_output")
            cmdchan.show_response(response, player_name)
            if not result then
                minetest.after(2, function()
                    result, response = pcall(cmdchan.read, cmdchan, "/n/cmdchan/cmdchan_output")
                    cmdchan.show_response(response, player_name)
                end)
                return
            end
        end)
        return true
    end
end

register.add_message_handler(init_path .. "aws_message_handler", aws_message_handler)
