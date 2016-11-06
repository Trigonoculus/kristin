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
  class Plugin_Help < Plugin_Base

    def config
      {

      }
    end

    def execute(msg)
      if cmd = cmd_match(msg, /help(?: ([^\s]+))?/)
        if cmd[1] != nil
          help_cmd = cmd[1].downcase
          help_file = File.join(File.expand_path(".."), "data", "help.yml")
          help_all = YAML.load_file(help_file) if File.file?(help_file)
          Kristin.warning("Help file does not exist.") unless help_all

          if help_all.has_key?(help_cmd)
            help_msg = help_all[help_cmd].gsub(/{prefix}/, @bot[:prefix]).gsub(/{bold}/, "\x02")
            Kristin.notice(@socket, msg[:nickname], help_msg)
          end
        end
      end
    end

  end
end
