defmodule BitpadWeb.TelegramController do
  use BitpadWeb, :controller

  def oauth(conn, params) do
    %{
      "auth_date" => "1711890228",
      "first_name" => "Павел",
      "hash" => "7dca6a580710a0bafbfaca0a17bff65c7944c52522eac24cae9dc3934badf853",
      "id" => "732499933",
      "photo_url" => "https://t.me/i/userpic/320/vJ7NPvXLhlJe6Z66t7FXs89WZiVqyKopdcPd-60JbOc.jpg",
      "username" => "emfy0"
    }
    require IEx; IEx.pry
  end
end

