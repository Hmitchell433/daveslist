defmodule DaveslistWeb.Broadcaster do

  def to_user(user_id, event, payload \\ %{}) do
    IO.inspect("###user######")
    IO.inspect(user_id, label: "users:")
    IO.inspect(event, label: "event:")
    IO.inspect(payload, label: "payload")
    IO.inspect("#########")
    DaveslistWeb.Endpoint.broadcast("private_chat:#{user_id}", event, payload)
    :ok
  end
end
