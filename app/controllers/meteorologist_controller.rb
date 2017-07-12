require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("meteorologist/street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]

    # ==========================================================================
    # Your code goes below.
    #
    # The street address that the user typed is in the variable @street_address.
    # ==========================================================================

    part = @street_address.to_s.gsub(" ","+")
    
    url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + part
    
    parsed_data = JSON.parse(open(url).read)

    latitude = parsed_data["results"][0]["geometry"]["location"]["lat"].to_s

    longtitude = parsed_data["results"][0]["geometry"]["location"]["lng"].to_s
    
    weather_data = "https://api.darksky.net/forecast/8dd0bd1d1d17130a0f154f03c8a949d0/" + latitude + "," + longtitude
    
    parsed_data = JSON.parse(open(weather_data).read)

    @current_temperature = parsed_data.dig("currently","temperature")

    @current_summary = parsed_data.dig("currently","summary")

    @summary_of_next_sixty_minutes = parsed_data.dig("minutely","summary")

    @summary_of_next_several_hours = parsed_data.dig("hourly","summary")

    @summary_of_next_several_days = parsed_data.dig("daily","summary")

    render("meteorologist/street_to_weather.html.erb")
  end
end
