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
  class Plugins
    attr_accessor :plugins

    def initialize(bot)
      @bot     = bot
      @plugins = Array.new
      Kristin.notify("Plugin library initialized.")

      plugin_config = File.join(File.expand_path(".."), "data", "plugins.yml")
      plugin_list = YAML.load_file(plugin_config) if File.file?(plugin_config)
      Kristin.error("Plugin config does not exist.") unless plugin_list

      plugin_list.each do |plugin|
        load_plugin(plugin.downcase)
      end

      Kristin.notify("All plugins loaded.")
    end

    def load_plugin(plugin)
      plugin_file = File.join(File.expand_path(".."), "plugins", "#{plugin}.rb")
      if File.file?(plugin_file)
        require_relative plugin_file
        plugin_class = Kristin.const_get("Plugin_#{plugin.capitalize}")
        @plugins << plugin_class unless @plugins.include?(plugin_class)
      else
        Kristin.warning("No such plugin: #{plugin}")
        return false
      end
    end

    def unload_plugin(plugin)
      plugin_file = File.join(File.expand_path(".."), "plugins", "#{plugin}.rb")
      if File.file?(plugin_file)
        plugin_class = Kristin.const_get("Plugin_#{plugin.capitalize}")
        @plugins.delete(plugin_class) if @plugins.include?(plugin_class)
      else
        Kristin.warning("No such plugin: #{plugin}")
        return false
      end
    end
  end

  class Plugin_Base
    attr_accessor :config

    def initialize(socket, bot)
      @bot    = bot
      @socket = socket
      @config = Hash.new
    end

    def msg_match(msg, re)
      if msg[:content].match(re)
        return $~
      end
    end

    def cmd_match(msg, re)
      if msg[:content].match(/^(?:#{@bot[:prefix]}|#{@bot[:nickname]}(?::|,)? |#{msg[:from] == msg[:nickname] ? "" : @bot[:prefix]})#{re}(?: .*)?/i)
        return $~
      end
    end

    def execute
      Kristin.warning("This isn't supposed to happen!")
    end

  end
end
