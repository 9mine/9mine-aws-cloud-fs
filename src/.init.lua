local function set_texture(entry, entity)
    local prefix = init_path:match("/$") and init_path:sub(1, -2) or init_path
    if not prefix then
        return
    end
    if entry.platform_string == prefix .. "/ec2/describe-instances" then
        texture.download("https://www.quotecolo.com/wp-content/uploads/2019/02/AWS-EC2-00.png", true,
            "9mine-aws-cloud-fs.png", "9mine-aws-cloud-fs")
        entity:set_properties({
            visual = "cube",
            textures = {"9mine-aws-cloud-fs.png", "9mine-aws-cloud-fs.png", "9mine-aws-cloud-fs.png",
                        "9mine-aws-cloud-fs.png", "9mine-aws-cloud-fs.png", "9mine-aws-cloud-fs.png"}
        })
    end
end
register.add_texture_handler(init_path .. "9mine-aws-cloud-fs-set-texture", set_texture)