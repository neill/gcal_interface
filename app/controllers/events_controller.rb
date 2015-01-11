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
    end

    def create
        @event = Event.new(event_params)

        if @event.save
            send_json
            redirect_to events_path
        else
            redirect_to root
        end
    end

    private
    def send_json

        @g_event = {
            'summary' => @event.summary,
            'description' => @event.description,
            'location' => @event.location,
            'start' => @event.start,
            'end' => @event.end,
            'attendees' => @event.attendees.to_s.split(',').collect(&:strip)
        }
        client = Google::APIClient.new
        client.authorization.access_token = current_user.token
        service = client.discovered_api('calendar', 'v3')

        @set_event = client.execute(:api_method => service.events.insert,
        :parameters => {'calendarId' => current_user.email, 'sendNotifications' => true},
        :body => JSON.dump(@g_event),
        :headers => {'Content-Type' => 'application/json'})
    end

    def event_params
        params.require(:event).permit(:summary, :description, :location, :start, :end, :attendees).merge(:owner => current_user.id)
    end
end
