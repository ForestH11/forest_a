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
            {"/", default_page_h, []},
            {"/customer_request", customer_request_h, []},
            {"/update_price", update_price_h, []}
        ]}
    ]),
    PrivDir = code:priv_dir(forest_a),
	%tls stands for transport layer security
        {ok,_} = cowboy:start_tls(https_listener, [
                  		{port, 443},
				{certfile, PrivDir ++ "/ssl/fullchain.pem"},
				{keyfile, PrivDir ++ "/ssl/privkey.pem"}
              		], #{env => #{dispatch => Dispatch}}),
    forest_a_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
