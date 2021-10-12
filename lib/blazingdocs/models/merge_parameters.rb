module BlazingDocs
  DATA_SOURCE_TYPES ||= {
    'csv' => 'Csv',
    'json' => 'Json',
    'xml' => 'Xml'
  }

  class MergeParameters
    attr_accessor :data_source_name
    attr_accessor :parse_columns
    attr_accessor :sequence
    attr_accessor :data_source_type
    attr_accessor :strict

    def initialize(sequence, data_source_type, strict, data_source_name = 'data', parse_columns = false)
      @data_source_name = data_source_name

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

      if !!parse_columns == parse_columns
        @parse_columns = parse_columns
      else
        raise TypeError, 'parse_columns expects to be boolean'
      end
    end
  end
end
