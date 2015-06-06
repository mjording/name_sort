require "name_sort/version"
require 'csv'

module NameSort
  class InvalidDeliminatorError < StandardError; end
  class Sorter
    HDR = %w(last_name first_name gender date_of_birth favorite_color)
    attr_reader :names, :parsed
    def initialize
      @names = []
    end

    def input(delimiter,file)
      header_fields = header(delimiter)
      parsed = CSV.read(file, col_sep: delimiter, headers: header_fields)
      parsed.delete('middle_initial')
      data = []
      parsed.each do |line|
        data << HDR.map{|field| line[field].nil? ? nil : format_for(field,line[field]) }.compact
      end
      @names += data
    end

    def format_for(field,value)
      case field.strip()
      when 'gender'
        format_gender(value.strip())
      when 'date_of_birth'
        format_date(value.strip())
      else
        value.strip()
      end
    end

    def format_gender(value)
      if value.match(/^(m|male)$/i)
        "Male"
      elsif value.match(/^(f|female)$/i)
        "Female"
      end
    end

    def format_date(value)
      if value.count('-') == 2
        Date.strptime(value, "%m-%d-%Y")
      elsif value.count('/') == 2
        Date.strptime(value, "%m/%d/%Y")
      end
    end

    def header(delimiter)
      unless [' ','|',','].include?(delimiter)
        raise InvalidDeliminatorError
      end
      hdr = %w(last_name first_name)
      case delimiter
      when '|'
        hdr += %w(middle_initial gender favorite_color date_of_birth)
      when ' '
        hdr +=  %w(middle_initial gender date_of_birth favorite_color)
      when ','
        hdr += %w(gender favorite_color date_of_birth)
      else
        hdr
      end
    end

    def sort_for(field)
      field_index = HDR.index(field)
      @names.sort_by{|n|n[field_index]}
    end

    def format_fields(record)
      record.map.with_index do |field,idx|
        HDR.index("date_of_birth") == idx ? field.strftime('%-m/%d/%Y') : field
      end
    end

    def print_names(sort_by)
      sort_for(sort_by).each do |record|
        puts format_fields(record).join(" ")
      end
    end
  end
end
