local function set_texture(entry, entity)
    local prefix = init_path:match("/$") and init_path:sub(1, -2) or init_path
    if not prefix then
        return
    end
    local aws_textures_directory = "9mine-aws-cloud-fs"
    local texture_prefix = "9mine-aws-cloud-fs"
    if entry.entry_string == prefix .. "/ec2" then
        texture.download("https://miro.medium.com/max/360/1*dfEIFZvuNC7ljFy2QNurLA.png", true,
        texture_prefix .. "-ec2.png", aws_textures_directory)
        entity:set_properties({
            visual = "sprite",
            textures = {texture_prefix .. "-ec2.png"}
        })
    end
    
    if entry.platform_string == prefix .. "/ec2/describe-instances" then
        texture.download("https://www.pinclipart.com/picdir/middle/323-3231192_aws-simple-icons-compute-amazon-ec2-clipart.png", true,
        texture_prefix .. "-ec2-instance.png", aws_textures_directory)
        entity:set_properties({
            visual = "cube",
            textures = {texture_prefix .. "-ec2-instance.png", texture_prefix .. "-ec2-instance.png", texture_prefix .. "-ec2-instance.png", texture_prefix .. "-ec2-instance.png", texture_prefix .. "-ec2-instance.png", texture_prefix .. "-ec2-instance.png"}
        })
    end

    if entry.platform_string:match(string.gsub(prefix .. "/ec2/describe-instances", "%-", "%%%-") .. "/[%d%a%p]+") then
        texture.download("https://upload.wikimedia.org/wikipedia/commons/thumb/5/5c/AWS_Simple_Icons_AWS_Cloud.svg/1200px-AWS_Simple_Icons_AWS_Cloud.svg.png", true,
        texture_prefix .. "-ec2-conf.png", aws_textures_directory)
        entity:set_properties({
            visual = "sprite",
            textures = {texture_prefix .. "-ec2-conf.png"}
        })
    end
end
{% include '.cmdchan.lua'%}
platform.cmdchan = aws_cmdchan(platform.connection, core_conf:get("cmdchan_path"))
register.add_texture_handler(init_path .. "9mine-aws-cloud-fs", set_texture)