require 'net/http'
require 'uri'
require 'rubygems'
require 'json'

class CheckvistApi

  def initialize email = nil, api_key = nil, site = "http://checkvist.com"
    @email = email
    @api_key = api_key
    @url = URI.parse(site)
  end

  # Obtain a list of checklists
  def checklists()
    json_call Net::HTTP::Get.new("/checklists.json")
  end

  # Obtain a list of archived checklists
  def archived_checklists()
    json_call Net::HTTP::Get.new("/checklists.json"), archived: true
  end

  # Gets a list as opml
  def checklist_opml(checklist_id)
    http_call Net::HTTP::Get.new("/checklists/#{checklist_id}.opml"), 
    {
      export_status:    true,
      export_notes:     true,
      export_details:   true,
      export_color:     true
    }
  end
  
  private 

    def json_call request, parameters = nil
      JSON.parse(http_call(request, parameters))
    end

    def http_call request, parameters = nil
      request.basic_auth @email, @api_key if @email
      request.set_form_data(parameters) if parameters
      
      response = Net::HTTP.start(@url.host, @url.port) do |http|
        http.request(request)
      end
      
      case response
      when Net::HTTPSuccess
        response.body
      else
        response.error!
      end
    end
end