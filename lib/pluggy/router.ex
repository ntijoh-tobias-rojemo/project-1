defmodule Pluggy.Router do
  use Plug.Router
  use Plug.Debugger

  alias Pluggy.CartController
  alias Pluggy.FruitController
  alias Pluggy.PizzaController
  alias Pluggy.OrderController

  plug(Plug.Static, at: "/", from: :pluggy)
  plug(:put_secret_key_base)

  plug(Plug.Session,
    store: :cookie,
    key: "_pluggy_session",
    encryption_salt: "cookie store encryption salt",
    signing_salt: "cookie store signing salt",
    key_length: 64,
    log: :debug,
    secret_key_base:
      "-- LONG STRING WITH AT LEAST 64 BYTES -- LONG STRING WITH AT LEAST 64 BYTES --"
  )

  plug(:fetch_session)
  plug(Plug.Parsers, parsers: [:urlencoded, :multipart])
  plug(:match)
  plug(:dispatch)

  get("/", do: PizzaController.index(conn))
  get("/cart", do: CartController.index(conn))
  get("/confirm", do: CartController.confirm(conn))
  get("/orders", do: OrderController.index(conn))

  post("/orders/new", do: OrderController.add(conn))

  match _ do
    send_resp(conn, 404, "oops")
  end

  defp put_secret_key_base(conn, _) do
    put_in(
      conn.secret_key_base,
      "-- LONG STRING WITH AT LEAST 64 BYTES LONG STRING WITH AT LEAST 64 BYTES --"
    )
  end
end
