defmodule ShopWeb.LogoutController do
  use ShopWeb, :controller

  import Plug.Conn, only: [get_session: 2, clear_session: 1, configure_session: 2]

  def index(conn, _params) do
    conn
    |> delete_session_token(get_session(conn, :session_uuid))
    |> clear_session()
    |> configure_session(drop: true)
    |> redirect(to: Routes.login_path(conn, :index))
  end

  def delete_session_token(conn, nil), do: conn

  def delete_session_token(conn, session_id) do
    :ets.delete(:shop_auth_table, :"#{session_id}")

    conn
  end
end
