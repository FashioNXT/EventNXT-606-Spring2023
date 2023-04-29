class GuestsImport
  include ActiveModel::Model

  attr_accessor :event_id, :api_key, :ticketing_website

  validates :event_id, presence: true
  validates :api_key, presence: true
  



  def valid
    return false unless valid?
  
  
  
    true
  end
  
def add_guests(guest_list)
  guest_list.each do |guest_data|
    guest = Guest.new_guest( first_name: guest_data['first_name'], last_name: guest_data['last_name'], email: guest_data['email'], event_id: event_id)
    guest.save
   
  end
  
end

end


  #guest_list = retrieve_guest_list
  
=begin
  private
  
  def retrieve_guest_list
    case ticketing_website
    when 'Ticketmaster'
      retrieve_guest_list_from_ticketmaster
    when 'Eventbrite'
      retrieve_guest_list_from_eventbrite
    else
      raise 'Unsupported ticketing website'
    end
  end
  
  
  
  
  def retrieve_guest_list_from_ticketmaster
    uri = URI("https://app.ticketmaster.com/partners/v1/events/#{event_id}/#{api_key}")
    params = { 'apikey' => api_key }
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)
    puts "Ticketmaster response: #{json.inspect}"
    json['guests']
  end
  
  def retrieve_guest_list_from_eventbrite
    uri = URI("https://www.eventbriteapi.com/v3/events/#{event_id}/attendees/")
    params = { 'token' => api_key }
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)
    puts "Eventbrite response: #{json.inspect}"
    json['attendees']
  end
=end




