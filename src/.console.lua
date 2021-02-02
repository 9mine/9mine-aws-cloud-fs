class "aws_cmdchan"("cmdchan")

function aws_cmdchan:aws_cmdchan(connection, cmdchan_path)
    cmdchan:cmdchan(connection, cmdchan_path)
end

function aws_cmdchan:write(command)
    local conn = self.connection.conn
    local f = conn:newfid()
    print("Write " .. command .. " to " .. self.cmdchan_path)
    conn:walk(conn.rootfid, f, self.cmdchan_path)
    conn:open(f, 1)
    local buf = data.new(command)
    conn:write(f, 0, buf)
    conn:clunk(f)
end

function aws_cmdchan:execute(command, location)
    local tmp_file = "/n/cmdchan/cmdchan_output"
    pcall(aws_cmdchan.write, self, command, location)
    return select(2, pcall(aws_cmdchan.read, self, tmp_file))
end

connection:set_cmdchan(aws_cmdchan(connection, core_conf:get("cmdchan_path")))
local tx_name = "9mine-aws-cloud-fs-ec2-conf.png"
texture.download("https://upload.wikimedia.org/wikipedia/commons/thumb/5/5c/AWS_Simple_Icons_AWS_Cloud.svg/1200px-AWS_Simple_Icons_AWS_Cloud.svg.png", true,
tx_name, "9mine-aws-cloud-fs")
entity:set_properties({
  visual = "cube",
  textures = {tx_name, tx_name, tx_name, tx_name, tx_name, tx_name}
})
entity:get_luaentity().on_punch = function(self, player)
    local p = self.object:get_pos()
    local pos = minetest.serialize(p)
    local request = ""
    minetest.show_formspec(player:get_player_name(), "aws:console",
             table.concat({"formspec_version[4]", "size[13,13,false]",
    "textarea[0.5,0.5;12.0,10;;;" .. minetest.formspec_escape(self.output) .. "]",
    "field[0.5,10.5;12,1;input;;]", "field_close_on_enter[input;false]",
    "button[10,11.6;2.5,0.9;send;send]",
    "field[13,13;0,0;entity_pos;;" .. minetest.formspec_escape(pos) .. "]"}, ""))
end

local function aws_console(player, formname, fields)
    if formname == "aws:console" then
        print("Handler called")
        if not (fields.key_enter or fields.send) then
            return
        end
        local player_name = player:get_player_name()
        local pos = minetest.deserialize(fields.entity_pos)
        local lua_entity = select(2, next(minetest.get_objects_inside_radius(pos, 0.5))):get_luaentity()
        local cmdchan = connections:get_connection(player_name, lua_entity.addr):get_cmdchan()
        cmdchan:write(fields.input:gsub("^aws ", ""))
        minetest.show_formspec(player_name, "core:console",
        table.concat({"formspec_version[4]", "size[13,13,false]", "textarea[0.5,0.5;12.0,10;;;",
                      minetest.formspec_escape("Please, wait for response"), "]", "field[0.5,10.5;12,1;input;;]",
                      "field_close_on_enter[input;false]"}, ""))
        minetest.after(3, function()
            local response = cmdchan:read("/n/cmdchan/cmdchan_output")
            lua_entity.output = fields.input .. ": \n" .. response .. "\n" .. lua_entity.output
            minetest.show_formspec(player_name, "core:console",
                table.concat({"formspec_version[4]", "size[13,13,false]", "textarea[0.5,0.5;12.0,10;;;",
                              minetest.formspec_escape(lua_entity.output), "]", "field[0.5,10.5;12,1;input;;]",
                              "field_close_on_enter[input;false]", "button[10,11.6;2.5,0.9;send;send]",
                              "field[13,13;0,0;entity_pos;;", minetest.formspec_escape(fields.entity_pos), "]"}, ""))
        end)
    end
end

register.add_form_handler("aws:console", aws_console)