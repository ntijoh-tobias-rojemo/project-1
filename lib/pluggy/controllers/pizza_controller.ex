defmodule Pluggy.PizzaController do
  require IEx

  alias Pluggy.Pizza
  alias Pluggy.Ingredient
  import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3]

  def index(conn) do
    send_resp(conn, 200, render("index", pizzas: Pizza.all(), ingredients: Ingredient.all()))
  end
end
