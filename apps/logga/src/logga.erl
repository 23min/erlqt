%%
%% logga.erl
%% logga entry point
%%

-module(logga).

-export([start/0, stop/0]).

ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.

%% @spec start() -> ok
%% @doc Start the some_app server.
start() ->
	%ensure_started(crypto),
	%ensure_started(ranch),
	%ensure_started(cowboy),
    ensure_started(logga).

%% @spec stop() -> ok
%% @doc Stop the some_app server.
stop() ->
    application:stop(logga).