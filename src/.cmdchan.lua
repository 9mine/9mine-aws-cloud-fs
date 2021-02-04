class "aws_cmdchan"("cmdchan")

function aws_cmdchan:aws_cmdchan(connection, cmdchan_path)
    self.connection = connection
    self.cmdchan_path = cmdchan_path
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