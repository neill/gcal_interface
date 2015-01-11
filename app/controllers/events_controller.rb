class EventsController < ApplicationController
    def index
        @events = Event.all

    end

    def show
        @event = Event.find(params[:id])
    end

    def new
        @event = Event.new
    end

    def create
        @g_event = {
            'summary' => @event.summary,
            'description' => @event.description,
            'location' => @event.location,
            'start' => @event.start,
            'end' => @event.end,
            'attendees' => @event.attendees.split(',').collect(&:strip)
        }

        client = Google::APIClient.new
        client.authorization.access_token = current_user.token
        service = client.discovered_api('calendar', 'v3')

        @set_event = client.execute(:api_method => service.events.insert,
                :parameters => {'calendarId' => current_user.email, 'sendNotifications' => true},
                :body => JSON.dump(@g_event),
                :headers => {'Content-Type' => 'application/json'})
    end
end
