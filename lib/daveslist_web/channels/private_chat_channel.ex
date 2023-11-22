defmodule DaveslistWeb.PrivateChatChannel do
  use DaveslistWeb, :channel

  alias Daveslist.Context.{UserManager, Chat}
  alias DaveslistWeb.Broadcaster
  alias Phoenix.Socket

  @impl true
  def join("private_chat:"<>user_id, payload, socket) do
    if UserManager.is_registered_user?(user_id) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("send", payload, %Socket{assigns: %{user_id: user_id}} = socket) do
    Broadcaster.to_user(payload["to"], "send", payload)
    params = %{to: payload["to"], message: payload["message"], from: user_id}
    #save the chat in DB
    Chat.create(params)
    {:reply, :ok, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (private_chat:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

end
