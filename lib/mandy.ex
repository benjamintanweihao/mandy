defmodule Mandy do
  @max_iterations 512
  @escape_radius  2
  @resolution     0.02

  def start do
    compute |> print
  end

  def compute do
    for y <- range(-2, 2, @resolution + 0.008) do
      for x <- range(-2, 2, @resolution) do
        compute {x, y}
      end
    end
  end

  def compute(c), do: compute({0, 0}, c, 0)
  def compute(_z, _c, @max_iterations), do: @max_iterations

  def compute({zr, zi}, {cr, ci}, iteration) do
    {:complex, zzr, zzi} = :complex.+(
                            :complex.pow(:complex.new(zr, zi), 2), 
                                         :complex.new(cr, ci))

    if :complex.abs(:complex.new(zzr, zzi)) > @escape_radius do
      iteration
    else
      compute({zzr, zzi}, {cr, ci}, iteration+1)
    end
  end

  def range(start, stop, step) do
    Stream.iterate(start, &(&1 + step)) |> 
    Stream.take_while(&(&1 <= stop))    |> 
    Enum.to_list
  end

  def print([row|rows]) do
    row 
      |> Enum.map(&(print_pixel(&1)))
      |> Enum.join 
      |> IO.puts

    print(rows)
  end

  def print([]), do: IO.puts ""

  def print_pixel(i) do
    IO.ANSI.format_fragment(["#{Enum.at(colors, color_index(i))}*"], true) 
  end

  def colors do
    [
      "\e[30m", # Gray
      "\e[31m", # Red
      "\e[32m", # Yello
      "\e[33m", # Orange
      "\e[34m", # Blue
      "\e[35m", # Magenta
      "\e[36m", # Green
      "\e[37m",
      "\e[36m",
      "\e[35m",
      "\e[34m",
    ] |> Stream.cycle
  end

  def color_index(0), do: 1
  def color_index(i) do
    {index, _} = Integer.parse("#{:math.log(i) / :math.log(2)}")
    index
  end

end
