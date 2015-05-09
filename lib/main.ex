defmodule ZeePipe do
  def init do
    :ok
  end

  def dna_count(sequence) do
    f = File.stream!('mss.csv')
    with_seq = f |> pfilter( fn(x) -> String.match?(x, ~r/#{sequence}/) end )
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

  def min_max_mean_weights do
    f = File.stream!('mss.csv')

    weights = f |> pfilter( fn(x) -> String.split(x, ~r/\",\"/) end)
                |> pfilter( fn(x) -> {:ok, weight} = Enum.fetch(x, 12); String.to_float(weight) end)

    min_weight = Enum.min(weights)
    max_weight = Enum.max(weights)
    #IO.inspect(Enum.take(weights, 15))
    mean_weight = Enum.sum(weights)
    total = Enum.count(f)
    IO.inspect(total)

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

  def pfilter(collection, function) do
    # Get this process's PID
    me = self
    collection
      |> Stream.chunk(50)
      |> Stream.map(fn (elem) ->
        spawn_link fn -> (send me, { self, Enum.filter(elem, function) }) end
      end)
      |> Enum.flat_map(fn (pid) ->
        receive do { ^pid, result } -> result end
      end)
  end
end
