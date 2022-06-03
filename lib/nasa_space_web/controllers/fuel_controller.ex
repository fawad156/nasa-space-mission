defmodule NasaSpaceWeb.FuelController do
  use NasaSpaceWeb, :controller

  alias NasaSpace.Fuel.FuelCalulation
  alias NasaSpaceWeb.ErrorView

  def index(conn, _params) do
    render(conn, "index.html")
  end

  @doc """
    Examples
    -> Body params
    %{
      "mass" => 28801,
      "fuel_path" => [%{"launch" => 9.807},{"land" => 1.62},{"launch" => 1.62},{"land" => 9.807}]

    }
  """
  def calculate_fuel_for_trip(conn, _params) do
    params = conn.assigns.params_body

    case FuelCalulation.calculate_fuel(params) do
      {:ok, fuel_estimate} -> render(conn, "show.json", fuel_estimate: fuel_estimate)
      {:error, message} -> error(conn, message)
    end
  end

  def calculate_fuel_for_trip(conn, _params) do
    error(conn)
  end

  defp error(conn, message \\ "Invalid Params") do
    conn
    |> render(ErrorView, "400.json", error: message)
  end
end
