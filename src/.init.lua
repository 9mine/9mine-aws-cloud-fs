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
            visual = "sprite",
            textures = {texture_prefix .. "-ec2-instance.png"}
        })
    end
end
register.add_texture_handler(init_path .. "9mine-aws-cloud-fs", set_texture)