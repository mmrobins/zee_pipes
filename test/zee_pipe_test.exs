defmodule ZeePipeTest do
  use ExUnit.Case

  @tag timeout: 100000
  test "DNA sequence count" do
    assert ZeePipe.dna_count("TAGTAAG") == 22154
  end

  #test "female gender ratio" do
  #  assert ZeePipe.gender_percentage("female") == 0.495195
  #end

  #test "male gender ratio" do
  #  assert ZeePipe.gender_percentage("male") == (1.0 - 0.495195)
  #end

  #test "min max mean" do
  #  assert ZeePipe.min_max_mean_weights == { 1, 2, 3 }
  #end

  @tag timeout: 100000
  test "find stuff out" do
    { min, max, mean, fem, male, seq } = ZeePipe.all_results("TAGTAAG")
    assert min == 96.8
    assert max == 257.4
    assert_in_delta(mean, 178.2, 1)
    assert_in_delta(fem, 0.495, 0.01)
    assert_in_delta(male, 0.505, 0.01)
    assert seq == 22154
  end
end
