defmodule Pluggy.Ingredient do
  defstruct(id: nil, name: "", price: 0)

  alias Pluggy.Ingredient

  def all do
    Postgrex.query!(DB, "SELECT id, name, price FROM ingredients", [],
      pool: DBConnection.ConnectionPool
    ).rows
    |> to_struct_list
  end

  def get(id) do
    Postgrex.query!(
      DB,
      "SELECT id, name, price FROM ingredients WHERE id = $1 LIMIT 1",
      [String.to_integer(id)],
      pool: DBConnection.ConnectionPool
    ).rows
    |> to_struct
  end

  def to_struct([[id, name, price]]) do
    %Ingredient{id: id, name: name, price: price}
  end

  def to_struct_list(rows) do
    for [id, name, price] <- rows,
        do: %Ingredient{id: id, name: name, price: price}
  end
end
