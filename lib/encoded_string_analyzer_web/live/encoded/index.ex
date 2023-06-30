defmodule EncodedStringAnalyzerWeb.EncodedLive.Index do
  use EncodedStringAnalyzerWeb, :live_view

  alias EncodedStringAnalyzer.Analyzer

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(:message, "")
      |> assign(:response, "")
      |> assign(:message_form, to_form(%{"message" => ""}))
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header class="text-center">
      Analizador de Cadena Codificada
    </.header>

    <div class="space-y-12 divide-y">
      <div>
        <.simple_form for={@message_form} id="message_form" phx-submit="submit">
          <.input field={@message_form[:message]} type="text" label="Cadena" required />
          <:actions>
            <.button phx-disable-with="Analizando...">Analizar</.button>
          </:actions>
        </.simple_form>
      </div>

      <div class="mt-4">
        <div class="text-center">
          <h2 class="text-2xl font-bold">Solución</h2>
        </div>
        <div class="mt-4">
          <.message_container title="Cadena" message={@message} />
          <.message_container title="Respuesta" message={@response} />
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("submit", %{"message" => message}, socket) do
    case Analyzer.analyze(message) do
      {:ok, response} ->
        {:noreply, assign(socket, message: message, response: response_json(response))}

      {:error, error} ->
        {:noreply, assign(socket, message: message, response: error )}
    end
  end

  defp response_json(response) do
    response
    |> Jason.encode!
    |> String.replace(":", " : ")
    |> String.replace(",", " , ")
  end

  attr :title, :string, required: true
  attr :message, :string, required: true
  defp message_container(assigns) do
    ~H"""
    <div class="text-center">
      <span class="font-bold"><%= @title %>:</span>
      <span class="ml-2"><%= @message %></span>
    </div>
    """
  end
end
