class EventsController < ApplicationController
    before_action :authenticate_user!, only: [:new, :create]

    def index
        @events = Event.all
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
            redirect_to root
        end
    end

    private
    def send_json

        start_rfc = @event.start
        end_rfc = @event.end

        g_event = {
            'summary' => @event.summary,
            'description' => @event.description,
            'location' => @event.location,
            'start' => {
                'dateTime' => @event.start.to_datetime.rfc3339
            },
            'end' => {
                'dateTime' => @event.end.to_datetime.rfc3339
            },
            'attendees' => [{
                'email' => current_user.email
            }]
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
