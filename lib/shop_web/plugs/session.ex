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
    case get_session(conn, :session_uuid) do
      nil ->
        conn
        |> put_session(:session_uuid, Ecto.UUID.generate())

      session_uuid ->
        conn
        |> validate_session_token(session_uuid)
    end
  end

  def validate_session_token(conn, session_uuid) do
    case :ets.lookup(:shop_auth_table, :"#{session_uuid}") do
      [{_, token}] ->
        case Phoenix.Token.verify(ShopWeb.Endpoint, signing_salt(), token, max_age: 806_400) do
          {:ok, user_id} ->
            conn
            |> assign(:user_id, user_id)

          _ ->
            conn
        end

      _ ->
        conn
    end
  end

  def signing_salt do
    ShopWeb.Endpoint.config(:live_view)[:signing_salt] ||
      raise ShopWeb.AuthenticationError, message: "missing signing_salt"
  end
end
