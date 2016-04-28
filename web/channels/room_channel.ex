defmodule Backend.RoomChannel do
  use Backend.Web, :channel
  require IEx

  def join("rooms:lobby", payload, socket) do
    if authorized?(payload) do
      messages =
        Repo.all(Backend.Message)
        |> Enum.map(fn message -> render_json("message", message) end)
      {:ok, %{messages: messages}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("new:message", payload, socket) do
    changeset = Backend.Message.changeset(%Backend.Message{}, payload)

    case Repo.insert(changeset) do
      {:ok, message} ->
        broadcast! socket, "new:message", render_json("message", message)
        {:noreply, socket}
      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (rooms:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # This is invoked every time a notification is being broadcast
  # to the client. The default implementation is just to push it
  # downstream but one could filter or change the event.
  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end

  defp render_json("message", message) do
    %{message: %{id: message.id, body: message.body} }
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
