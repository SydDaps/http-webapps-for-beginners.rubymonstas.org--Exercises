require "erb"

class Email
  attr_reader :date, :from, :subject
    def initialize(subject, dateNfrom)
    @subject, @date, @from = subject, dateNfrom[:date], dateNfrom[:from]
    end
end

class Mailbox
  attr_reader :header, :emails
  def initialize(header, emails)
    @header = header
    @emails = emails
    @template = %(
      <html>
        <head>
          <style>
            table {
              border-collapse: collapse;
            }
            td, th {
              border: 1px solid black;
              padding: 1em;
            }
          </style>
        </head>
        <body>
          <h1><%= @header %></h1>
          <table>
            <thead>
              <tr>
                <th>Date</th>
                <th>From</th>
                <th>Subject</th>
              </tr>
            </thead>
            <tbody>
            <% @emails.each do |email| %>
              <tr>
              <td><%= email.date %></td>
              <td><%= email.from %></td>
              <td><%= email.subject %></td>
              </tr>
            <% end %>
            </tbody>
          </table>
        </body>
      </html>
          )
  end

  def render()
    ERB.new(@template).result(binding)
  end

end



emails = [
  Email.new("Homework this week", date: "2014-12-01", from: "Ferdous"),
  Email.new("Keep on coding! :)", date: "2014-12-01", from: "Dajana"),
  Email.new("Re: Homework this week", date: "2014-12-02", from: "Ariane")
]
mailbox = Mailbox.new("Ruby Study Group", emails)

html = mailbox.render()
puts html