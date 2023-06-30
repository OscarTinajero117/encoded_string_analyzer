defmodule EncodedStringAnalyzerWeb.EncodedLive.Index do
  use EncodedStringAnalyzerWeb, :live_view

  @impl true
  def mount(%{"message" => message}, _session, socket) do
    {:ok, assign(socket, :message, message)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div></div>
    """
  end
end
