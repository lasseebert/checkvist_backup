require 'net/http'
require 'uri'
require 'rubygems'
require 'json'

class CheckvistApi

  # This class is mostly copied from http://checkvist.tumblr.com/post/187654104/openapi-javascript-ruby-example

  def initialize email = nil, api_key = nil, site = "http://checkvist.com"
    @email = email
    @api_key = api_key
    @url = URI.parse(site)
  end

  # Obtain a list of checklists
  def checklists()
    json_call Net::HTTP::Get.new("/checklists.json")
  end

  # Obtain a list of tasks for given checklist
  def tasks(checklist_id)
    json_call Net::HTTP::Get.new("/checklists/#{checklist_id}/tasks.json")
  end

  # create a task in given checklist
  def create_task(checklist_id, content, parent_task_id = nil, position = nil)
    json_call Net::HTTP::Post.new("/checklists/#{checklist_id}/tasks.json"), 
      { "task[parent_id]" => parent_task_id, 
        "task[position]" => position, 
        "task[content]" => content }
  end
  
  # update a task attribute. For task attributes, you can use "content", "parent_id", "position"
  def update_task_attribute(checklist_id, task_id, attr_name, attr_value)
    json_call Net::HTTP::Put.new("/checklists/#{checklist_id}/tasks/#{task_id}.json"), {"task[#{attr_name}]" => attr_value}
  end
  
  private 

    def json_call request, parameters = nil
      request.basic_auth @email, @api_key if @email
      request.set_form_data(parameters) if parameters
      
      res = Net::HTTP.start(@url.host, @url.port) { |http|
        http.request(request)
      }
      
      case res
      when Net::HTTPSuccess
        JSON.parse(res.body)
      else
        res.error!
      end
    end

    def opml_call
      # TODO
    end
end