%% @doc Customer request handler.
-module(customer_request_h).

-export([init/2]).

init(Req0, Opts) ->
    
    % Sample_Data = #{store1 => 45.55,store2 => 54.30},
    % Response = jsx:encode(Sample_Data),
    
    {ok,Data,_} = cowboy_req:read_body(Req0),
    %expecting an array with some number of grocery 
    %%items in quotes
    Price_list = jsx:decode(Data),
    % io:format("~p~n",[Price_list]),
    % Price_data = erpc:call('b@64.23.134.161',customer_request_server,get_prices_of,[Price_list]),
    Price_data = erpc:call('b@64.23.134.161', dispatch, customer,[Price_list]),
    % io:format("~p~n",[Price_data]),
    Response = jsx:encode(Price_data),
    Req = cowboy_req:reply(200, #{
        <<"content-type">> => <<"text/json">>
    }, Response, Req0),
    {ok, Req, Opts}.
% <<"[\"a\",\"list\",\"of\",\"words\"]">>