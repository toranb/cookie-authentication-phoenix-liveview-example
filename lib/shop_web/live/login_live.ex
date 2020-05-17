defmodule ShopWeb.LoginLive do
  use ShopWeb, :live_view

  @impl true
  def render(assigns) do
    ~L"""
      Login Form Goes Here
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
