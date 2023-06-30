defmodule EncodedStringAnalyzerWeb.EncodedLive.Index do
  use EncodedStringAnalyzerWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :encoded, "")}
  end
end
