defmodule Pluggy.Order do
  defstruct(id: nil, ordered: "", status: 0, pizzas: [])

  alias Pluggy.Order

  def all do
    Postgrex.query!(
      DB,
      "SELECT orders.id, ordered, status, ordered_pizzas.id, ingredients, template FROM orders INNER JOIN ordered_pizzas ON orders.id = order_id WHERE NOT status = 2",
      [],
      pool: DBConnection.ConnectionPool
    ).rows
    |> Enum.group_by(fn [x | _] -> x end)
    |> Map.values()
    |> Enum.map(fn x ->
      Enum.reduce(x, %Order{}, fn [id, ordered, status, pizza_id, ingredients, template], acc ->
        %{
          acc
          | id: id,
            ordered: ordered,
            status: status,
            pizzas: [%{id: pizza_id, ingredients: ingredients, template: template} | acc.pizzas]
        }
      end)
    end)
  end

  def create(order) do
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
  end

  def update(id, status) do
    Postgrex.query!(DB, "UPDATE orders SET status = $1 WHERE id = $2", [status, id])
  end
end
