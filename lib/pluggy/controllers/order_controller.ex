defmodule Pluggy.OrderController do
  require IEx

  import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3]

  def add(conn) do
    order =
      conn.body_params["order"]
      |> String.split("§§")
      |> Enum.map(fn x -> String.split(x, "§") end)

    %{rows: [[order_id]]} =
      Postgrex.query!(DB, "INSERT INTO orders (status) VALUES (0) RETURNING id", [],
        pool: DBConnection.ConnectionPool
      )

    for [templateStr, _name, ingredientsStr, _price] <- order do
      {ingredients, _} = Integer.parse(ingredientsStr)
      {template, _} = Integer.parse(templateStr)

      Postgrex.query!(
        DB,
        "INSERT INTO ordered_pizzas (order_id, ingredients, template) VALUES ($1, $2, $3)",
        [order_id, ingredients, template],
        pool: DBConnection.ConnectionPool
      )
    end

    redirect(conn, "/")
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end
end
