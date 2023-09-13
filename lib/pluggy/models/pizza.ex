defmodule Pluggy.Pizza do
  defstruct(id: nil, name: "", price: 0, ingredients: 0)

  alias Pluggy.Pizza

  def all do
    Postgrex.query!(DB, "SELECT id, name, price, ingredients FROM pizzas", [],
      pool: DBConnection.ConnectionPool
    ).rows
    |> to_struct_list
  end

  def get(id) do
    Postgrex.query!(
      DB,
      "SELECT id, name, price, ingredients FROM pizzas WHERE id = $1 LIMIT 1",
      [String.to_integer(id)],
      pool: DBConnection.ConnectionPool
    ).rows
    |> to_struct
  end

  def to_struct([[id, name, price, ingredients]]) do
    %Pizza{id: id, name: name, price: price, ingredients: ingredients}
  end

  def to_struct_list(rows) do
    for [id, name, price, ingredients] <- rows,
        do: %Pizza{id: id, name: name, price: price, ingredients: ingredients}
  end
end
