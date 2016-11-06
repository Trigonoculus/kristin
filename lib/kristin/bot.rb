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
  class Bot
    def initialize(config)
      @config = YAML.load_file(config) if File.file?(config)
      Kristin.error("Not able to find config file, please check the data folder.") unless @config

      ## Server config
      @server         = Hash.new
      @server[:addr]  = @config["server"]
      @server[:port]  = @config["port"]     || 6667
      @server[:ssl]   = @config["ssl"]      || false
      @server[:pass]  = @config["s_pass"]   || false

      ## Bot config
      @bot            = Hash.new
      @bot[:nickname] = @config["nickname"] || "kristin"
      @bot[:username] = @config["username"] || @bot[:nickname]
      @bot[:password] = @config["password"] || false
      @bot[:identify] = @config["identify"] || false
      @bot[:prefix]   = @config["prefix"]   || "!"
      @bot[:channels] = @config["channels"]
      @bot[:flags]    = @config["flags"]

      ## Plugins
      @plugins        = Plugins.new(@bot)

      ## Handlers
      @handlers       = Handlers.new(@bot, @plugins)
    end

    def connect!
      unless @socket
        Kristin.notify("Connecting to #{@server[:addr]}:#{@server[:ssl] ? "+" : ""}#{@server[:port]}")

        create_socket(@server[:ssl])

        Kristin.notify("Connected to #{@server[:addr]}:#{@server[:ssl] ? "+" : ""}#{@server[:port]}")
        Kristin.msg(@socket, "PASS #{@server[:pass]}") if @server[:pass]

        identify_sasl(@bot[:username], @bot[:password]) if @bot[:identify].downcase == "sasl"
        Kristin.msg(@socket, "USER #{@bot[:username]} 0 * :#{@bot[:nickname]}")
        Kristin.msg(@socket, "NICK #{@bot[:nickname]}")
        identify_nickserv(@bot[:username], @bot[:password]) if @bot[:identify].downcase == "nickserv"

        Kristin.join_multi(@socket, @bot[:channels])

        listen!
      end
    end

    private

    def listen!
      until @socket.eof? do
        data = @socket.gets

        case data
        when /^PING/
          Kristin.msg(@socket, "PONG #{data.gsub(/^PING /, "")}")
          Kristin.notify("Pinged by server, responding with PONG.")
        when /^:[^\s]+!~?[^\s]+@[^\s]+ PRIVMSG/
          @handlers.handle_privmsg(@socket, data.chomp.split(' ', 4))
        when /^:[^\s]+ (376|422|903)/
          @handlers.send("handle_#{$~[1]}")
        when /^:[^\s]+ 904/
          @handlers.handle_904
          identify_nickserv(@bot[:username], @bot[:password])
        end

        puts data

        trap "SIGINT" do
          puts ": Signal interrupted, exiting."
          exit
        end

      end
    end

    def create_socket(ssl)
      if ssl
        if Kristin.check_gem('openssl')
          @socket = TCPSocket.new(@server[:addr], @server[:port])
          openssl = OpenSSL::SSL::SSLContext.new
          openssl.set_params(verify_mode: OpenSSL::SSL::VERIFY_PEER)
          @socket = OpenSSL::SSL::SSLSocket.new(@socket, openssl).tap do |s|
            s.sync_close = true
            s.connect
          end
        else
          Kristin.error("OpenSSL gem not found. Please install it or disable SSL in your config.")
        end
      else
        @socket = TCPSocket.open(@server[:addr], @server[:port])
      end
    end

    ## identifying

    def identify_sasl(user, password)
      if Kristin.check_gem('base64')
        Kristin.msg(@socket, "CAP REQ :sasl")
        Kristin.msg(@socket, "AUTHENTICATE PLAIN")
        Kristin.msg(@socket, "AUTHENTICATE #{Base64.encode64([user, user, password].join("\0")).gsub(/\n/, '')}")
        Kristin.msg(@socket, "CAP END")
        sleep(1)
      else
        Kristin.warning("Base64 gem not found. Please install it if you wish to identify with SASL.")
        Kristin.notify("Attempting NickServ identification.")
        @bot[:identify] = "nickserv"
      end
    end

    def identify_nickserv(user, password)
      Kristin.privmsg(@socket, "NickServ", "identify #{user} #{password}")
    end

  end
end
