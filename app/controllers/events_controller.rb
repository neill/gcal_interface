class EventsController < ApplicationController
    before_action :authenticate_user!, only: [:new, :create, :index]

    def index
        @events = Event.all
        # This statement will provide a list of calendar events for the user.
        if user_signed_in?
            client = Google::APIClient.new
            client.authorization.access_token = current_user.token
            service = client.discovered_api('calendar', 'v3')

            @list_events = client.execute(
                :api_method => service.events.list,
                :parameters => {'calendarId' => current_user.email},
            ).data
        end
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
            redirect_to root_path
            flash[:error] = "There was an error creating your event."
        end
    end

    private
    def send_json
        g_event = {
            'summary' => @event.summary,
            'description' => @event.description,
            'location' => @event.location,
            'start' => { 'dateTime' => @event.start.to_datetime.rfc3339 },
            'end' => { 'dateTime' => @event.end.to_datetime.rfc3339 },
            'attendees' => [{ 'email' => current_user.email }]
            #@event.attendees.to_s.split(',').collect(&:strip)
        }

        client = Google::APIClient.new
        client.authorization.access_token = current_user.token
        service = client.discovered_api('calendar', 'v3')

        client.execute(
            :api_method => service.events.insert,
            :parameters => {'calendarId' => current_user.email },
            :body => JSON.dump(g_event),
            :headers => {'Content-Type' => 'application/json'})

    end

    def event_params
        params.require(:event).permit(:summary, :description, :location, :start, :end, :attendees).merge(:owner => current_user.id)
    end
end
