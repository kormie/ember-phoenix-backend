defmodule Backend.MessageView do
  use Backend.Web, :view
  require Backend.RoomChannel

  def render("index.json", %{messages: messages}) do
    %{messages: render_many(messages, Backend.MessageView, "message.json")}
  end

  def render("show.json", %{message: message}) do
    %{message: render_one(message, Backend.MessageView, "message.json")}
  end

  def render("message.json", %{message: message}) do
    %{id: message.id,
      body: message.body}
  end
end
