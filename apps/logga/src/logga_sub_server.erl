%%%'   HEADER
%%% @author Peter Bruinsma <peter@23min.com> 
%%% @since 
%%% @copyright 2013 Peter Bruinsma
%%% @doc 
%%% @end

-module(logga_sub_server).
-behaviour(gen_server).
-define(SERVER, ?MODULE).

%% ~~~~~~~~~~~~~~~~~~~~
%% API Function Exports
%% ~~~~~~~~~~~~~~~~~~~~

-export([start_link/0, accept_loop/1]).

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% gen_server Function Exports
%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% ~~~~~~~~~~~~~~~~~~~~~~~~
%% API Function Definitions
%% ~~~~~~~~~~~~~~~~~~~~~~~~

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% gen_server Function Definitions
%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

init(_Args) ->
	%process_flag(trap_exit, true),
	%{ok, Context} = erlzmq:context(),
	%{ok, Subscriber} = erlzmq:socket(Context, [pull, {active_pid, self()}]),
	%ok = erlzmq:connect(Subscriber, "tcp://127.0.0.1:5561"),
	%Pid = proc_lib:spawn_link(?MODULE, accept_loop, [Subscriber]),

	State = {foo},
    {ok, State}.

accept_loop(Subscriber) ->
	%erlzmq:send(Subscriber, <<"Anything">>),
	{ok, Msg} = erlzmq:recv(Subscriber),
	io:format("Message received: ~p", [Msg]),
	accept_loop(Subscriber),
	ok.

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

handle_info({'EXIT', State, Reason}, State) ->
	io:format("'EXIT' received"),
	%{stop, Reason, undefined};
	accept_loop(State);
	%% Other handle_info/2 clauses
handle_info({zmq, _S, Msg, []}, State) ->
	io:format("logga_sub_server handle_info! ~p", [Msg]),

	{noreply, State};
handle_info(_Info, State) ->
	io:format("Message received"),
    {noreply, State}.
    % {noreply,NewState}
	% {noreply,NewState,Timeout}
	% {noreply,NewState,hibernate}
	% {stop,Reason,NewState}

terminate(_Reason, State) ->
	erlzmq:close(State),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% Internal Function Definitions
%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

