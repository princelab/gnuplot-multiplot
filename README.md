# Gnuplot::Multiplot

Enhances the gnuplot gem with a simple interface to multiplot functionality.

## Installation

    gem install gnuplot-multiplot

gnuplot-multiplot includes gnuplot as a dependency, so you get both if you
install the multiplot gem.

## Examples

```ruby
require 'gnuplot/multiplot'

x = (0..50).collect { |v| v.to_f }
mult2 = x.map {|v| v * 2 }]
squares = x.map {|v| v * 4 }

Gnuplot.open do |gp|
  Gnuplot::Multiplot.new(gp, layout: [2,1]) do |mp|
    Gnuplot::Plot.new(mp) do |plot|
      plot.data << Gnuplot::DataSet.new( [x, mult2] )
    end

    Gnuplot::Plot.new(mp) do |plot|
      plot.data << Gnuplot::DataSet.new( [x, squares] )
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

## An inconsistent inferface?

The gnuplot gem is very object oriented.  Virtually no options are passed in
using a hash, as done here with multiplot.  To be consistent with the gnuplot
gem the various properties of multiplot should probably be set as attributes
similar to Gnuplot::DataSet.  However, given how gnuplot is currently
implemented, it would require several hacks to achieve (e.g., the first Plot
called would need to prompt the multiplot object to issue its commands).  This
gem's interface, while not as consistent with the current gnuplot gem as one
might like, is simple and minimally invasive.  To build something more
consistent with the current gnuplot interface would require a rewrite of
gnuplot, IMHO.

## Why not just pipe in the multiplot commands directly?

It's not hard to pipe in your own commands for a multiplot (it's even uglier
than this interface, of course), but you still have to alter the default
behavior of Plot.new to add in the necessary newlines between plots.  This gem
takes care of those necessary newlines.

## Copying

MIT License (see LICENSE)
