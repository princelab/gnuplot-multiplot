require "gnuplot/multiplot/version"
require 'gnuplot'

module Gnuplot
  module MultiplotBehavior
    def initialize(io = nil, cmd = "plot")
      reply = super(io, cmd)
      io << "\n"
      reply
    end
  end
  class Plot
    prepend MultiplotBehavior
  end
end

module Gnuplot

  class Multiplot
    NEGATIVE_BOOLEANS = {
      enhanced: :noenhanced,
      rowsfirst: :columnsfirst,
      downwards: :upwards,
    }

    def initialize(gnuplot, opts={}, &block)
      string = 
        if opts.is_a?(Hash)
          opts.map {|key, val|
            if NEGATIVE_BOOLEANS.has_key?(key)
              val ? key : NEGATIVE_BOOLEANS[key]
            else
              pair = 
                if val.is_a?(Array)
                  [key, val.join(", ")]
                elsif key == :title
                  [key, "\"#{val}\""]
                else
                  [key, val]
                end
              pair.join(" ")
            end
          }.join(" ")
        else
          opts
        end
      gnuplot << "set multiplot " << string << "\n"
      block.call(gnuplot)
      gnuplot << "unset multiplot\n"
    end
  end
end
