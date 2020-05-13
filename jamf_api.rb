class JamfApi < BaseApi
  def initialize
    super("https://upstart.jamfcloud.com/JSSResource")
  end

  def get_users
    response = get("/users", base_options)
    response
  end

  def get_accounts
    response = get("/accounts", base_options)
    response
  end

  private

  def base_options
    options = {}
    options[:headers] = {
      accept: "application/xml",
      authorization: "Basic #{ENV["JAMF_BASE64"]}",
      "content-type" => "application/xml"
    }
    options
  end
end
