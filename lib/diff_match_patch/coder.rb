require 'set'
require 'uri'

class DiffMatchPatch
  module Coder
    ENCODE_REGEX = /[^0-9A-Za-z_.;!~*'(),\/?:@&=+$\#-]/
    ESCAPED = /%[a-fA-F\d]{2}/

    def self.encode(str, unsafe = ENCODE_REGEX)
      unless unsafe.kind_of?(Regexp)
        # perhaps unsafe is String object
        unsafe = Regexp.new("[#{Regexp.quote(unsafe)}]", false)
      end

      str.gsub(unsafe) do
        us = $&
        tmp = ''
        us.each_byte do |uc|
          tmp << sprintf('%%%02X', uc)
        end
        tmp
      end.force_encoding(Encoding::US_ASCII)
    end

    def self.decode(str)
      enc = str.encoding
      enc = Encoding::UTF_8 if enc == Encoding::US_ASCII
      str.gsub(ESCAPED) { [$&[1, 2]].pack('H2').force_encoding(enc) }
    end
  end
end
