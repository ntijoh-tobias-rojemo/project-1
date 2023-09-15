import Bitwise

defmodule Mix.Tasks.Seed do
  use Mix.Task

  @shortdoc "Resets & seeds the DB."
  def run(_) do
    Mix.Task.run("app.start")
    drop_tables()
    create_tables()
    seed_data()
  end

  defp drop_tables() do
    IO.puts("Dropping tables")
    Postgrex.query!(DB, "DROP TABLE IF EXISTS fruits", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS users", [], pool: DBConnection.ConnectionPool)

    Postgrex.query!(DB, "DROP TABLE IF EXISTS ordered_pizzas", [],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(DB, "DROP TABLE IF EXISTS orders", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS pizzas", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS ingredients", [], pool: DBConnection.ConnectionPool)
  end

  defp create_tables() do
    IO.puts("Creating tables")

    Postgrex.query!(
      DB,
      "CREATE TABLE ingredients (id SERIAL PRIMARY KEY, name VARCHAR(255) NOT NULL, price INTEGER NOT NULL)",
      [],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "CREATE TABLE pizzas (id SERIAL PRIMARY KEY, ingredients INTEGER NOT NULL, name VARCHAR(255) NOT NULL, price INTEGER NOT NULL)",
      [],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "CREATE TABLE orders (id SERIAL PRIMARY KEY, status INTEGER NOT NULL, ordered TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)",
      [],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "CREATE TABLE ordered_pizzas (id SERIAL PRIMARY KEY, order_id INTEGER NOT NULL, ingredients INTEGER NOT NULL, template INTEGER NOT NULL, FOREIGN KEY (order_id) REFERENCES orders (id), FOREIGN KEY (template) REFERENCES pizzas (id))",
      [],
      pool: DBConnection.ConnectionPool
    )
  end

  defp seed_data() do
    IO.puts("Seeding data")

    insert_ingredient("Familjepizza", 0)
    insert_ingredient("Glutenfri", 0)

    insert_ingredient("Skinka", 999)
    insert_ingredient("Oliver", 1999)
    insert_ingredient("Tomatsås", 499)
    insert_ingredient("Mozzarella", 499)
    insert_ingredient("Basilika", 499)
    insert_ingredient("Svamp", 1499)
    insert_ingredient("Kronärtskocka", 999)
    insert_ingredient("Parmesan", 2999)
    insert_ingredient("Pecorino", 999)
    insert_ingredient("Gorgonzola", 1499)
    insert_ingredient("Paprika", 999)
    insert_ingredient("Aubergine", 999)
    insert_ingredient("Zucchini", 999)
    insert_ingredient("Salami", 1999)
    insert_ingredient("Chili", 999)

    ingredient_ids = get_ingredient_ids()

    insert_pizza(
      ingredient_ids,
      ["Tomatsås", "Mozzarella", "Basilika"],
      "Margherita",
      10999
    )

    insert_pizza(
      ingredient_ids,
      ["Tomatsås"],
      "Marinara",
      10999
    )

    insert_pizza(
      ingredient_ids,
      ["Tomatsås", "Mozzarella", "Skinka", "Svamp"],
      "Prosciutto e funghi",
      12999
    )

    insert_pizza(
      ingredient_ids,
      [
        "Tomatsås",
        "Mozzarella",
        "Skinka",
        "Svamp",
        "Kronärtskocka",
        "Oliver"
      ],
      "Quattro stagioni",
      13999
    )

    insert_pizza(
      ingredient_ids,
      [
        "Tomatsås",
        "Mozzarella",
        "Skinka",
        "Svamp",
        "Kronärtskocka"
      ],
      "Capricciosa",
      12999
    )

    insert_pizza(
      ingredient_ids,
      [
        "Tomatsås",
        "Mozzarella",
        "Parmesan",
        "Pecorino",
        "Gorgonzola"
      ],
      "Quattro formaggi",
      15999
    )

    insert_pizza(
      ingredient_ids,
      [
        "Tomatsås",
        "Mozzarella",
        "Paprika",
        "Aubergine",
        "Zucchini"
      ],
      "Ortolana",
      11999
    )

    insert_pizza(
      ingredient_ids,
      ["Tomatsås", "Mozzarella", "Salami", "Paprika", "Chili"],
      "Diavola",
      14999
    )
  end

  defp insert_ingredient(name, price) do
    Postgrex.query!(DB, "INSERT INTO ingredients(name, price) VALUES($1, $2)", [name, price],
      pool: DBConnection.ConnectionPool
    )
  end

  defp insert_pizza(ingredient_ids, ingredients, name, price) do
    Postgrex.query!(
      DB,
      "INSERT INTO pizzas(ingredients, name, price) VALUES($1, $2, $3)",
      [parse_to_bitfield(ingredient_ids, ingredients), name, price],
      pool: DBConnection.ConnectionPool
    )
  end

  defp get_ingredient_ids() do
    %{rows: ingredient_ids} =
      Postgrex.query!(DB, "SELECT id, name FROM ingredients ORDER BY id", [])

    ingredient_ids |> Enum.reduce(%{}, fn [id, name], acc -> acc |> Map.put(name, id) end)
  end

  defp parse_to_bitfield(ingredient_ids, ingredients) do
    Enum.reduce(ingredients, 0, fn x, acc ->
      acc ||| 1 <<< Map.get(ingredient_ids, x)
    end)
  end
end
