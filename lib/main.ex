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

  def all_results(seq_test) do
    f = File.stream!('mss.csv')

    seed = [
      99999999, # min
      0,        # max
      0,        # total
      0,        # row count
      0,        # female count
      0,        # male count
      0,        # match seq count
    ]

    result = Enum.reduce(f, seed, fn(x, acc) ->
      [ seq, gender, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, weight, _14, _15, _16, _17 ] = String.split(x, "\",\"")
      weight = String.to_float(weight)

      [ min_w, max_w, total_w, row_count, female, male, seq_count ] = acc

      male_match   = if String.contains?(gender, "female"), do: 0, else: 1
      female_match = if String.contains?(gender, "female"), do: 1, else: 0
      seq_match    = if String.contains?(seq, seq_test   ), do: 1, else: 0

      [
        min(min_w, weight),
        max(max_w, weight),
        total_w + weight,
        row_count + 1,
        female_match + female,
        male_match + male,
        seq_match + seq_count
      ]
    end)

    [ min_w, max_w, total_w, row_count, fem_count, male_count, match_seq ] = result


    #IO.puts "min weight"
    #IO.inspect min_w
    #IO.puts "max weight"
    #IO.inspect max_w
    #IO.puts "mean weight"
    #require IEx
    #IEx.pry
    mean_weight = total_w    / row_count
    fem_ratio   = fem_count  / row_count
    male_ratio  = male_count / row_count

    IO.inspect mean_weight
    { min_w, max_w, mean_weight, fem_ratio, male_ratio, match_seq }
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
