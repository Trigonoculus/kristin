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
  class Handlers
    def initialize(bot, plugins)
      @bot      = bot
      @plugins  = plugins
      Kristin.notice("Handlers initialized.")
    end

    def handle_privmsg(socket, data)
      msg             = Hash.new
      msg[:full]      = data[0][1..-1]
      msg[:nickname]  = msg[:full].split('!')[0]
      msg[:ident]     = msg[:full].split('!')[1].split('@')[0]
      msg[:mask]      = msg[:full].split('!')[1].split('@')[1]
      msg[:from]      = data[2] != @bot[:nickname] ? data[2] : msg[:nickname]
      msg[:content]   = data[3][1..-1]

      @plugins.plugins.each do |plugin|
        plugin.new(socket, @bot).execute(msg)
      end
    end

    def handle_376
      Kristin.notice("Received end of MOTD.")
    end

    alias_method :handle_422, :handle_376

    def handle_903
      Kristin.notice("SASL authentification successful.")
    end

    def handle_904
      Kristin.warning("SASL authentification failed.")
      Kristin.notice("Attempting NickServ authentification.")
    end
  end
end
