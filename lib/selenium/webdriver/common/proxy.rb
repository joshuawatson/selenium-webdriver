module Selenium
  module WebDriver
    class Proxy
      TYPES = {
        :direct      => "DIRECT",     # Direct connection, no proxy (default on Windows).
        :manual      => "MANUAL",     # Manual proxy settings (e.g., for httpProxy).
        :pac         => "PAC",        # Proxy autoconfiguration from URL.
        :auto_detect => "AUTODETECT", # Proxy autodetection (presumably with WPAD).
        :system      => "SYSTEM"      # Use system settings (default on Linux).
      }

      attr_reader :type,
                  :ftp,
                  :http,
                  :no_proxy,
                  :pac,
                  :ssl,
                  :auto_detect

      def initialize(opts = {})
        opts = opts.dup

        self.type        = opts.delete(:type) if opts.has_key? :type
        self.ftp         = opts.delete(:ftp) if opts.has_key? :ftp
        self.http        = opts.delete(:http) if opts.has_key? :http
        self.no_proxy    = opts.delete(:no_proxy) if opts.has_key? :no_proxy
        self.ssl         = opts.delete(:ssl) if opts.has_key? :ssl
        self.pac         = opts.delete(:pac) if opts.has_key? :pac
        self.auto_detect = opts.delete(:auto_detect) if opts.has_key? :auto_detect

        unless opts.empty?
          raise ArgumentError, "unknown option#{'s' if opts.size != 1}: #{opts.inspect}"
        end
      end

      def ftp=(value)
        self.type = :manual
        @ftp = value
      end

      def http=(value)
        self.type = :manual
        @http = value
      end

      def no_proxy=(value)
        self.type = :manual
        @no_proxy = value
      end

      def ssl=(value)
        self.type = :manual
        @ssl = value
      end

      def pac=(url)
        self.type = :pac
        @pac = url
      end

      def auto_detect=(bool)
        self.type = :auto_detect
        @auto_detect = bool
      end

      def type=(type)
        unless TYPES.has_key? type
          raise ArgumentError, "invalid proxy type: #{type.inspect}, expected one of #{TYPES.keys.inspect}"
        end

        if @type && type != @type
          raise ArgumentError, "incompatible proxy type #{type.inspect} (already set to #{@type.inspect})"
        end

        @type = type
      end

      def as_json(opts = nil)
        json_result = {
          "proxyType" => TYPES.fetch(type)
        }

        json_result["ftpProxy"]           = ftp if ftp
        json_result["httpProxy"]          = http if http
        json_result["noProxy"]            = no_proxy if no_proxy
        json_result["proxyAutoconfigUrl"] = pac if pac
        json_result["sslProxy"]           = ssl if ssl
        json_result["autodetect"]         = auto_detect if auto_detect

        json_result if json_result.length > 1
      end

    end # Proxy
  end # WebDriver
end # Selenium