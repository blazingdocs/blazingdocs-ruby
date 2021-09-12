module BlazingDocs
  DATA_SOURCE_TYPES ||= {
    'csv' => 'Csv',
    'json' => 'Json',
    'xml' => 'Xml'
  }

  class MergeParameters
    attr_accessor :sequence
    attr_accessor :data_source_type
    attr_accessor :strict

    def initialize(sequence, data_source_type, strict)
      if !!sequence == sequence
        @sequence = sequence
      else
        raise TypeError, 'sequence expects to be boolean'
      end

      if !DATA_SOURCE_TYPES[data_source_type.downcase].nil?
        @data_source_type = DATA_SOURCE_TYPES[data_source_type.downcase]
      else
        raise TypeError, 'data_source_type expects csv, json or xml'
      end

      if !!strict == strict
        @strict = strict
      else
        raise TypeError, 'strict expects to be boolean'
      end
    end
  end
end
