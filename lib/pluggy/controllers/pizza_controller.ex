defmodule Pluggy.PizzaController do
  require IEx

  alias Pluggy.Pizza
  alias Pluggy.Ingredient
  import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [put_resp_content_type: 2, send_resp: 3]
  import Bitwise

  @component_path Path.join(__DIR__, "../../../priv/static/components")

  def index(conn) do
    send_resp(conn, 200, render("index", pizzas: Pizza.all(), ingredients: Ingredient.all()))
  end

  def img(conn, ingredientStr) do
    {ingredients, _} = Integer.parse(ingredientStr)
    {:ok, baseImg} = File.read(Path.join(@component_path, "base"))
    {:ok, endImg} = File.read(Path.join(@component_path, "end"))

    ingredientImg =
      Ingredient.all()
      |> Enum.map(fn x -> x.id end)
      |> Enum.filter(fn x -> (ingredients &&& 1 <<< x) > 0 end)
      |> Enum.map(fn x -> File.read(Path.join(@component_path, Integer.to_string(x))) end)
      |> Enum.map(fn {:ok, content} -> content end)

    combined = [baseImg] ++ ingredientImg ++ [endImg]

    put_resp_content_type(conn, "image/svg+xml") |> send_resp(200, Enum.join(combined))
  end
end
