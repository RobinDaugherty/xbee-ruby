module XBeeRuby

  class Response

    @@response_types = {}

    def self.frame_type type
      @@response_types[type] = self
    end

    def self.from_packet packet
      @@response_types[packet.data[0]].new packet.data rescue raise IOError, "Unknown response type 0x#{packet.data[0].to_s 16}"
    end

    def to_s
      'Response'
    end

  end

end

