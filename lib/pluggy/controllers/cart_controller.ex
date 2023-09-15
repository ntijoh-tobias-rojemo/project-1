defmodule Pluggy.CartController do
  require IEx

  alias Pluggy.Pizza
  alias Pluggy.Ingredient
  import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3]

  def index(conn) do
    send_resp(conn, 200, render("cart/index", ingredients: Ingredient.all(), pizzas: Pizza.all()))
  end

  def confirm(conn) do
    send_resp(conn, 200, render("cart/confirm", ingredients: Ingredient.all(), pizzas: Pizza.all()))
  end
end
