require 'spec_helper'
require 'gnuplot/multiplot'
require 'stringio'

class String
  def unindent 
    gsub(/^#{scan(/^\s*/).min_by{|l|l.length}}/, "")
  end
end

describe Gnuplot::Multiplot do
  describe 'with a simple dataset' do
    let(:xs) { (3..4).collect { |v| v.to_f } }
    let(:ys) do 
      { mult2: xs.map {|v| v * 2 },
        square: xs.map {|v| v ** 2 }, 
      }
    end
    let(:expected) {
      <<-OUTPUT.unindent
      set multiplot layout 2, 1 title "one title to rule them all"
      set title "mult2"
      plot '-' notitle
      3.0 6.0
      4.0 8.0
      e
      set title "square"
      plot '-' notitle
      3.0 9.0
      4.0 16.0
      e
      unset multiplot
      OUTPUT
    }

    describe 'simple plot' do
      it 'uses hash options' do
        gp = StringIO.new
        Gnuplot::Multiplot.new(gp, layout: [2,1], title: "one title to rule them all", ) do |mp|
          %i{mult2 square}.each do |response|
            Gnuplot::Plot.new(mp) do |plot|
              plot.title response
              plot.data << Gnuplot::DataSet.new( [xs, ys[response]] ) {|ds| ds.notitle }
            end
          end
        end

        gp.rewind 
        expect(gp.string).to eq expected
      end

      it 'uses string options' do
        gp = StringIO.new
        Gnuplot::Multiplot.new(gp, "layout 2, 1 title \"one title to rule them all\"" ) do |mp|
          %i{mult2 square}.each do |response|
            Gnuplot::Plot.new(mp) do |plot|
              plot.title response
              plot.data << Gnuplot::DataSet.new( [xs, ys[response]] ) {|ds| ds.notitle }
            end
          end
        end

        gp.rewind 
        expect(gp.string).to eq expected
      end
    end
  end


  xit 'plots a stacked plot demo (from gnuplot demo site)'  do
    params = {
      boxwidth: "0.3 absolute", 
      style: "fill solid 1.00 border",
      tmargin: 0,
      bmargin: 0,
      lmargin: 3,
      rmargin: 3,
      yrange: "[0 : 10]",
      key: "autotitle column nobox samplen 1 noenhanced",
      style: "data boxes",
      xtics: "nomirror",
      tics: "scale 0 font \",8\"",
    }
    unset = %w{xtics ytics title}
    data = { Hungary: [3,10,8,7], Germany: [2,1,1,8,1], UK: [2,9,3,3] }

    Gnuplot.open do |gp|
      Gnuplot::Multiplot.new(gp, layout: [4,1], title: "Auto-layout of stacked plots") do |mp|
        data.each do |country, ydata|
          Gnuplot::Plot.new(gp) do |plot|
            params.each do |pair|
              plot.set(*pair)
            end
            unset.each {|val| plot.unset(val) }
            if country == data.keys.last
              plot.xlabel "Immigration to U.S. by Decade"
              plot.xtics %w(1900-1909 1910-1919 1920-infinity booyah).each_with_index.map {|v,i| "\"#{v}\" #{i}" }.join(", ")

            end

            plot.data << Gnuplot::DataSet.new( [[0,1,2,3], ydata] ) do |ds|
              ds.title = country
            end
          end
        end
      end
    end
  end
end

