defmodule ShopWeb.ShopLive do
  use ShopWeb, :live_view

  @impl true
  def render(assigns) do
    ~L"""
    <main>
      <p>Hello! You are authenticated!</p>
    </main>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
