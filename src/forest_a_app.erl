%%%-------------------------------------------------------------------
%% @doc forest_a public API
%% @end
%%%-------------------------------------------------------------------

-module(forest_a_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/", customer_request_h, []}
        ]}
    ]),
    cowboy:start_clear(
        my_http_listener,
        [{port, 8080}],
        #{env => #{dispatch => Dispatch}}
    ),
    forest_a_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
