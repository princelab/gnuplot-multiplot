# Gnuplot::Multiplot

Simple interface to the multiplot function.  Compatible with the gnuplot gem.

## Installation

gnuplot-multiplot includes gnuplot as a dependency, so you get both if you
install the multiplot gem.

    gem install gnuplot-multiplot

## Example

```ruby
require 'gnuplot/multiplot'

x = (0..50).collect { |v| v.to_f }

Gnuplot.open do |gp|
  Gnuplot::Multiplot.new(gp, layout: [2,1]) do |mp|
    mp.plot do |plot|
      plot.data << Gnuplot::DataSet.new( [x, x.map {|v| v * 2 }] )
    end

    mp.plot do |plot|
      plot.data << Gnuplot::DataSet.new( [x, x.map {|v| v * 4 }] )
    end
  end
end
```

Options for multiplot may also be passed in as a gnuplot-ready String:

```ruby
Gnuplot::Multiplot.new(gp, %Q{layout 2,1 title "some title"}) do |mp|
  ...
end
```

## Options

    title: String,
    font: String (fontspec),
    enhanced: true/false,   # noenhanced if false
    layout: [num_rows,num_cols],
    rowsfirst: true/false,  # columnsfirst if false
    downwards: true/false,  # upwards if false
    scale: Float (xscale)   || [Float (xscale), Float (yscale)],
    offset: Float (xoffset) || [Float (xoffset), Float (yoffset)],
