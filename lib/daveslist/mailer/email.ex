defmodule Daveslist.Mailer.Email do
  use Bamboo.Phoenix, view: Daveslist.EmailView

  def welcome_text_email(email_address, code) do
    new_email(
      to: email_address,
      from: "daveslist@gmail.com",
      subject: "Verification Email",
      html_body:  """
      <html>
      <body>
       <b>Hello! </b> Thanks for registering. Click the link to verify your account. <a href= "http://localhost:4000/verify?w=#{code}">Activate</a>
      </body>
      </html>
      """,
      text_body: "Thanks for joining!"
    )
  end
end
