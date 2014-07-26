module ESDB
  class Exception < Exception; end

  # Various Settings
  # TODO: refactor
  class << self
    def api_key=(key)
      @api_key = key
    end
    
    def api_key
      @api_key
    end
  end

  # Simply transforms a stats hash into a StatsParam string
  class StatsParam
    def initialize(stats)
      @array = []
      @stats = stats
      stats.each do |key, value|
        if value.is_a?(Array)
          values = value.join(',')
        elsif value === true
          values = 'avg'
        elsif value.is_a?(Hash)
          values = value.collect{|calc, conds| 
            if conds.collect(&:class).include?(Array)
              conds.collect{|_conds| "#{calc}#{":[#{_conds.join(',')}]" if _conds.is_a?(Array)}"}.join(',')
            else
              "#{calc}:[#{conds.join(',')}]"
            end
          }.join(',')
        else
          values = value
        end

        @array << "#{key}(#{values})"
      end
    end

    def to_s
      @array.join(',')
    end
  end
end

require 'esdb/resource'
require 'esdb/identity'
require 'esdb/stat'
require 'esdb/replay'
require 'esdb/match'
