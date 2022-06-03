defmodule NasaSpace.Fuel.FuelCalulation do
  @moduledoc """
  This module calculate fuel according to these parameters
  - Planets-gravity
  - Mass
  - Launch or Land
  directive input format [{:launch,9.807},{:land, 1.62}, {:launch, 1.62}, {:land, 9.807}]

  ## Examples

      iex> flight_path = [{:launch,9.807},{:land, 1.62}, {:launch, 1.62}, {:land, 9.807}] |> Enum.reverse()
      [{:land, 9.807},{:launch, 1.62},{:land, 1.62},{:launch,9.807}]
      iex> mass = 28801
      iex> params =%{"mass" => mass, "flight_path"=> flight_path}
      iex> calculate_fuel(params)
      {:ok, 51898}

      iex> flight_path = [{:launched,9.807},{:land, 1.62}, {:launch, 1.62}, {:land, 9.807}] |> Enum.reverse()
      [{:land, 9.807},{:launch, 1.62},{:land, 1.62},{:launched,9.807}]
      iex> mass = 28801
      iex> params =%{"mass" => mass, "flight_path"=> flight_path}
      iex> calculate_fuel(params)
      {:error, "invalid_directive"}


  """
  alias NasaSpace.FlightRouteRecursion

  @spec calculate_fuel(map) :: {:ok, integer} | {:error, String.t()}

  def calculate_fuel(%{"mass" => mass, "flight_path" => flight_route})
      when is_number(mass) and is_list(flight_route) do
    case FlightRouteRecursion.each(flight_route, mass) do
      {:ok, fuel_additional_mass} -> {:ok, fuel_additional_mass - mass}
      {:error, error} -> error
    end
  end

  def calculate_fuel(_params), do: {:error, "invalid_type"}

  @doc """
      ## Launch Formula
      - mass * gravity * 0.042 - 33
      ## Land Formula
      - mass * gravity * 0.033 - 42
  """

  def directive({:launch, gravity}, mass) do
    fuel_estimate = trunc(mass * gravity * 0.042 - 33)
    additional_fuel = directive_additional_fuel(fuel_estimate, gravity, :launch)
    launch_fuel_estimate = additional_fuel + fuel_estimate
    {:ok, launch_fuel_estimate}
  end

  def directive({:land, gravity}, mass) do
    fuel_estimate = trunc(mass * gravity * 0.033 - 42)
    additional_fuel = directive_additional_fuel(fuel_estimate, gravity, :land)
    land_fuel_estimate = additional_fuel + fuel_estimate
    {:ok, land_fuel_estimate}
  end

  def directive(_path, _mass) do
    {:error, "invalid_directive"}
  end

  defp directive_additional_fuel(mass, gravity, directive, additonal_fuel \\ 0) when mass > 0 do
    fuel_estimate =
      case directive do
        :launch -> trunc(mass * gravity * 0.042 - 33)
        :land -> trunc(mass * gravity * 0.033 - 42)
      end

    additonal_fuel =
      if fuel_estimate > 0 do
        fuel_estimate + additonal_fuel
      else
        additonal_fuel
      end

    directive_additional_fuel(fuel_estimate, gravity, directive, additonal_fuel)
  end

  defp directive_additional_fuel(mass, gravity, directive, additonal_fuel) do
    additonal_fuel
  end
end
