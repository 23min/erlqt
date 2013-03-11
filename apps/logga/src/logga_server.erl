%%%'   HEADER
%%% @author Peter Bruinsma <peter@23min.com> 
%%% @since 
%%% @copyright 2013 Peter Bruinsma
%%% @doc 
%%% @end

-module(logga_server).
-behaviour(gen_server).
-define(SERVER, ?MODULE).

-include("document.hrl").

%% ~~~~~~~~~~~~~~~~~~~~
%% API Function Exports
%% ~~~~~~~~~~~~~~~~~~~~

-export([start_link/0, test_db/0, test_read/0]).

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% gen_server Function Exports
%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% ~~~~~~~~~~~~~~~~~~~~~~~~
%% API Function Definitions
%% ~~~~~~~~~~~~~~~~~~~~~~~~

test_db() ->
	Res = insert(),
	case Res of
		{atomic, ResultOfFun} ->
			ok;
		{aborted, Reason} ->
			io:format("Transaction aborted ~w~n", [Reason]),
			{error, Reason}
	end.

test_read() ->
	Res = read(),
	case Res of
		{atomic, ResultOfFun} ->
			ok, ResultOfFun;
		{aborted, Reason} ->
			io:format("Transaction aborted ~w~n", [Reason]),
			{error, Reason}
	end.

insert() ->
	T = fun() ->
		X = #document{id="", doc="test document", timestamp="1967-02-21"},
		mnesia:write(X)
	end,
	mnesia:transaction(T).

read() ->
	R = fun() ->
		mnesia:read(document, [], write)
	end,
	mnesia:transaction(R).

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% gen_server Function Definitions
%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

init(Args) ->
    {ok, Args}.

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

handle_info(_Info, State) ->
    {noreply, State}.
    % {noreply,NewState}
	% {noreply,NewState,Timeout}
	% {noreply,NewState,hibernate}
	% {stop,Reason,NewState}

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% Internal Function Definitions
%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

