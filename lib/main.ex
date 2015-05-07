defmodule ZeePipe do
  def init do
    :ok
  end

  def dna_count(sequence) do
    f = File.stream!('mss.csv')
    with_seq = f |> Enum.filter( fn(x) -> String.match?(x, ~r/#{sequence}/) end )
    Enum.count(with_seq)
  end

  def gender_percentages do
    f = File.stream!('mss.csv')
    total = Enum.count(f)

    female_count = count(f, "female")
    IO.puts("female count")
    IO.inspect(female_count)
    IO.puts("female ratio")
    IO.inspect(female_count / total)

    male_count = count(f, "male")
    IO.puts("male count")
    IO.inspect(male_count)
    IO.puts("male ratio")
    IO.inspect(male_count / total)
  end

  def min_max_mean_weights do
    f = File.stream!('mss.csv')

    weights = f |> Stream.map( fn(x) -> String.split(x, ~r/\",\"/) end)
                |> Stream.map( fn(x) -> {:ok, weight} = Enum.fetch(x, 12); String.to_float(weight) end)

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
  end

  def count(list, gender) do
    list |> Enum.map( fn(x) -> String.split(x, ~r/\",\"/) end)
        #|> Enum.filter( fn(x) -> foo = hd(tl(x)); IO.inspect(foo); IO.inspect(is_bitstring(foo)); to_string(foo) == "female" end)
         |> Enum.filter( fn(x) -> foo = hd(tl(x)); to_string(foo) == gender end)
         |> Enum.to_list
         |> Enum.count
  end
end
