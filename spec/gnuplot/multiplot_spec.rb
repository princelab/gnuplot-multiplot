require 'spec_helper'
require 'gnuplot/multiplot'
require 'stringio'

describe Gnuplot::Multiplot do
  it 'works' do

    puts "HERE"
    x = (0..3).collect { |v| v.to_f }

    #gp = StringIO.new
    Gnuplot.open do |gp|
      Gnuplot::Multiplot.new(gp, layout: [2,1], title: "one title to rule them all") do |mp|
        Gnuplot::Plot.new(mp) do |plot|
          plot.title "x * 2"
          plot.data << Gnuplot::DataSet.new( [x, x.map {|v| v * 2 }] ) {|ds| ds.notitle }
        end

        Gnuplot::Plot.new(mp) do |plot|
          plot.title "x ^ 2"
          plot.data << Gnuplot::DataSet.new( [x, x.map {|v| v ** 2 }] ) {|ds| ds.notitle }
        end
      end
    end

    #gp.rewind ; puts gp.string

  end
end
