class EventsController < ApplicationController
    before_action :authenticate_user!, only: [:new, :create]

    def index
        @events = Event.all

    end

    def show
        @event = Event.find(params[:id])
    end

    def new
        @event = Event.new
        @g_event = Event.new
    end

    def create
        @event = Event.new
        @g_event = Event.new
        @g_event = {
            'summary' => @g_event.summary,
            'description' => @g_event.description,
            'location' => @g_event.location,
            'start' => @g_event.start,
            'end' => @g_event.end,
            'attendees' => @g_event.attendees.to_s.split(',').collect(&:strip)
        }

        client = Google::APIClient.new
        client.authorization.access_token = current_user.token
        service = client.discovered_api('calendar', 'v3')

        @set_event = client.execute(:api_method => service.events.insert,
                :parameters => {'calendarId' => current_user.email, 'sendNotifications' => true},
                :body => JSON.dump(@g_event),
                :headers => {'Content-Type' => 'application/json'})

        if @event.save
            redirect_to events_path
        else
            redirect_to root
        end
    end
end
