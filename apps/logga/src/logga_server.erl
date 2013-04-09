%%%'   HEADER
%%% @author Peter Bruinsma <peter@23min.com> 
%%% @since 
%%% @copyright 2013 Peter Bruinsma
%%% @doc 
%%% @end

-module(logga_server).
-behaviour(gen_server).
-define(SERVER, ?MODULE).

%% ~~~~~~~~~~~~~~~~~~~~
%% API Function Exports
%% ~~~~~~~~~~~~~~~~~~~~

-export([start_link/0, send/1]).

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% gen_server Function Exports
%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% ~~~~~~~~~~~~~~~~~~~~~~~~
%% API Function Definitions
%% ~~~~~~~~~~~~~~~~~~~~~~~~

send(Msg) ->
	gen_server:call(?SERVER, {message, Msg}).

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% gen_server Function Definitions
%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

init(_Args) ->
    {ok, Context} = erlzmq:context(),
	{ok, Publisher} = erlzmq:socket(Context, [push, {active, false}]),
	ok = erlzmq:bind(Publisher, "tcp://127.0.0.1:5561"),
	ok = erlzmq:setsockopt(Publisher, sndtimeo, 2000),
	{ok, Publisher}.

handle_call({message, Msg}, _From, Publisher) ->
	erlzmq:send(Publisher, Msg),
	Reply = ok,
	{reply, Reply, Publisher};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.
 	% {reply,Reply,NewState}
	% {reply,Reply,NewState,Timeout}
	% {reply,Reply,NewState,hibernate}
	% {noreply,NewState}
	% {noreply,NewState,Timeout}
	% {noreply,NewState,hibernate}
	% {stop,Reason,Reply,NewState}
	% {stop,Reason,NewState}

handle_cast(_Msg, State) ->
    {noreply, State}.
    % {noreply,NewState}
	% {noreply,NewState,Timeout}
	% {noreply,NewState,hibernate}
	% {stop,Reason,NewState}

handle_info({zmq, _S, Msg, []}, State) ->
	io:format("logga_sub_server handle_info!"),
	{noreply, State};
handle_info(_Info, State) ->
    {noreply, State}.
    % {noreply,NewState}
	% {noreply,NewState,Timeout}
	% {noreply,NewState,hibernate}
	% {stop,Reason,NewState}

terminate(_Reason, State) ->
	erlzmq:close(State),
	erlzmq:term(State),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% Internal Function Definitions
%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

