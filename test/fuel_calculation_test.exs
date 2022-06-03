defmodule FuelCalulationTest do
  use ExUnit.Case, async: true
  import NasaSpace.Fuel.FuelCalulation

  @flight_path_1 [{:launch, 9.807}, {:land, 1.62}, {:launch, 1.62}, {:land, 9.807}]
                 |> Enum.reverse()
  @mass_1 28801
  @mass_2 "28801"
  @flight_path_2 [{:launched, 9.807}, {:land, 1.62}, {:launch, 1.62}, {:land, 9.807}]
                 |> Enum.reverse()

  describe "Testing some cases for fuel calculate of space trip using mass and fuel_path" do
    setup :define_test_data_1

    test "Doing Fuel calculate with correct params mass & fuel_path", test_data do
      calculate_fuel(test_data) == {:ok, 51898}
    end

    setup :define_test_data_2

    test "Doing Fuel calculate with wrong mass and flight_path type", test_data do
      calculate_fuel(test_data) == {:error, "invalid_type"}
    end

    setup :define_test_data_3

    test "Doing Fuel calculate with only wrong flight_path", test_data do
      calculate_fuel(test_data) == {:error, "invalid_directive"}
    end
  end

  defp define_test_data_1(_context) do
    %{"mass" => @mass_1, "flight_path" => @flight_path_1}
  end

  defp define_test_data_2(_context) do
    %{"mass" => @mass_2, "flight_path" => @flight_path_2}
  end

  defp define_test_data_3(_context) do
    %{"mass" => @mass_1, "flight_path" => @flight_path_2}
  end
end
