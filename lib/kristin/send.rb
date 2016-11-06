# MIT License
#
# Copyright (c) 2016 cats
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

module Kristin
  def Kristin.msg(socket, msg)
    socket.puts(msg+"\r\n")
  end

  def Kristin.privmsg(socket, to, msg)
    Kristin.msg(socket, "PRIVMSG #{to} :#{msg}")
  end

  def Kristin.reply(socket, to, user, msg)
    if user != to
      Kristin.privmsg(socket, to, "#{user}: #{msg}")
    else
      Kristin.privmsg(socket, to, msg)
    end
  end

  def Kristin.action(socket, to, msg)
    Kristin.privmsg(socket, to, "\x01ACTION #{msg}\x01")
  end

  def Kristin.join(socket, channel)
    Kristin.msg(socket, "JOIN #{channel}")
  end

  def Kristin.join_multi(socket, channels)
    channels.each do |c|
      Kristin.join(socket, c)
    end
  end
end
