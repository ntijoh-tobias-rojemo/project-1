defmodule Pluggy.OrderController do
  require IEx

  alias Pluggy.Order
  alias Pluggy.Ingredient
  alias Pluggy.Pizza
  import Pluggy.Template, only: [render_no_template: 2]
  import Plug.Conn, only: [send_resp: 3]

  def index(conn) do
    if conn.remote_ip == {127, 0, 0, 1} do
      send_resp(
        conn,
        200,
        render_no_template("orders/index",
          ingredients: Ingredient.all(),
          pizzas: Pizza.all(),
          orders: Order.all()
        )
      )
    else
      send_resp(conn, 403, "Access denied")
    end
  end

  def add(conn) do
    order =
      conn.body_params["order"]
      |> String.split("§§")
      |> Enum.map(fn x -> String.split(x, "§") end)

    Order.create(order)

    redirect(conn, "/")
  end

  def update(conn, idStr, statusStr) do
    {id, _} = Integer.parse(idStr)
    {status, _} = Integer.parse(statusStr)
    Order.update(id, status)

    redirect(conn, "/orders")
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end
end
