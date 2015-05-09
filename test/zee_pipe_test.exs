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
end
