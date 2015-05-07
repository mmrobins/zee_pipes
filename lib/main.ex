defmodule ZeePipe do
  def init do
    :ok
  end

  def dna_count(sequence) do
    f = File.stream!('mss.csv')
    with_seq = f |> Enum.filter( fn(x) -> String.match?(x, ~r/#{sequence}/) end )
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

    weights = f |> pmap( fn(x) -> String.split(x, ~r/\",\"/) end)
                |> pmap( fn(x) -> {:ok, weight} = Enum.fetch(x, 12); String.to_float(weight) end)

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

  def pmap(collection, function) do
    # Get this process's PID
    me = self
    collection
    |>
    Enum.map(fn (elem) ->
      # For each element in the collection, spawn a process and
      # tell it to:
      # - Run the given function on that element
      # - Call up the parent process
      # - Send the parent its PID and its result
      # Each call to spawn_link returns the child PID immediately.
      spawn_link fn -> (send me, { self, function.(elem) }) end
    end) |>
    # Here we have the complete list of child PIDs. We don't yet know
    # which, if any, have completed their work
    Enum.map(fn (pid) ->
      # For each child PID, in order, block until we receive an
      # answer from that PID and return the answer
      # While we're waiting on something from the first pid, we may
      # get results from others, but we won't "get those out of the
      # mailbox" until we finish with the first one.
      receive do { ^pid, result } -> result end
    end)
  end
end
