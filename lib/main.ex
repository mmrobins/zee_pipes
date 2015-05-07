defmodule ZeePipe do
  def init do
    :ok
  end

  def dna_count(sequence) do
    f = File.stream!('mss.csv')
    total = Enum.count(f)
    with_seq = f |> Enum.filter( fn(x) -> String.match?(x, ~r/#{sequence}/) end )
    female_count = count(with_seq, "female")
    IO.puts("female count")
    IO.inspect(female_count)

    male_count = count(with_seq, "male")
    IO.puts("male count")
    IO.inspect(male_count)
    Enum.count(with_seq)
  end
                                                                                                         def count(list, gender) do
    list |> Enum.map( fn(x) -> String.split(x, ~r/\",\"/) end)
        #|> Enum.filter( fn(x) -> foo = hd(tl(x)); IO.inspect(foo); IO.inspect(is_bitstring(foo)); to_string(foo) == "female" end)
         |> Enum.filter( fn(x) -> foo = hd(tl(x)); to_string(foo) == gender end)
         |> Enum.to_list
         |> Enum.count
  end
end
