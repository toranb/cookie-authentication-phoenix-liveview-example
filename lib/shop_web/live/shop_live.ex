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
  def mount(_params, %{"user_id" => user_id}, socket) do
    socket = assign_new(socket, :current_user, fn ->
      Shop.User
      |> Shop.Repo.get(user_id)
    end)

    {:ok, socket}
  end
end
