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
  class Plugin_Ping < Plugin_Base

    def config
      {

      }
    end

    def execute(msg)
      if cmd_match(msg, /(ping|pong)/)
        ping_replies = [
          "PONG!",
          "PING!",
          "#{@bot[:nickname]}.exe has stopped working.",
          "Leave me alone! :(",
          "What now?",
          "And what is #{@bot[:nickname]}?",
          "We will make #{msg[:from]} great again!",
          "Yes, how may I help?"
        ]

        Kristin.reply(@socket, msg[:from], msg[:nickname], ping_replies.sample)
      end
    end

  end
end
