defmodule Doctest do
  use ExUnit.Case, async: true
  import NasaSpace.Fuel.FuelCalulation
  doctest NasaSpace.Fuel.FuelCalulation
end
