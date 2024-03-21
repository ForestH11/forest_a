%% @doc Customer request handler.
-module(update_price_h).

-export([init/2]).

init(Req0, Opts) ->
    Data = <<"{\"apple\":3.0,\"bannana\":2.15}">>,
    % {ok,Data,_} = cowboy_req:read_body(Req0),
    %expecting an array with some number of grocery 
    %%items in quotes
    Price_update = jsx:decode(Data),
    % io:format("~p~n",[Price_update]),
    Response = case erpc:call('b@64.23.134.161',update_price_server,set_prices_of,[Price_update]) of
        ok -> 200;
        _ -> 500
    end,
    Req = cowboy_req:reply(Response, Req0),
    {ok, Req, Opts}.
% <<"[\"a\",\"list\",\"of\",\"words\"]">>