defmodule ZeePipe do
  def init do
    :ok
  end

  def dna_count(sequence) do
    f = File.stream!('mss.csv')
    with_seq = f |> Enum.filter( fn(x) -> String.contains?(x, sequence) end )
    Enum.count(with_seq)
  end

  def gender_percentage(gender) do
    f = File.stream!('mss.csv')
    total = Enum.count(f)

    gender_count = count(f, gender)
    IO.puts("#{gender} count")
    IO.inspect(gender_count)
    IO.puts("#{gender} ratio")
    ratio = gender_count / total
    IO.inspect(ratio)

    ratio
  end

  def min_max_mean do
    f = File.stream!('mss.csv')

    weights = f |> pmap( fn(x) ->
      [ _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, weight, _14, _15, _16, _17 ] = String.split(x, "\",\"")
      #foo = String.split(x, ",")
      #IO.inspect Enum.count(foo)
      String.to_float(weight)
    end)

    min_weight = Enum.min(weights)
    max_weight = Enum.max(weights)
    #IO.inspect(Enum.take(weights, 15))
    total_weight = Enum.sum(weights)
    count = Enum.count(f)
    mean_weight = total_weight / count

    IO.puts "min weight"
    IO.inspect min_weight
    IO.puts "max weight"
    IO.inspect max_weight
    IO.puts "mean weight"
    IO.inspect mean_weight
    { min_weight, max_weight, mean_weight }
  end

  defp count(list, gender) do
    list |> Enum.filter( fn(x) -> String.match?(x, ~r/"#{gender}/) end )
         |> Enum.count
  end

  def pmap(collection, function) do
    # Get this process's PID
    me = self
    collection
      |> Stream.chunk(1000)
      |> Stream.map(fn (elem) ->
        spawn_link fn -> (send me, { self, Enum.map(elem, function) }) end
      end)
      |> Stream.flat_map(fn (pid) ->
        receive do { ^pid, result } -> result end
      end)
  end

  def pfilter(collection, function) do
    # Get this process's PID
    me = self
    collection
      |> Stream.chunk(1000)
      |> Stream.map(fn (elem) ->
        spawn_link fn -> (send me, { self, Enum.filter(elem, function) }) end
      end)
      |> Stream.flat_map(fn (pid) ->
        receive do { ^pid, result } -> result end
      end)
  end
end
