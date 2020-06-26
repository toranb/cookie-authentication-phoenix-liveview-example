defmodule ShopWeb.Plug.Session do
  import Plug.Conn, only: [get_session: 2, put_session: 3, halt: 1, assign: 3]
  import Phoenix.Controller, only: [redirect: 2]

  def redirect_unauthorized(conn, _opts) do
    user_id = Map.get(conn.assigns, :user_id)

    if user_id == nil do
      conn
      |> put_session(:return_to, conn.request_path)
      |> redirect(to: ShopWeb.Router.Helpers.login_path(conn, :index))
      |> halt()
    else
      conn
    end
  end

  def validate_session(conn, _opts) do
    case :ets.lookup(:shop_auth_table, :user_id) do
      [{_, user_id}] ->
        assign(conn, :user_id, user_id)

      _ ->
        conn
    end
  end
end
