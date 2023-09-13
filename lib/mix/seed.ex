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
      "CREATE TABLE orders (id SERIAL PRIMARY KEY, status INTEGER NOT NULL, ordered TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, customer VARCHAR(255) NOT NULL, price INTEGER NOT NULL)",
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

    Postgrex.query!(DB, "INSERT INTO ingredients(name, price) VALUES($1, $2)", ["Skinka", 999],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(DB, "INSERT INTO ingredients(name, price) VALUES($1, $2)", ["Oliver", 1999],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(DB, "INSERT INTO ingredients(name, price) VALUES($1, $2)", ["Tomatsås", 499],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "INSERT INTO ingredients(name, price) VALUES($1, $2)",
      ["Mozzarella", 499],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(DB, "INSERT INTO ingredients(name, price) VALUES($1, $2)", ["Basilika", 499],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(DB, "INSERT INTO ingredients(name, price) VALUES($1, $2)", ["Svamp", 1499],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "INSERT INTO ingredients(name, price) VALUES($1, $2)",
      ["Kronärtskocka", 999],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(DB, "INSERT INTO ingredients(name, price) VALUES($1, $2)", ["Parmesan", 2999],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(DB, "INSERT INTO ingredients(name, price) VALUES($1, $2)", ["Pecorino", 999],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "INSERT INTO ingredients(name, price) VALUES($1, $2)",
      ["Gorgonzola", 1499],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(DB, "INSERT INTO ingredients(name, price) VALUES($1, $2)", ["Paprika", 999],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(DB, "INSERT INTO ingredients(name, price) VALUES($1, $2)", ["Aubergine", 999],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(DB, "INSERT INTO ingredients(name, price) VALUES($1, $2)", ["Zucchini", 999],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(DB, "INSERT INTO ingredients(name, price) VALUES($1, $2)", ["Salami", 1999],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(DB, "INSERT INTO ingredients(name, price) VALUES($1, $2)", ["Chili", 999],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "INSERT INTO ingredients(name, price) VALUES($1, $2)",
      ["Familjepizza", 0],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(DB, "INSERT INTO ingredients(name, price) VALUES($1, $2)", ["Glutenfri", 0],
      pool: DBConnection.ConnectionPool
    )

    ingredient_ids = get_ingredient_ids()

    Postgrex.query!(
      DB,
      "INSERT INTO pizzas(ingredients, name, price) VALUES($1, $2, $3)",
      [
        parse_to_bitfield(ingredient_ids, ["Tomatsås", "Mozzarella", "Basilika"]),
        "Margherita",
        10999
      ],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "INSERT INTO pizzas(ingredients, name, price) VALUES($1, $2, $3)",
      [parse_to_bitfield(ingredient_ids, ["Tomatsås"]), "Marinara", 10999],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "INSERT INTO pizzas(ingredients, name, price) VALUES($1, $2, $3)",
      [
        parse_to_bitfield(ingredient_ids, ["Tomatsås", "Mozzarella", "Skinka", "Svamp"]),
        "Prosciutto e funghi",
        12999
      ],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "INSERT INTO pizzas(ingredients, name, price) VALUES($1, $2, $3)",
      [
        parse_to_bitfield(ingredient_ids, [
          "Tomatsås",
          "Mozzarella",
          "Skinka",
          "Svamp",
          "Kronärtskocka",
          "Oliver"
        ]),
        "Quattro stagioni",
        13999
      ],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "INSERT INTO pizzas(ingredients, name, price) VALUES($1, $2, $3)",
      [
        parse_to_bitfield(ingredient_ids, [
          "Tomatsås",
          "Mozzarella",
          "Skinka",
          "Svamp",
          "Kronärtskocka"
        ]),
        "Capricciosa",
        12999
      ],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "INSERT INTO pizzas(ingredients, name, price) VALUES($1, $2, $3)",
      [
        parse_to_bitfield(ingredient_ids, [
          "Tomatsås",
          "Mozzarella",
          "Parmesan",
          "Pecorino",
          "Gorgonzola"
        ]),
        "Quattro formaggi",
        15999
      ],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "INSERT INTO pizzas(ingredients, name, price) VALUES($1, $2, $3)",
      [
        parse_to_bitfield(ingredient_ids, [
          "Tomatsås",
          "Mozzarella",
          "Paprika",
          "Aubergine",
          "Zucchini"
        ]),
        "Ortolana",
        11999
      ],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "INSERT INTO pizzas(ingredients, name, price) VALUES($1, $2, $3)",
      [
        parse_to_bitfield(ingredient_ids, ["Tomatsås", "Mozzarella", "Salami", "Paprika", "Chili"]),
        "Diavola",
        14999
      ],
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
