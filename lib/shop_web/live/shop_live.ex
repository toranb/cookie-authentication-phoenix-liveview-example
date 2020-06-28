defmodule ShopWeb.ShopLive do
  use ShopWeb, :live_view

  @impl true
  def render(assigns) do
    ~L"""
    <main>
      <p>Hello <%= @current_user.email %>! You are authenticated!</p>
    </main>
    """
  end

  @impl true
  def mount(_params, session, socket) do
    socket =
      assign_new(socket, :current_user, fn ->
        user_id = get_user_id(session)

        Shop.User
        |> Shop.Repo.get(user_id)
      end)

    {:ok, socket}
  end

  def get_user_id(%{"session_uuid" => session_uuid}) do
    case :ets.lookup(:shop_auth_table, :"#{session_uuid}") do
      [{_, token}] ->
        case Phoenix.Token.verify(ShopWeb.Endpoint, signing_salt(), token, max_age: 806_400) do
          {:ok, user_id} ->
            user_id

          _ ->
            nil
        end

      _ ->
        nil
    end
  end

  defp signing_salt() do
    ShopWeb.Endpoint.config(:live_view)[:signing_salt]
  end
end
