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

require 'rubygems'
require 'socket'
require 'date'
require 'yaml'

module Kristin
  def Kristin.time
    DateTime.now.strftime("%H:%M:%S")
  end

  def Kristin.notice(m)
    puts "[#{Kristin.time}] \e[94mNotice: #{m}\e[0m"
  end

  def Kristin.warning(m)
    puts "[#{Kristin.time}] \e[33mWarning: #{m}\e[0m"
  end

  def Kristin.error(m)
    abort "[#{Kristin.time}] \e[31mError: #{m}\e[0m"
  end

  def Kristin.check_gem(g)
    begin
      require g
      return true
    rescue
      return false
    end
  end
end

require_relative "kristin/send"
require_relative "kristin/plugins"
require_relative "kristin/handlers"
require_relative "kristin/bot"
