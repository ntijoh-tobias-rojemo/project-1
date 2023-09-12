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
    Postgrex.query!(DB, "DROP TABLE IF EXISTS ordered_pizzas", [], pool: DBConnection.ConnectionPool)
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

    # Postgrex.query!(DB, "INSERT INTO fruits(name, tastiness) VALUES($1, $2)", ["Apple", 5],
    #   pool: DBConnection.ConnectionPool
    # )
  end
end
